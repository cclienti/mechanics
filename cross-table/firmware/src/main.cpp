// This file is part of the cross-table project
// (https://github.com/cclienti/mechanics)
// Copyright (c) 2023 Christophe Clienti
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, version 3.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

#include "cross-table/lcd_menu.hpp"
#include "cross-table/buttons.hpp"
#include "cross-table/position.hpp"
#include "cross-table/stepper.hpp"
#include "cross-table/config.hpp"
#include "cross-table/sdcard_reader.hpp"
#include "cross-table/math_func.hpp"

#include "pico/stdio.h"

#include <cstdint>
#include <cstdio>
#include <cstdlib>


/**
 * @brief Move a motor to the desired axis position
 * @return the true axis position after move
 */
int move_motor(StepMotorDriver &step, Axis &axis, bool dry_run)
{
    std::uint32_t remaining {0};
    std::int32_t direction {0};

    auto pos = axis.rel_pulse_pos();

    if (pos > 0) {
        direction = 1;
    }
    else if (pos < 0) {
        direction = -1;
    }
    else {
        step.hold();
        return 0;
    }

    if (!dry_run) {
        remaining = step.rotate(direction, std::abs(pos));
    }

    axis.incr_pulse(remaining * direction * -1);
    return axis.rel_pulse_pos();
}

PulseUpdate move_motors(StepMotorDriver &step_x, StepMotorDriver &step_y, Position &pos, bool dry_run)
{
    int x = move_motor(step_x, pos.x, dry_run);
    int y = move_motor(step_y, pos.y, dry_run);
    pos.set_ref();
    return {x, y};
}

void release_motors(StepMotorDriver &step_x, StepMotorDriver &step_y)
{
    step_x.release();
    step_y.release();
}

