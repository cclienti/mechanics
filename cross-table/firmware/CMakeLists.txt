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

set(CMAKE_CXX_STANDARD 20)

pico_sdk_init()

add_subdirectory(no-OS-FatFS-SD-SDIO-SPI-RPi-Pico/src)

add_compile_options(
  -Wall
  -Wextra
  -Werror
  -Wno-unused-parameter
)

add_executable(cross-table
  src/lcd_display.cpp
  src/lcd_menu.cpp
  src/main.cpp
  src/sdcard_config.cpp
  src/sdcard.cpp
)

set_source_files_properties(
  src/sdcard_config.cpp
  PROPERTIES
  COMPILE_FLAGS -Wno-missing-field-initializers
)

target_include_directories(cross-table PUBLIC include)
target_link_libraries(
  cross-table PRIVATE
  pico_stdlib hardware_pwm hardware_i2c hardware_spi hardware_pio
  no-OS-FatFS-SD-SDIO-SPI-RPi-Pico
)

# create map/bin/hex/uf2 file in addition to ELF.
pico_add_extra_outputs(cross-table)

# add uart
pico_enable_stdio_usb(cross-table 1)
pico_enable_stdio_uart(cross-table 0)
