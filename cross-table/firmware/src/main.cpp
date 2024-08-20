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
    bool motor_dry_run = true;

    SDCardReader sdreader;
    std::vector<std::string> files;
    sdreader.list_files(files);
    step_x.release();
    step_y.release();

    // ------------------------------------
    // Handle Position Display and Update
    // ------------------------------------
    auto manual_menu_entry_cb = [&pos, &step_x, &step_y, &lcd_menu, &pos_handler, &motor_dry_run]
        (char *buf, Buttons &buttons)
    {
        // Preload the first PulseUpdate if the PositionHandler has
        // been set.
        if (pos_handler.changed()) {
            pos_handler.next();
            pos_handler.update_rel_pos(pos);
        }

        // Handle +/- buttons for X/Y axis
        int pressed = buttons.x_minus.is_pressed();
        if (pressed != 0) {
            pos.x.incr_half_tenth(-1*pressed);
        }

        pressed = buttons.x_plus.is_pressed();
        if (pressed != 0) {
            pos.x.incr_half_tenth(pressed);
        }

        pressed = buttons.y_minus.is_pressed();
        if (pressed != 0) {
            pos.y.incr_half_tenth(-1*pressed);
        }

        pressed = buttons.y_plus.is_pressed();
        if (pressed != 0) {
            pos.y.incr_half_tenth(pressed);
        }

        // Handle Ok button
        if (buttons.ok.is_released()) {
            auto up = move_motors(step_x, step_y, pos, motor_dry_run);
            pos_handler.commit(up);
            if (pos_handler.next()) {
                pos_handler.update_rel_pos(pos);
            }
        }

        // Handle Reset button
        if (buttons.reset.is_released()) {
            pos.rollback();
            if (pos_handler.prev()) {
                pos_handler.revert_rel_pos(pos);
                move_motors(step_x, step_y, pos, motor_dry_run);
            }
        }

        pos.print(buf);
    };
    lcd_menu.register_display("<Position>", manual_menu_entry_cb);

    // ------------------------------------
    // Handle holes on a line dialog
    // ------------------------------------
    auto dialog1_menu_entry_cb = []
        (bool ok, bool reset, LCDMenu::EntryDialogItems &item)
    {
        return;
    };
    lcd_menu.register_dialog(
        "<Line>", dialog1_menu_entry_cb,
        {
            {"Num Holes", 2},
            {"Offset-X", 1.0F},
            {"Offset-Y", 1.0F},
            {"Repeat-X", 1.0F},
            {"Repeat-Y", 1.0F}
        }
    );

    // ------------------------------------
    // Handle sdcard reading
    // ------------------------------------
    std::vector<PulseUpdate> list_positions;
    auto select1_menu_entry_cb = [&sdreader, &lcd_menu, &list_positions, &pos_handler]
        (const std::string value)
    {
        list_positions.clear();
        auto rc = sdreader.read_positions(value, list_positions);
            if (rc == SDCardReader::ReadPosRc::Ok) {
                lcd_menu.splash("Positions loaded", 2000);
                pos_handler.set(list_positions);
            }
            else {
                lcd_menu.splash(SDCardReader::read_rc_info(rc), 2000);
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
