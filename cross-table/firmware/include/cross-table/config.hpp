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

#include <cstdint>


struct TableConfig
{
    /**
     * @brief Number of step motor pulse per revolution.
     */
    static constexpr std::uint32_t pulses_per_rev = 1600;

    /**
     * @brief Distance in tenth of a millimeter per revolution.
     */
    static constexpr std::uint32_t tenth_dist_per_rev = 50;

    /**
     * @brief Number of pulse for one tenth of a millimeter.
     */
    static constexpr std::uint32_t pulses_per_tenth = pulses_per_rev / tenth_dist_per_rev;

    /**
     * @brief I2C bus pin SCL
     */
    static constexpr std::uint32_t pin_i2c_scl = 1;

    /**
     * @brief I2C bus pin SDA
     */
    static constexpr std::uint32_t pin_i2c_sda = 0;

    /**
     * @brief X- button pin
     */
    static constexpr std::uint32_t pin_btn_x_minus = 7;

    /**
     * @brief X+ button pin
     */
	static constexpr std::uint32_t pin_btn_x_plus = 9;

    /**
     * @brief Y- button pin
     */
	static constexpr std::uint32_t pin_btn_y_minus = 11;

    /**
     * @brief Y+ button pin
     */
	static constexpr std::uint32_t pin_btn_y_plus = 13;

    /**
     * @brief Reset button pin
     */
	static constexpr std::uint32_t pin_btn_reset = 6;

    /**
     * @brief Ok button pin
     */
	static constexpr std::uint32_t pin_btn_ok = 8;

    /**
     * @brief Menu button pin
     */
    static constexpr std::uint32_t pin_btn_menu = 12;

    /**
     * @brief X-axis Step motor controller pulse pin
     */
    static constexpr std::uint32_t pin_step_x_pulse = 16;

    /**
     * @brief X-axis Step motor controller dir pin
     */
    static constexpr std::uint32_t pin_step_x_dir = 17;

    /**
     * @brief X-axis Step motor controller enable pin
     */
    static constexpr std::uint32_t pin_step_x_ena = 18;

    /**
     * @brief Y-axis Step motor controller pulse pin
     */
    static constexpr std::uint32_t pin_step_y_pulse = 20;

    /**
     * @brief Y-axis Step motor controller dir pin
     */
    static constexpr std::uint32_t pin_step_y_dir = 21;

    /**
     * @brief Y-axis Step motor controller enable pin
     */
    static constexpr std::uint32_t pin_step_y_ena = 22;

    /**
     * @brief Limit 0 switch pin
     */
    static constexpr std::uint32_t pin_step_limit_0 = 14;

    /**
     * @brief Limit 1 switch pin
     */
    static constexpr std::uint32_t pin_step_limit_1 = 15;

};
