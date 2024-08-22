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

#include "hardware/gpio.h"
#include "pico/time.h"
#include <cstdint>

/**
 * @brief Switch management.
 *
 * This class handle a switch connected to one Pi Pico GPIO.
 */
class Switch final
{
public:
    static constexpr std::uint32_t VeryLongPress = 5000;
    static constexpr std::uint32_t LongPress = 1000;

    enum class PressInfo : int
    {
        No = 0,
        Short = 1,
        Long = 10,
        VeryLong = 100,
    };

    /**
     * @brief Construct the Switch instance.
     * @param[in] gpio index
     * @param[in] inverted, reverse the logic
     * @param[in] pullup, configure GPIO internal pullup
     * @param[in] pulldown, configure GPIO internal pulldown
     *
     * If both pullup and pulldown parameters are set, it will not
     * configure pullup nor pulldown.
     */
	Switch(std::uint32_t gpio, bool inverted=true, bool pullup=true, bool pulldown=false) :
		m_gpio (gpio),
		m_inverted (inverted)
	{
		gpio_init(m_gpio);
		gpio_set_dir(m_gpio, GPIO_IN);
        if (pullup && !pulldown) {
            gpio_pull_up(m_gpio);
        }
        else if (!pullup && pulldown) {
            gpio_pull_down(m_gpio);
        }
	}

    /**
     * @brief Return a value different of zero if the button is pressed.
     *
     * The return value will be:
     *
     * - Switch::VeryLongPressReturn when press time is greater than Switch::VeryLongPress
     * - Switch::LongPressReturn when press time is greater than Switch::LongPress
     * - Switch::ShortPressReturn in all other cases.
     */
	PressInfo is_pressed()
	{
        bool pressed = get() ^ m_inverted;
        if (pressed) {
            auto delay = get_timestamp_ms() - m_last_pressed_time;
            auto value = PressInfo::Short;
            if (delay > VeryLongPress) {
                value = PressInfo::VeryLong;
            }
            else if(delay > LongPress) {
                value = PressInfo::Long;
            }
            return value;
        }
        m_last_pressed_time = get_timestamp_ms();
		return PressInfo::No;
	}

    /**
     * @brief Return true if the buttons has been released
     */
	bool is_released()
	{
		bool last = m_pressed;
		m_pressed = is_pressed() != PressInfo::No;
		return last && (!m_pressed);
	}

    /**
     * @brief Return true if the buttons has been released
     * @param[out] press_info, set an indication about the press time.
     */
	bool is_released(PressInfo &press_info)
	{
        bool status = false;
		bool last{m_pressed};
        press_info = PressInfo::No;
        m_pressed = is_pressed() != PressInfo::No;

        if (!last && m_pressed) {
            m_pressed_time_before_release = get_timestamp_ms();
        }
        else if (last && !m_pressed) {
            auto delay = get_timestamp_ms() - m_pressed_time_before_release;
            if (delay >= VeryLongPress) {
                press_info = PressInfo::VeryLong;
            }
            else if (delay >= LongPress) {
                press_info = PressInfo::Long;
            }
            else {
                press_info = PressInfo::Short;
            }
            status = true;
        }

        return status;
	}

private:
    static inline std::uint32_t get_timestamp_ms()
    {
        return to_ms_since_boot(get_absolute_time());
    }

	[[nodiscard]] inline bool get() const
	{
		return gpio_get(m_gpio);
	}

	const std::uint32_t m_gpio;
	const bool  m_inverted;

    std::uint32_t m_pressed_time_before_release{0};
    std::uint32_t m_last_pressed_time{0};
	bool m_pressed{false};
};
