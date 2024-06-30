#include "hardware/gpio.h"
#include "sd_card.h"
#include "hw_config.h"

static spi_t spi = {
    .hw_inst                  = spi0,
    .miso_gpio                = 4,
    .mosi_gpio                = 3,
    .sck_gpio                 = 2,
    .baud_rate                = 125 * 1000,
    .set_drive_strength       = false,
    .mosi_gpio_drive_strength = GPIO_DRIVE_STRENGTH_4MA,
    .sck_gpio_drive_strength  = GPIO_DRIVE_STRENGTH_4MA
};

static sd_card_t sd_card = {
    .pcName          = "0:",  // Name used to mount device
    .spi             = &spi,  // Pointer to the SPI driving this card
    .ss_gpio         = 5,     // The SPI slave select GPIO for this SD card
    .use_card_detect = false
};

size_t spi_get_num()
{
    return 1;
}

spi_t *spi_get_by_num(size_t num)
{
    if (num < sd_get_num()) {
        return &spi;
    } else {
        return NULL;
    }
}

size_t sd_get_num()
{
    return 1;
}

sd_card_t *sd_get_by_num(size_t num)
{
    if (num < sd_get_num()) {
        return &sd_card;
    } else {
        return NULL;
    }
}
