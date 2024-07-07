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

#include <cross-table/config.hpp>

#include <cstdlib>
#include <cstdio>


struct Axis
{
    int abs_pos {0};
    int abs_ref {0};

    static void decimal(const int value, int &integer, int &frac)
    {
        integer = value / 10;
        frac = value % 10;
    }

    void incr_pulse(int val)
    {
        abs_pos += val;
    }

    void incr_tenth(int val)
    {
        abs_pos += val * TableConfig::pulse_per_tenth;
    }

    void reset(void) {
        abs_pos = 0;
        abs_ref = 0;
    }

    void set_ref()
    {
        abs_ref = abs_pos;
    }

    int rel_pulse_pos() const
    {
        return abs_pos - abs_ref;
    }

    int print(char *buffer)
    {
        auto rel = rel_pulse_pos();
        char abs_sign = abs_pos < 0 ? '-' : ' ';
        char rel_sign = rel < 0 ? '-' : ' ';
        int abs_integer, abs_frac;
        int rel_integer, rel_frac;
        decimal(std::abs(abs_pos)/TableConfig::pulse_per_tenth,
                abs_integer, abs_frac);
        decimal(std::abs(rel)/TableConfig::pulse_per_tenth,
                rel_integer, rel_frac);
        return sprintf(buffer, "%c%03d.%1d     %c%03d.%1d",
                       rel_sign, rel_integer, rel_frac,
                       abs_sign, abs_integer, abs_frac);
    }
};


struct Position
{
    Axis x;
    Axis y;

    void reset(void) {
        x.reset();
        y.reset();
    }

    void set_ref(void)
    {
        x.set_ref();
        y.set_ref();
    }

    void print(char *buffer) {
        buffer += sprintf(buffer, "    -Rel-      -Abs-\n");
        buffer += sprintf(buffer, "X: ");
        buffer += x.print(buffer);
        buffer += sprintf(buffer, "\nY: ");
        buffer += y.print(buffer);
    }

};
