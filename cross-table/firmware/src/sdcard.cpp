#include "ff.h"
#include "sd_card.h"
#include "hw_config.h"

#include <cstring>
#include <cstdio>


void test_sd_card()
{
    sd_card_t *pSD = sd_get_by_num(0);
    f_mount(&pSD->fatfs, pSD->pcName, 1);
    FIL fil;
    f_open(&fil, "file1.txt", FA_READ);
    char buffer[64];
    memset(buffer, 0, sizeof(buffer));
    UINT br;
    f_read(&fil, buffer, sizeof(buffer)-1, &br);
    buffer[br] = 0;
    printf("%s", buffer);
}
