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

    static void decimal(const float value, const int precision, char &sign, int &integer, int &frac)
    {
        sign = value < 0 ? '-' : '+';
        auto abs_value = std::abs(value);
        integer = static_cast<int>(abs_value);
        frac = static_cast<int>(abs_value * precision) % precision;
    }

    void incr_pulse(int val)
    {
        abs_pos += val;
    }

    void incr_half_tenth(int val)
    {
        abs_pos += val * (TableConfig::pulses_per_half_tenth);
    }

    void incr_tenth(int val)
    {
        abs_pos += val * TableConfig::pulses_per_tenth;
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

    float rel_float_pos() const
    {
        return static_cast<float>(rel_pulse_pos()) / (TableConfig::pulses_per_tenth * 10);
    }

    float abs_float_pos() const
    {
        return static_cast<float>(abs_pos) / (TableConfig::pulses_per_tenth * 10);
    }

    int print(char *buffer)
    {
        char rel_sign;
        int rel_int, rel_frac;
        decimal(rel_float_pos(), 100, rel_sign, rel_int, rel_frac);

        char abs_sign;
        int abs_int, abs_frac;
        decimal(abs_float_pos(), 100, abs_sign, abs_int, abs_frac);

        return sprintf(buffer, "%c%03d.%02d   %c%03d.%02d",
                       rel_sign, rel_int, rel_frac,
                       abs_sign, abs_int, abs_frac);
    }
};


struct PulseUpdate
{
    PulseUpdate(int x_pulse, int y_pulse) :
        x (x_pulse),
        y (y_pulse)
    {
    }
    int x;
    int y;
};


struct TenthUpdate
{
    TenthUpdate(int x_tenth, int y_tenth) :
        x (x_tenth),
        y (y_tenth)
    {
    }
    int x;
    int y;
};


struct Position
{
    Axis x;
    Axis y;

    template<class TPosUp> void update(const TPosUp &pos_up) = delete;

    template<class TPosUp> void rollback(const TPosUp &pos_rol) = delete;

    void reset() {
        x.reset();
        y.reset();
    }

    void set_ref()
    {
        x.set_ref();
        y.set_ref();
    }

    void print(char *buffer) {
        buffer += sprintf(buffer, "    -Rel-     -Abs- \n");
        buffer += sprintf(buffer, "X: ");
        buffer += x.print(buffer);
        buffer += sprintf(buffer, "\nY: ");
        buffer += y.print(buffer);
    }

};

template<> inline void Position::update<PulseUpdate>(const PulseUpdate &pos_up)
{
    x.incr_pulse(pos_up.x);
    x.set_ref();
    y.incr_pulse(pos_up.y);
    y.set_ref();
}

template<> inline void Position::update<TenthUpdate>(const TenthUpdate &pos_up)
{
    x.incr_tenth(pos_up.x);
    x.set_ref();
    y.incr_tenth(pos_up.y);
    y.set_ref();
}

template<> inline void Position::rollback<PulseUpdate>(const PulseUpdate &pos_rollb)
{
    x.incr_pulse(-pos_rollb.x);
    x.set_ref();
    y.incr_pulse(-pos_rollb.y);
    y.set_ref();
}

template<> inline void Position::rollback<TenthUpdate>(const TenthUpdate &pos_rollb)
{
    x.incr_tenth(-pos_rollb.x);
    x.set_ref();
    y.incr_tenth(-pos_rollb.y);
    y.set_ref();
}
