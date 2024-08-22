#include "cross-table/position.hpp"

#include "pico/stdio.h"
#include "pico/time.h"

#include <cstdio>
#include <cstdint>
#include <cstdlib>


void print_pos(Position &pos)
{
    char buffer[128];
    pos.print(buffer);
    printf("%s\n", buffer);
}


PulseUpdate move_motors(Position &pos, bool simulate_error)
{
    int x = pos.x.rel_pulse_pos();
    int y = pos.y.rel_pulse_pos();

    printf("Moving motors to y: %6.2f, y: %6.2f\n",
           pos.x.rel_float_pos(), pos.y.rel_float_pos());

    if (simulate_error) {
        printf("Motor error, rolling back\n");
        PulseUpdate rollback_update(x, y);
        pos.rollback(rollback_update);
        return {0, 0};
    }

    pos.set_ref();

    return {x, y};
}


bool test_1(void)
{
    Position pos;
    PositionsHandler pos_handler;

    printf("- Loading positions -\n");
    pos_handler.set({{100*320, 200*320}, {300*320, 500*320}, {120*320, -30*320}});
    if (pos_handler.changed()) {
        pos_handler.next();
        pos_handler.update_rel_pos(pos);
    }

    printf("---------------\n");
    printf("- Simulate Ok -\n");
    printf("---------------\n");
    // One more iteration whereas the vector has only two positions
    for (int i=0; i<4; i++) {
        // user can change previously loaded position here
        if (i==0) {
            pos.x.incr_pulse(50*320);
            pos.y.incr_pulse(70*320);
        }

        // move motors, emulate a motor error when i==1
        auto up = move_motors(pos, i==1);

        // commit the true moves in the position_handler
        pos_handler.commit(up);

        // get the next position if any.
        if (pos_handler.next()) {
            pos_handler.update_rel_pos(pos);
        }
        print_pos(pos);
        printf("\n");
    }

    printf("-----------------\n");
    printf("- Simulate Prev -\n");
    printf("-----------------\n");
    // One more iteration whereas the vector has only two positions.
    for (int i=0; i<5; i++) {
        if (pos_handler.is_counter_pos(pos)) {
            move_motors(pos, false);
        }
        else {
            pos.rollback();
        }

        if (pos_handler.prev()) {
            pos_handler.revert_rel_pos(pos);
        }

        print_pos(pos);
        printf("\n");
    }

    if (pos.x.rel_pulse_pos() == 0 && pos.y.rel_pulse_pos() == 0 &&
        pos.x.abs_pulse_pos() == 0 && pos.y.abs_pulse_pos() == 0) {
        return true;
    }

    return false;
}

int main(void)
{
    stdio_init_all();
    sleep_ms(2000);
    printf("\033[2J\n");
    printf("=========================\n");
    printf("= Test Position Handler =\n");
    printf("=========================\n");

    printf("=====================\n");
    printf("= Test 1            = \n");
    printf("=====================\n");
    if (test_1()) {
        printf("=================> TEST 1: OK\n");
    } else {
        printf("=================> TEST 1: KO!!!\n");
    }

    while(true);
    return 0;
}
