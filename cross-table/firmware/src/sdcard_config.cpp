// This file is part of the cross-table project
// (https://github.com/cclienti/mechanics)
// Copyright (c) 2023 Christophe Clienti
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

#include "hw_config.h"

/* Configuration of RP2040 hardware SPI object */
static spi_t spi = {
    .hw_inst                  = spi0,  // RP2040 SPI component
    .miso_gpio                = 4     ,// GPIO number (not Pico pin number)
    .mosi_gpio                = 3,
    .sck_gpio                 = 2,
    .baud_rate                = 12 * 1000 * 1000,   // Actual frequency: 10416666.
    .set_drive_strength       = false,
    .mosi_gpio_drive_strength = GPIO_DRIVE_STRENGTH_4MA,
    .sck_gpio_drive_strength  = GPIO_DRIVE_STRENGTH_4MA
};

/* SPI Interface */
static sd_spi_if_t spi_if = {
    .spi     = &spi,   // Pointer to the SPI driving this card
    .ss_gpio = 5       // The SPI slave select GPIO for this SD card
};

/* Configuration of the SD Card socket object */
static sd_card_t sd_card = {
    .type            = SD_IF_SPI,
    .spi_if_p        = &spi_if,  // Pointer to the SPI interface driving this card
    .use_card_detect = false,

};

size_t sd_get_num() { return 1; }

sd_card_t *sd_get_by_num(size_t num) {
    if (0 == num) {
        return &sd_card;
    } else {
        return NULL;
    }
}