int main() {
    stdio_init_all();

    LCDMenu lcd_menu;
    Position pos;
    PositionsHandler pos_handler;

    StepMotorDriver step_x(TableConfig::pin_step_x_pulse,
                           TableConfig::pin_step_x_dir,
                           TableConfig::pin_step_x_ena,
                           TableConfig::pin_step_limit_1);

    StepMotorDriver step_y(TableConfig::pin_step_y_pulse,
                           TableConfig::pin_step_y_dir,
                           TableConfig::pin_step_y_ena,
                           TableConfig::pin_step_limit_0);
    bool motor_dry_run = false;

    constexpr int splash_time = 2000;

    SDCardReader sdreader;
    std::vector<std::string> files;
    std::vector<PulseUpdate> list_positions;
    sdreader.list_files(files);

    release_motors(step_x, step_y);

    // ------------------------------------
    // Handle Position Display and Update
    // ------------------------------------
    auto manual_menu_entry_cb = [&pos, &step_x, &step_y, &lcd_menu, &pos_handler, &motor_dry_run]
        (char *buf, Buttons &buttons)
    {
        // Preload the first PulseUpdate if the PositionHandler has
        // been set.
        if (pos_handler.changed()) {
            pos.reset();
            pos_handler.next();
            pos_handler.update_rel_pos(pos);
        }

        // Handle +/- buttons for X/Y axis
        int pressed = static_cast<int>(buttons.x_minus.is_pressed());
        if (pressed != 0) {
            pos.x.incr_half_tenth(-1*pressed);
            release_motors(step_x, step_y);
        }

        pressed = static_cast<int>(buttons.x_plus.is_pressed());
        if (pressed != 0) {
            pos.x.incr_half_tenth(pressed);
            release_motors(step_x, step_y);
        }

        pressed = static_cast<int>(buttons.y_minus.is_pressed());
        if (pressed != 0) {
            pos.y.incr_half_tenth(-1*pressed);
             release_motors(step_x, step_y);
       }

        pressed = static_cast<int>(buttons.y_plus.is_pressed());
        if (pressed != 0) {
            pos.y.incr_half_tenth(pressed);
            release_motors(step_x, step_y);
      }

        // Handle Ok button
        if (buttons.ok.is_released()) {
            auto upd = move_motors(step_x, step_y, pos, motor_dry_run);
            pos_handler.commit(upd);
            if (pos_handler.next()) {
                pos_handler.update_rel_pos(pos);
            }
        }

        // Handle Reset button
        Switch::PressInfo press_info;
        buttons.reset.is_released(press_info);
        switch (press_info) {
        case Switch::PressInfo::Short:
            if (pos_handler.is_counter_pos(pos)) {
                move_motors(step_x, step_y, pos, motor_dry_run);
            }
            else {
                pos.rollback();
            }
            if (pos_handler.prev()) {
                pos_handler.revert_rel_pos(pos);
            }
            break;
        case Switch::PressInfo::Long:
            lcd_menu.splash("Reset positions?");
            while (true) {
                if (buttons.ok.is_released()) {
                    pos_handler.set({});
                    pos.reset();
                    release_motors(step_x, step_y);
                    lcd_menu.splash("Done", splash_time);
                    break;
                }
                if (buttons.reset.is_released()) {
                    lcd_menu.splash("Canceled", splash_time);
                    break;
                }
            }
            break;
        default:
            break;
        }

        pos.print(buf);
    };
    lcd_menu.register_display("<Position>", manual_menu_entry_cb);

    // ------------------------------------
    // Handle holes on a line dialog
    // ------------------------------------
    auto holes_on_a_line_entry_cb = [&list_positions, &pos_handler, &lcd_menu, &splash_time]
    (Switch::PressInfo ok_released, Switch::PressInfo reset_released, LCDMenu::EntryDialogItems &item)
    {
        if (ok_released == Switch::PressInfo::Short) {
            auto num_holes = std::get<int>(item[0].second);
            auto dist_x = millimeters_to_pulses(std::get<float>(item[1].second));
            auto dist_y = millimeters_to_pulses(std::get<float>(item[2].second));
            list_positions.clear();
            for (int i=0; i<num_holes; i++) {
                list_positions.emplace_back(dist_x, dist_y);
            }
            pos_handler.set(list_positions);
            lcd_menu.splash("Positions loaded", splash_time);
        }
    };
    lcd_menu.register_dialog(
        "<Line>", holes_on_a_line_entry_cb,
        {
            {"Num holes", 1},
            {"Dist X (mm)", 0.0F},
            {"Dist Y (mm)", 0.0F}
        }
    );

    // ------------------------------------
    // Handle holes on a grid
    // ------------------------------------
    auto holes_on_grid_entry_cb = [&list_positions, &pos_handler, &lcd_menu, &splash_time]
        (Switch::PressInfo ok_released, Switch::PressInfo reset_released, LCDMenu::EntryDialogItems &item)
    {
        if (ok_released == Switch::PressInfo::Short) {
            auto num_x_holes = std::get<int>(item[0].second);
            auto num_y_holes = std::get<int>(item[1].second);
            auto dist_x = std::get<float>(item[2].second);
            auto dist_y = std::get<float>(item[3].second);
            list_positions.clear();
            holes_on_grid(num_x_holes, num_y_holes, dist_x, dist_y, list_positions);
            lcd_menu.splash("Positions loaded", splash_time);
            pos_handler.set(list_positions);
        }
    };
    lcd_menu.register_dialog(
        "<Grid>", holes_on_grid_entry_cb,
        {
            {"Num X holes", 1},
            {"Num Y holes", 1},
            {"Dist X (mm)", 0.0F},
            {"Dist Y (mm)", 0.0F},
        }
    );

    // ------------------------------------
    // Handle holes on a circle
    // ------------------------------------
    auto holes_on_a_circle_entry_cb = [&list_positions, &pos_handler, &lcd_menu, &splash_time]
        (Switch::PressInfo ok_released, Switch::PressInfo reset_released, LCDMenu::EntryDialogItems &item)
    {
        if (ok_released == Switch::PressInfo::Short) {
            auto num_holes = std::get<int>(item[0].second);
            auto radius = std::get<float>(item[1].second);
            auto angle_offset = std::get<float>(item[2].second);
            list_positions.clear();
            holes_on_a_circle(num_holes, radius, angle_offset, list_positions);
            lcd_menu.splash("Positions loaded", splash_time);
            pos_handler.set(list_positions);
        }
    };
    lcd_menu.register_dialog(
        "<Circle>", holes_on_a_circle_entry_cb,
        {
            {"Num holes", 1},
            {"Radius (mm)", 0.0F},
            {"Angle (deg)", 0.0F}
        }
    );

    // ------------------------------------
    // Handle sdcard reading
    // ------------------------------------
    auto select1_menu_entry_cb = [&sdreader, &lcd_menu, &list_positions, &pos_handler, &splash_time]
        (const std::string value)
    {
        list_positions.clear();
        auto rc = sdreader.read_positions(value, list_positions);
            if (rc == SDCardReader::ReadPosRc::Ok) {
                lcd_menu.splash("Positions loaded", splash_time);
                pos_handler.set(list_positions);
            }
            else {
                lcd_menu.splash(SDCardReader::read_rc_info(rc), splash_time);
            }
    };
    lcd_menu.register_select("<Load from SD>", select1_menu_entry_cb, files);


    // ------------------------------------
    // Refresh loop
    // ------------------------------------
    while(true) {
        lcd_menu.refresh();
    }

    return 0;
}
