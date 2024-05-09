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

#pragma once

#include "cross-table/lcd_display.hpp"

#include <memory>
#include <functional>
#include <vector>
#include <utility>
#include <string>
#include <cstdint>
#include <cstddef>


class LCDMenu
{
public:
    using EntryDisplayCallback = std::function<void(char *)>;
    using MenuEntry = std::pair<std::string, EntryDisplayCallback>;

	/**
	 * LCDMenu constructor.
	 *
	 * The lcd_display shows the menu and the footer information. The
	 * rotary_encoder is used to navigate into the menu and button
	 * validates menu entry modification.
	 *
	 * @param lcd_display, Unique pointer to LCDDisplay instance
	 * @param rotary_encoder, Unique pointer to RotaryEncoder instance
	 * @param button, Unique pointer to Switch instance
	 * @param buzzer, Shared pointer to Buzzer instance
	 */
	LCDMenu();

	/**
	 * Add an entry in the menu to display/update a boolean variable.
	 *
	 * The entry is inserted at the beginning of the menu list. Entry
	 * ID are affected starting from zero and is incremented after
	 * each call to register_menu.
	 *
	 * @param title, menu title
	 * @param variable, variable reference to display/update
	 */
	void register_menu(const std::string &title, EntryDisplayCallback cb);

    /**
     * Switch to the next registered menu.
     *
     * @return the new active entry ID.
     */
    std::size_t switch_entry(void);

    /**
     * Return the current entry ID.
     *
     * @return the current entry ID.
     */
    std::size_t get_entry_id(void) const {return m_current_entry_id;}

	/**
	 * Refresh the menu and the footer notes.
	 */
	void refresh();

	/**
	 * Clear the screen and display a text in the middle of the screen.
	 *
	 * @param text, splash screen text.
	 */
	void splash(const std::string &text);

private:
	/**
	 * Refresh the menu
	 */
	void refresh_menu();

	/**
	 * Refresh the footer notes
	 */
	void refresh_footer();

private:
	LCDDisplay m_lcd_display;
	std::vector<MenuEntry> m_menu_entries;
	std::size_t m_current_entry_id;
	bool m_is_refreshed{false};
	bool m_is_splashed{false};
};
