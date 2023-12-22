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
#include "cross-table/lcd_display.hpp"
#include "cross-table/switch.hpp"

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


LCDMenu::LCDMenu(LCDDisplayPtr lcd_display):
	m_lcd_display      (std::move(lcd_display)),
	m_current_entry_id (0)
{
	m_lcd_display->clear();
	m_lcd_display->home();

	// Write custom chars for splash
	std::uint8_t char_1[8] = {0x07, 0x04, 0x04, 0x1C, 0x1C, 0x04, 0x04, 0x07}; // splash -[
	std::uint8_t char_2[8] = {0x1C, 0x04, 0x04, 0x07, 0x07, 0x04, 0x04, 0x1C}; // splash ]-
	std::uint8_t char_3[8] = {0x00, 0x00, 0x00, 0x1F, 0x1F, 0x00, 0x00, 0x00}; // Thick dot
	std::uint8_t char_4[8] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x1F, 0x1F, 0x00}; // Thick underscore
	std::uint8_t char_5[8] = {0x03, 0x06, 0x0C, 0x18, 0x18, 0x0C, 0x06, 0x03}; // Title <
	std::uint8_t char_6[8] = {0x18, 0x0C, 0x06, 0x03, 0x03, 0x06, 0x0C, 0x18}; // Title >
	m_lcd_display->set_char(1, char_1);
	m_lcd_display->set_char(2, char_2);
	m_lcd_display->set_char(3, char_3);
	m_lcd_display->set_char(4, char_4);
	m_lcd_display->set_char(5, char_5);
	m_lcd_display->set_char(6, char_6);
}


void LCDMenu::register_menu(const std::string &title, EntryDisplayCallback cb)
{
    m_menu_entries.emplace_back(title, cb);
}


std::size_t LCDMenu::switch_entry(void) {
    m_lcd_display->clear();
    m_lcd_display->home();
    m_current_entry_id += 1;
    m_current_entry_id %= m_menu_entries.size();
    return m_current_entry_id;
}


void LCDMenu::refresh()
{
	if (m_is_splashed) {
		m_lcd_display->clear();
		m_is_splashed = false;
	}

	m_is_refreshed = true;

	refresh_menu();
}


void LCDMenu::splash(const std::string &/*text*/)
{
	if (m_is_refreshed) {
		m_lcd_display->clear();
		m_is_refreshed = false;
	}

	m_is_splashed = true;

	m_lcd_display->set_pos(0, 0);
}


void LCDMenu::refresh_menu()
{
    char buf[256];

    if (m_menu_entries.empty()) {
		return;
	}

	const auto &entry = m_menu_entries[m_current_entry_id];

	m_lcd_display->set_pos(0, 0);
	m_lcd_display->print(format_info(entry.first, m_lcd_display->get_num_cols(), '-'));

	m_lcd_display->set_pos(1, 0);
    entry.second(buf);
	m_lcd_display->print(buf);
}
