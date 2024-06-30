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

#include "cross-table/lcd_display.hpp"
#include "cross-table/lcd_menu.hpp"
#include "cross-table/switch.hpp"
#include "cross-table/position.hpp"
#include "cross-table/stepper.hpp"
#include "cross-table/config.hpp"

/*
#include "pico/stdlib.h"
#include "pico/time.h"
#include "hardware/gpio.h"
#include "hardware/pwm.h"
#include "hardware/clocks.h"
#include "hardware/resets.h"
*/
#include <cstdint>
#include <cstdio>


struct Buttons
{
    Buttons() :
        x_minus(TableConfig::pin_btn_x_minus, true),
        x_plus(TableConfig::pin_btn_x_plus, true),
        y_minus(TableConfig::pin_btn_y_minus, true),
        y_plus(TableConfig::pin_btn_y_plus, true),
        reset(TableConfig::pin_btn_reset, true),
        ok(TableConfig::pin_btn_ok, true),
        menu(TableConfig::pin_btn_menu, true)
    {}

	Switch x_minus;
	Switch x_plus;
	Switch y_minus;
	Switch y_plus;
	Switch reset;
	Switch ok;
    Switch menu;
};


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
    Buttons buttons;
	LCDMenu lcd_menu;
    Position pos;

    StepMotorDriver step_x(TableConfig::pin_step_x_pulse,
                           TableConfig::pin_step_x_dir,
                           TableConfig::pin_step_x_ena,
                           TableConfig::pin_step_limit_1);
    step_x.release();

    StepMotorDriver step_y(TableConfig::pin_step_y_pulse,
                           TableConfig::pin_step_y_dir,
                           TableConfig::pin_step_y_ena,
                           TableConfig::pin_step_limit_0);
    step_y.release();

    auto manual_menu_entry_cb = [&pos](char *buf) {
        pos.print(buf);
    };

    auto auto_menu_entry_cb = [](char *buf) {
        std::sprintf(buf, "Reading sdcard");
    };

    lcd_menu.register_menu("<Manual>", manual_menu_entry_cb);
    lcd_menu.register_menu("<Auto>", auto_menu_entry_cb);

    while(true) {
        int pressed;

        lcd_menu.refresh();
        if (buttons.menu.is_released()) {
            lcd_menu.switch_entry();
        }

        pressed = buttons.x_minus.is_pressed();
        if (pressed) {
            pos.x.incr_tenth(-1*pressed);
        }

        pressed = buttons.x_plus.is_pressed();
        if (pressed) {
            pos.x.incr_tenth(pressed);
        }

        pressed = buttons.y_minus.is_pressed();
        if (pressed) {
            pos.y.incr_tenth(-1*pressed);
        }

        pressed = buttons.y_plus.is_pressed();
        if (pressed) {
            pos.y.incr_tenth(pressed);
        }

        if (buttons.ok.is_released()) {
            move_motor(step_x, pos.x);
            move_motor(step_y, pos.y);
            pos.set_ref();
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
    }
    return 0;
}
