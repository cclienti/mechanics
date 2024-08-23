#include "cross-table/math_func.hpp"

#include "unit_test.h"


void print_vector(std::vector<PulseUpdate> &updates)
{
    for (auto &update : updates) {
        printf("X: %+07.02f (%7d), Y: %+07.02f (%7d)\n",
               static_cast<float>(update.x)/TableConfig::pulses_per_tenth/10, update.x,
               static_cast<float>(update.y)/TableConfig::pulses_per_tenth/10, update.y);
    }
}

DECL_TEST(1)
{
    std::vector<PulseUpdate> updates;

    holes_on_a_circle(4, 40.0f, 0.0f, updates);
    if (updates.size() != 4) {
        printf("bad vector size\n");
        return false;
    }
    bool success{true};
    success &= updates[0].x == millimeters_to_pulses(40.0f);
    success &= updates[0].y == 0;
    success &= updates[1].x == 0;
    success &= updates[1].y == millimeters_to_pulses(40.0f);
    success &= updates[2].x == -millimeters_to_pulses(40.0f);
    success &= updates[2].y == 0;
    success &= updates[3].x == 0;
    success &= updates[3].y == -millimeters_to_pulses(40.0f);

    if (!success) {
        printf("Error founds, vector returned:\n");
        print_vector(updates);
    }

    return success;
}


DECL_TEST(2) {
    std::vector<PulseUpdate> updates;

    holes_on_a_circle(4, 40.0f, 90.0f, updates);
    if (updates.size() != 4) {
        printf("bad vector size\n");
        return false;
    }
    bool success{true};
    success &= updates[3].x == millimeters_to_pulses(40.0f);
    success &= updates[3].y == 0;
    success &= updates[0].x == 0;
    success &= updates[0].y == millimeters_to_pulses(40.0f);
    success &= updates[1].x == -millimeters_to_pulses(40.0f);
    success &= updates[1].y == 0;
    success &= updates[2].x == 0;
    success &= updates[2].y == -millimeters_to_pulses(40.0f);

    if (!success) {
        printf("Error founds, vector returned:\n");
        print_vector(updates);
    }

    return success;
}



int main()
{
    TEST_INFO("Test Switch");

    START_TEST(1);
    START_TEST(2);

    while(true) {}
    return 0;
}
