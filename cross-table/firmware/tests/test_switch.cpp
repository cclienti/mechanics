#include "cross-table/switch.hpp"
#include "cross-table/config.hpp"

#include "pico/stdio.h"
#include "pico/time.h"

#include <cstdio>
#include <cstdint>
#include <cstdlib>


bool test_1()
{
    Switch sw_ok(TableConfig::pin_btn_ok, true);
    auto press_info = Switch::PressInfo::No;


    printf("Short Press Test: ");
    press_info = Switch::PressInfo::No;
    do {
        press_info = sw_ok.is_pressed();
    } while(press_info != Switch::PressInfo::Short);
    if (press_info == Switch::PressInfo::Short) {
        printf("OK\n");
    }
    else {
        printf("KO\n");
        return false;
    }
    while(!sw_ok.is_released()) {}


    printf("Long Press Test: ");
    press_info = Switch::PressInfo::No;
    do {
        press_info = sw_ok.is_pressed();
    } while(press_info != Switch::PressInfo::Long);
    printf("OK\n");
    while(!sw_ok.is_released()) {}


    printf("Very Long Press Test: ");
    press_info = Switch::PressInfo::No;
    do {
        press_info = sw_ok.is_pressed();
    } while(press_info != Switch::PressInfo::VeryLong);
    printf("OK\n");
    while(!sw_ok.is_released()) {}

    return true;
}


bool test_2()
{
    Switch sw_ok(TableConfig::pin_btn_ok, true);
    auto press_info = Switch::PressInfo::No;

    printf("Short release test: ");
    while(!sw_ok.is_released()) {}
    printf("OK\n");

    printf("Short release test with press info returned: ");
    while(!sw_ok.is_released(press_info)) {}
    if (press_info == Switch::PressInfo::Short) {
        printf("OK\n");
    }
    else {
        printf("KO, got %d\n", static_cast<int>(press_info));
        return false;
    }

    printf("Long release test with press info returned: ");
    while(!sw_ok.is_released(press_info)) {}
    if (press_info == Switch::PressInfo::Long) {
        printf("OK\n");
    }
    else {
        printf("KO, got %d\n", static_cast<int>(press_info));
        return false;
    }


    printf("Very long release test with press info returned: ");
    while(!sw_ok.is_released(press_info)) {}
    if (press_info == Switch::PressInfo::VeryLong) {
        printf("OK\n");
    }
    else {
        printf("KO, got %d\n", static_cast<int>(press_info));
        return false;
    }

    return true;
}


int main()
{
    stdio_init_all();
    sleep_ms(2000);
    printf("\033[2J\n");
    printf("=========================\n");
    printf("= Test Switch           =\n");
    printf("=========================\n");

    printf("=====================\n");
    printf("= Test 1            = \n");
    printf("=====================\n");
    if (test_1()) {
        printf("=================> TEST 1: OK\n");
    } else {
        printf("=================> TEST 1: KO!!!\n");
    }

    printf("=====================\n");
    printf("= Test 2            = \n");
    printf("=====================\n");
    if (test_2()) {
        printf("=================> TEST 2: OK\n");
    } else {
        printf("=================> TEST 2: KO!!!\n");
    }

    while(true);
    return 0;
}
