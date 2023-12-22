#pragma once

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

    void incr(int val)
    {
        abs_pos += val;
    }

    void reset(void) {
        abs_pos = 0;
        abs_ref = 0;
    }

    void set_ref()
    {
        abs_ref = abs_pos;
    }

    int rel_pos() const
    {
        return abs_pos - abs_ref;
    }

    int print(char *buffer)
    {
        auto rel = rel_pos();
        char abs_sign = abs_pos < 0 ? '-' : ' ';
        char rel_sign = rel < 0 ? '-' : ' ';
        int abs_integer, abs_frac;
        int rel_integer, rel_frac;
        decimal(abs_pos, abs_integer, abs_frac);
        decimal(rel, rel_integer, rel_frac);
        return sprintf(buffer, "%c%03d.%1d     %c%03d.%1d",
                       abs_sign, std::abs(abs_integer), std::abs(abs_frac),
                       rel_sign, std::abs(rel_integer), std::abs(rel_frac));
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
        buffer += sprintf(buffer, "X: ");
        buffer += x.print(buffer);
        buffer += sprintf(buffer, "\nY: ");
        buffer += y.print(buffer);
    }

};
