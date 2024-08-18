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


void move_motor(StepMotorDriver &step, Axis &axis)
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
        return;
    }
    remaining = step.rotate(direction, std::abs(pos));
    axis.incr_pulse(remaining * direction * -1);
}


int main() {
	LCDMenu lcd_menu;
    Position pos;

    StepMotorDriver step_x(TableConfig::pin_step_x_pulse,
                           TableConfig::pin_step_x_dir,
                           TableConfig::pin_step_x_ena,
                           TableConfig::pin_step_limit_1);

    StepMotorDriver step_y(TableConfig::pin_step_y_pulse,
                           TableConfig::pin_step_y_dir,
                           TableConfig::pin_step_y_ena,
                           TableConfig::pin_step_limit_0);

    stdio_init_all();
    step_x.release();
    step_y.release();

    auto manual_menu_entry_cb = [&pos, &step_x, &step_y, &lcd_menu](char *buf, Buttons &buttons)
    {
        int pressed = buttons.x_minus.is_pressed();
        if (pressed != 0) {
            pos.x.incr_tenth(-1*pressed);
        }

        pressed = buttons.x_plus.is_pressed();
        if (pressed != 0) {
            pos.x.incr_tenth(pressed);
        }

        pressed = buttons.y_minus.is_pressed();
        if (pressed != 0) {
            pos.y.incr_tenth(-1*pressed);
        }

        pressed = buttons.y_plus.is_pressed();
        if (pressed != 0) {
            pos.y.incr_tenth(pressed);
        }

        if (buttons.ok.is_released()) {
            move_motor(step_x, pos.x);
            move_motor(step_y, pos.y);
            pos.set_ref();
            SDCardReader sdreader;
            std::vector<PulseUpdate> list;
            auto rc = sdreader.read_positions("cross-table.txt", list);
            if (rc == SDCardReader::ReadPosRc::Ok) {
                for (const PulseUpdate &pos: list) {
                    printf("x: %d, y: %d\n", pos.x, pos.y);
                }
            }
            else {
                printf("SDCardReader: %s\n", SDCardReader::read_rc_info(rc));
            }
        }

        if (buttons.reset.is_released()) {
            lcd_menu.splash("Ok for Reset");
            while (true) {
                if (buttons.ok.is_released()) {
                    pos.reset();
                    step_x.release();
                    step_y.release();
                    break;
                }
                if (buttons.reset.is_released()) {
                    break;
                }
            }
        }
        pos.print(buf);
    };

    auto auto_menu_entry_cb = [](char *buf, Buttons &buttons)
    {
        std::sprintf(buf, "Reading sdcard");
    };

    auto dialog1_menu_entry_cb = [](bool ok, bool reset, LCDMenu::EntryDialogItems &item)
    {
        return;
    };

    lcd_menu.register_display("<Manual>", manual_menu_entry_cb);
    lcd_menu.register_display("<Auto>", auto_menu_entry_cb);
    lcd_menu.register_dialog("<Dialog>", dialog1_menu_entry_cb, {{"key1", true}, {"key2", 1.0F}});

    while(true) {
        lcd_menu.refresh();
    }

    return 0;
}
