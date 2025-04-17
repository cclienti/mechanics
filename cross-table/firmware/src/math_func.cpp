#include "cross-table/math_func.hpp"

#include <cmath>
#include <cstdio>


void holes_on_a_circle(std::uint32_t num_holes, float radius,
                       float angle_offset, std::vector<PulseUpdate> &pulse_updates)
{
    auto angle_off = angle_offset * M_PI / 180.0F;
    for (std::uint32_t i = 0; i<num_holes; i++) {
        float angle = angle_off + (i * 2 * M_PI) / num_holes;
        int x_up = millimeters_to_pulses(cosf(angle) * radius);
        int y_up = millimeters_to_pulses(sinf(angle) * radius);
        pulse_updates.emplace_back(x_up, y_up);
    }
}

void holes_on_grid(std::uint32_t num_x_holes, std::uint32_t num_y_holes,
                   float dist_x, float dist_y, std::vector<PulseUpdate> &pulse_updates)
{
    // Enjoy the boustrophedon algorithm
    for (std::uint32_t row_idx = 0; row_idx < num_y_holes; row_idx++) {
        if (row_idx > 0) {
            pulse_updates.emplace_back(0, millimeters_to_pulses(dist_y));
        }
        for (std::uint32_t col_idx = 1; col_idx < num_x_holes; col_idx++) {
            auto x_rel = (row_idx & 1) ? -dist_x : dist_x;
            pulse_updates.emplace_back(millimeters_to_pulses(x_rel), 0);
        }
    }
}
