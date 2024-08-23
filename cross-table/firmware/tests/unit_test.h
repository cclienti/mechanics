#pragma once

#include <pico/stdio.h>
#include <pico/time.h>

#include <cstdio>

#define TEST_INFO(info)                             \
    do {                                            \
        stdio_init_all();                           \
        sleep_ms(2000);                             \
        printf("\033[2J\n");                        \
        printf("=========================\n");      \
        printf("= %s\n", info);                     \
        printf("=========================\n\n");    \
    } while(false)                                  \

#define STRINGIFY(n) #n

#define TEST_FUNC(n) test_##n

#define DECL_TEST(n) bool TEST_FUNC(n)()

#define START_TEST(n)                                       \
    do {                                                    \
        printf("---------------------\n");                  \
        printf("- Test %s\n", STRINGIFY(n));                \
        printf("---------------------\n");                  \
        if (TEST_FUNC(n)()) {                               \
            printf("-> Test %s: OK\n", STRINGIFY(n));       \
        } else {                                            \
            printf("-> Test %s: KO!!!\n", STRINGIFY(n));    \
        }                                                   \
        printf("\n");                                       \
    } while(false)
