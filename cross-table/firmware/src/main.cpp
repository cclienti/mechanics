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

#include "pico/stdlib.h"
#include "pico/time.h"
#include "hardware/gpio.h"
#include "hardware/pwm.h"
#include "hardware/clocks.h"
#include "hardware/resets.h"

#include <functional>
#include <algorithm>
#include <tuple>
#include <memory>
#include <cstdio>



int main() {
    stdio_init_all();

    Position pos;

 	auto lcd_display = std::make_unique<LCDDisplay>();
	auto btn_x_minus = std::make_unique<Switch>(6, true);
	auto btn_x_plus = std::make_unique<Switch>(7, true);
	auto btn_y_minus = std::make_unique<Switch>(8, true);
	auto btn_y_plus = std::make_unique<Switch>(9, true);
	auto btn_reset = std::make_unique<Switch>(10, true);
	auto btn_ok = std::make_unique<Switch>(11, true);
    auto btn_menu = std::make_unique<Switch>(12, true);

	LCDMenu lcd_menu(std::move(lcd_display));

    auto manual_menu_entry_cb = [&pos](char *buf) {
        pos.print(buf);
    };

    auto auto_menu_entry_cb = [](char *buf) {
        std::sprintf(buf, "Reading sdcard");
    };

    lcd_menu.register_menu("<Manual>", manual_menu_entry_cb);
    lcd_menu.register_menu("<Auto>", auto_menu_entry_cb);


    StepMotorDriver step1(20u, 21u, 22u);

    while(true) {
        lcd_menu.refresh();
        if (btn_menu->is_released()) {
            lcd_menu.switch_entry();
        }
        if (btn_x_minus->is_pressed()) {
            pos.x.incr(-1);
            step1.rotate(1, 16000);
        }
        if (btn_x_plus->is_pressed()) {
            pos.x.incr(+1);
            step1.rotate(0, 16000);
        }
    }
    return 0;
}
