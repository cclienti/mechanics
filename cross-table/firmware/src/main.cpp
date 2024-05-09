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
#include <functional>
#include <algorithm>
#include <tuple>
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


int main() {
    Buttons buttons;
	LCDMenu lcd_menu;
    Position pos;

    StepMotorDriver step_x(16u, 17u, 18u, 14u);
    StepMotorDriver step_y(20u, 21u, 22u, 15u);
    step_x.release();
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
            pos.x.incr(-1*pressed);
        }

        pressed = buttons.x_plus.is_pressed();
        if (pressed) {
            pos.x.incr(pressed);
        }

        pressed = buttons.y_minus.is_pressed();
        if (pressed) {
            pos.y.incr(-1*pressed);
        }

        pressed = buttons.y_plus.is_pressed();
        if (pressed) {
            pos.y.incr(pressed);
        }

        if (buttons.ok.is_released()) {
            pos.y.incr(+1);
            step_x.hold();
            step_y.hold();
        }

        if (buttons.reset.is_released()) {
            pos.y.incr(-1);
            step_x.release();
            step_y.release();
        }
    }
    return 0;
}
