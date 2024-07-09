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

#include <string>
#include <cstdint>


namespace
{
std::string format_info(const std::string &info, std::uint8_t width, char pad)
{
    int info_len = info.size();

    std::string info_ = info;
    if (info_len > width) {
        info_.resize(width);
    }

    int padding = (width - info_.size()) / 2;

    std::string menu_info(width, pad);
    menu_info.replace(padding, info_.size(), info_);

    return menu_info;
}
}


LCDMenu::LCDMenu():
	m_current_entry_id (0)
{
	m_lcd_display.clear();
	m_lcd_display.home();

	// Write custom chars for splash
    // Example for MenuUp
    //   1
    //   0 8 4 2 1
    //   . . . . .  0x00
    //   . . . . .  0x00
    //   . . * . .  0x04
    //   . * * * .  0x0E
    //   * * * * *  0x1F
    //   . . . . .  0x00
    //   . . . . .  0x00
    //   . . . . .  0x00

	std::uint8_t char_1[8] = {0x00, 0x00, 0x04, 0x0E, 0x1F, 0x00, 0x00, 0x00}; // MenuUp
	std::uint8_t char_2[8] = {0x00, 0x00, 0x1F, 0x0E, 0x04, 0x00, 0x00, 0x00}; // MenuDown
	m_lcd_display.set_char(1, char_1);
	m_lcd_display.set_char(2, char_2);
}


std::size_t LCDMenu::switch_entry(void) {
    m_lcd_display.clear();
    m_lcd_display.home();
    m_current_entry_id += 1;
    m_current_entry_id %= m_menu_entries.size();
    return m_current_entry_id;
}


void LCDMenu::refresh()
{
	if (m_is_splashed) {
		m_lcd_display.clear();
		m_is_splashed = false;
	}

	m_is_refreshed = true;

	refresh_menu();
}


void LCDMenu::splash(const std::string &text)
{
	if (m_is_refreshed) {
		m_lcd_display.clear();
		m_is_refreshed = false;
	}

	m_is_splashed = true;

	m_lcd_display.set_pos(1, 0);

    std::string splash = "[" + text + "]";
	m_lcd_display.print(format_info(splash, m_lcd_display.get_num_cols(), '-'));
}


void LCDMenu::print_variant(const EntryDialogItem &item)
{
    if (std::holds_alternative<bool>(item)) {
        if (std::get<bool>(item)) {
            m_lcd_display.printf("    ON");
        } else {
            m_lcd_display.printf("   OFF");
        }
    }
    else if (std::holds_alternative<int>(item)) {
        m_lcd_display.printf("%6d", std::get<int>(item));
    }
    else if (std::holds_alternative<float>(item)) {
        m_lcd_display.printf("%6.01f", std::get<float>(item));
    }
}

void LCDMenu::update_variant(int incr, int decr, EntryDialogItem &item)
{
    if (std::holds_alternative<bool>(item)) {
        if (incr > 0) {
            item = true;
        }
        if (decr > 0) {
            item = false;
        }
    }
    else if (std::holds_alternative<int>(item)) {
        int v = std::get<int>(item);
        item = v + incr - decr;
    }
    else if (std::holds_alternative<float>(item)) {
        float v = std::get<float>(item);
        v = (v * 10.0f + incr - decr) * 0.1f;
        item = v;
    }
}

void LCDMenu::refresh_menu()
{
    char buf[256];

    if (m_menu_entries.empty()) {
		return;
	}

    if (m_buttons.menu.is_released()) {
        switch_entry();
    }

    auto &entry = m_menu_entries[m_current_entry_id];

    /// Print the menu title and prepare the cursor position.
    m_lcd_display.set_pos(0, 0);
    m_lcd_display.print(format_info(entry.name, m_lcd_display.get_num_cols(), '-'));

    // Dispatch to the right menu handler.
    EntryCallback cb_variant = entry.cb;
    if (std::holds_alternative<EntryDisplayCallback>(cb_variant)) {
        auto cb = std::get<EntryDisplayCallback>(cb_variant);
        cb(buf, m_buttons);
        m_lcd_display.set_pos(1, 0);
        m_lcd_display.print(buf);
    }
    else if (std::holds_alternative<EntryDialogCallback>(cb_variant)) {
        if (entry.dialog_items.empty()) {
            return;
        }
        // Select the right item depending on the state
        auto &item = entry.dialog_items[entry.state];

        // Display current item
        m_lcd_display.set_pos(1, 9);
        m_lcd_display.print("\1");
        m_lcd_display.set_pos(2, 0);
        m_lcd_display.print(item.first.c_str()); // TODO Truncate string if needed.
        m_lcd_display.set_pos(2, 14);
        print_variant(item.second);
        m_lcd_display.set_pos(3, 9);
        m_lcd_display.print("\2");

        // Switch between dialog item
        if (m_buttons.y_plus.is_released()) {
            if (entry.state == 0) {
                entry.state = entry.dialog_items.size()-1;
            }
            else {
                entry.state--;
            }
        }
        if (m_buttons.y_minus.is_released()) {
            if (entry.state == entry.dialog_items.size()-1) {
                entry.state = 0;
            }
            else {
                entry.state++;
            }
        }

        // Update current value
        update_variant(m_buttons.x_plus.is_pressed(), m_buttons.x_minus.is_pressed(), item.second);

        // Handle callback
        auto ok_released = m_buttons.ok.is_released();
        auto reset_released = m_buttons.ok.is_released();
        if (ok_released || reset_released) {
            auto cb = std::get<EntryDialogCallback>(cb_variant);
            cb(ok_released, reset_released, entry.dialog_items);
        }
    }
}
