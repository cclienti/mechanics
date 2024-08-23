#include "cross-table/switch.hpp"
#include "cross-table/config.hpp"

#include "unit_test.h"



DECL_TEST(1)
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


DECL_TEST(2)
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
    TEST_INFO("Test Switch");

    START_TEST(1);
    START_TEST(2);

    while(true) {}
    return 0;
}
