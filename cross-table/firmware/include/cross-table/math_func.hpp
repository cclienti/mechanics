// This file is part of the cross-table project
// (https://github.com/cclienti/mechanics)
// Copyright (c) 2024 Christophe Clienti
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

#include "cross-table/position.hpp"
#include "cross-table/config.hpp"

#include <cstdint>


/**
 * @brief convert millimeters in stepper motor pulses
 */
static inline int millimeters_to_pulses(float millimeters)
{
    constexpr int num_tenth_in_a_millimeter = 10;
    return static_cast<int>
        (millimeters * TableConfig::pulses_per_tenth * num_tenth_in_a_millimeter);
}


/**
 * @brief Configure a list of coordinates to drill holes on a circle.
 * @param[in] num_holes, number of holes
 * @param[in] radius, radius in millimeters of the circle
 * @param[in] angle_offset, angle offset in degrees of holes n the circle
 * @param[out] List of pulse updates
 *
 * The first hole coordinate is (X:0, Y:radius). The next hole defined
 * using a rotation in a counter clockwise direction of
 * (2*pi/num_holes).
 *
 */
void holes_on_a_circle(std::uint32_t num_holes, float radius,
                       float angle_offset, std::vector<PulseUpdate> &pulse_updates);


/**
 * @brief Configure a list of coordinates to drill holes on a grid
 * @param[in] num_x_holes, number of holes in the X direction
 * @param[in] num_y_holes, number of holes in the Y direction
 * @param[in] dist_x, distance in millimeters between hole in X direction
 * @param[in] dist_y, distance in millimeters between hole in Y direction
 * @param[out] List of pulse updates
 *
 */
void holes_on_grid(std::uint32_t num_x_holes, std::uint32_t num_y_holes,
                   float dist_x, float dist_y, std::vector<PulseUpdate> &pulse_updates);
