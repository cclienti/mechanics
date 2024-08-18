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

#include "cross-table/sdcard_reader.hpp"
#include "cross-table/config.hpp"

#include "ff.h"
#include "sd_card.h"

#include <memory>
#include <cstring>
#include <cstdio>


namespace
{
/**
 * @brief Read a line in the given text file descriptor.
 * @param[in] fs, sdcard filesystem
 * @param[out] buffer, buffer to store the line
 * @param[in] buffer_len, Line buffer length.
 * @returns The number of bytes read, if the return value is larger than buffer_len last car of the line have been ignored.
 */
int sdcard_read_line(FIL &file, char *buffer, int buffer_len)
{
    memset(buffer, buffer_len, sizeof(buffer[0]));

    UINT byte_read = 0;
    int num_bytes_read = 0;
    while (true) {
        f_read(&file, buffer, 1, &byte_read);
        if (byte_read == 0) {
            break;
        }
        num_bytes_read++;
        if (*buffer == '\n') {
            break;
        }
        if (num_bytes_read < buffer_len) {
            buffer++;
        }
    }
    *buffer = '\0';
    return num_bytes_read;
}
}

struct ImplFATFS
{
    FATFS impl;
};

SDCardReader::SDCardReader():
    m_pfs  (std::make_unique<ImplFATFS>()),
    m_buffer (std::make_unique<char[]>(s_buffer_len))
{
    auto res = f_mount(&m_pfs->impl, "", 1);
    if (res == FR_NOT_READY) {
        // no sdcard inserted
    }
    else if (res == FR_DISK_ERR) {
        // sdcard ejected an reinserted but it's not working.
    }
    printf("res = %d\n", res);
}

// The destructor cannot be marked as default in the header as the
// unique_ptr<ImplFATFS> is declared with a forward declaration and is
// not fully known (in case destructor would be inlined).
SDCardReader::~SDCardReader()
{
    f_unmount("");
}


void SDCardReader::list_files(std::vector<std::string> &files)
{
    files.clear();
    DIR dir;
    FILINFO finfo;
    auto res = f_findfirst(&dir, &finfo, "", "*.*");
    while (res == FR_OK && finfo.fname[0] != '\0') {
        printf("%s\n", finfo.fname);
        files.emplace_back(finfo.fname);
        res = f_findnext(&dir, &finfo);
    }
    f_closedir(&dir);
}


// Hereafter the file format supported.
//
//   # First non comment line must specify the machine info: <pulses per tenth of a millimeter>
//   32
//   # Coordinates of each move in number of pulses (signed int): <x> <y>
//   -500 1000
//   # ...

SDCardReader::ReadPosRc SDCardReader::read_positions(
    const std::string &filename, std::vector<PulseUpdate> &updates
)
{
    char *pbuf = m_buffer.get();

    FIL file;
    f_open(&file, filename.c_str(), FA_READ);

    ReadPosRc read_rc {ReadPosRc::Ok};
    ReadState state {ReadState::Header};
    int num_bytes_read;
    do {
        // Read a line
        num_bytes_read = sdcard_read_line(file, pbuf, s_buffer_len);

        // End of file reached
        if (num_bytes_read == 0) {
            break;
        }

        // Handle comments
        if (pbuf[0] == '#') {
            continue;
        }

        // Read information
        switch (state) {
        case ReadState::Header:
            {
                int pulses_per_tenth {0};
                int scan_rc = sscanf(pbuf, "%d", &pulses_per_tenth);
                if (scan_rc != 1) {
                    state = ReadState::Error;
                    read_rc = ReadPosRc::BadHeader;
                }
                else if (pulses_per_tenth != TableConfig::pulses_per_tenth) {
                    state = ReadState::Error;
                    read_rc = ReadPosRc::BadHeader;
                }
                else {
                    state = ReadState::Updates;
                    read_rc = ReadPosRc::Ok;
                }
            }
            break;
        case ReadState::Updates:
            {
                int x_pulse {0};
                int y_pulse {0};
                int scan_rc = sscanf(pbuf, "%d %d", &x_pulse, &y_pulse);
                if (scan_rc != 2) {
                    state = ReadState::Error;
                    read_rc = ReadPosRc::BadPosition;
                }
                else {
                    updates.emplace_back(x_pulse, y_pulse);
                    state = ReadState::Updates;
                    read_rc = ReadPosRc::Ok;
                }
            }
            break;
        default:
            {
                state = ReadState::Error;
                read_rc = ReadPosRc::UnknownError;
            }
        }
    } while (num_bytes_read != 0 && state != ReadState::Error);

    return read_rc;
}
