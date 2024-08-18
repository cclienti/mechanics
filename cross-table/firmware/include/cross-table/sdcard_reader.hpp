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

#pragma once

#include "cross-table/position.hpp"

#include <memory>
#include <vector>
#include <string>


struct ImplFATFS;


class SDCardReader
{
    static constexpr int s_buffer_len = 1024;
    enum class ReadState {Header = 0, Updates, Error};

public:
    enum class ReadPosRc {Ok = 0, BadHeader, BadPosition, UnknownError};

    SDCardReader();
    ~SDCardReader();

    /**
     * @brief Get the list of filenames found in the sdcard
     */
    void list_files(std::vector<std::string> &files);

    /**
     * @brief Get the list of position updates read in the sdcard.
     * @param[out] list, vector of position updates
     * @return an error code
     */
    ReadPosRc read_positions(const std::string &filename, std::vector<PulseUpdate> &updates);

    /**
     * @brief Get a text message corresponding to the given return code
     */
    static const char *read_rc_info(ReadPosRc read_rc) {
        switch (read_rc) {
        case ReadPosRc::Ok: return "Ok";
        case ReadPosRc::BadHeader: return "Bad header";
        case ReadPosRc::BadPosition: return "Bad Position";
        case ReadPosRc::UnknownError: return "Unknown error";
        }
        return "Unknown error";
    }

private:
    std::unique_ptr<ImplFATFS> m_pfs;
    std::unique_ptr<char[]> m_buffer;
};
