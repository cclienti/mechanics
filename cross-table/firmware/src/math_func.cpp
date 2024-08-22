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
