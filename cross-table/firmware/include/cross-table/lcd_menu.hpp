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
#include "cross-table/buttons.hpp"

#include <memory>
#include <functional>
#include <vector>
#include <utility>
#include <string>
#include <vector>
#include <variant>
#include <cstdint>
#include <cstddef>


class LCDMenu
{
public:
    using EntryDialogItem = std::variant<bool, int, float>;
    using EntryDialogItems = std::vector<std::pair<std::string, EntryDialogItem>>;
    using EntryDialogCallback = std::function<void(bool /*ok*/, bool /*reset*/, EntryDialogItems&)>;
    using EntryDisplayCallback = std::function<void(char *, Buttons &)>;

private:
    using EntryCallback = std::variant<EntryDisplayCallback, EntryDialogCallback>;

    struct Entry
    {
        std::string name;
        EntryCallback cb;
        EntryDialogItems dialog_items;
        std::uint32_t state {0};
    };

public:

	/**
	 * LCDMenu constructor.
	 */
	LCDMenu();

    /**
     * Register a display item
     *
     * @param[in] title, item title string.
     * @param[in] cb, callback.
     */
    void register_display(const std::string &title, EntryDisplayCallback cb)
    {
        Entry entry {.name=title, .cb=cb, .dialog_items={}};
        m_menu_entries.emplace_back(entry);
    }

    /**
     * Register a dialog item
     *
     * @param[in] title, item title string.
     * @param[in] cb, callback.
     */
    void register_dialog(const std::string &title, EntryDialogCallback cb, const EntryDialogItems &dialog_items)
    {
        Entry entry {.name=title, .cb=cb, .dialog_items=dialog_items};
        m_menu_entries.emplace_back(entry);
    }

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
     * Print a dialog variant value
     */
    void dialog_print_variant(const EntryDialogItem &item);

    /**
     * Print a dialog variant value
     */
    void dialog_update_variant(int incr, int decr, EntryDialogItem &item);


private:
	LCDDisplay m_lcd_display;
    Buttons m_buttons;
	std::vector<Entry> m_menu_entries;
    std::size_t m_current_entry_id;
	bool m_is_refreshed{false};
	bool m_is_splashed{false};
};
