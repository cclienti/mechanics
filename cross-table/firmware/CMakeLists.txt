# Picoline
# Copyright (C) 2023 Christophe Clienti

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


cmake_minimum_required(VERSION 3.17)

include(pico_sdk_import.cmake)

project(cross-table LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)

add_compile_options(-Wall -Wextra -Werror)

pico_sdk_init()

add_compile_options(
  -Wall
  -Wno-format          # int != int32_t as far as the compiler is concerned because gcc has int32_t as long int
  -Wno-unused-function # we have some for the docs that aren't called
  -Wno-maybe-uninitialized
)

add_executable(cross-table
  src/lcd_display.cpp
  src/lcd_menu.cpp
  src/main.cpp
)

# Generates header for pio
# pico_generate_pio_header(cross-table ${CMAKE_CURRENT_LIST_DIR}/pio/rotary_encoder.pio)

target_include_directories(cross-table PUBLIC include)
target_link_libraries(cross-table pico_stdlib hardware_pwm hardware_i2c hardware_spi hardware_pio)

# create map/bin/hex/uf2 file in addition to ELF.
pico_add_extra_outputs(cross-table)

# add uart
pico_enable_stdio_usb(cross-table 0)
pico_enable_stdio_uart(cross-table 0)
