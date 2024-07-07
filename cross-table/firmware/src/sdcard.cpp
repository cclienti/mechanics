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

#include "ff.h"
#include "sd_card.h"
#include "hw_config.h"

#include <cstring>
#include <cstdio>


void test_sd_card()
{
    FATFS fs;
    f_mount(&fs, "", 1);

    FIL fil;
    f_open(&fil, "file1.txt", FA_READ);

    char buffer[64];
    memset(buffer, 0, sizeof(buffer));

    UINT br;
    f_read(&fil, buffer, sizeof(buffer)-1, &br);
    buffer[br] = 0;

    printf("%s", buffer);
}
