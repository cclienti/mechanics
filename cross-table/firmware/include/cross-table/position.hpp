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

#include <vector>
#include <cstdlib>
#include <cstdio>


/**
 * @brief Handle the X/Y values in pulse that must be added or removed to a Position instance.
 */
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


/**
 * @brief Handle the X/Y values in tenth that must be added or removed to a Position instance.
 */
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


/**
 * @brief Handle an axis position, with relative and absolute capabilities.
 *
 * The class also handles both stepper motor pulse unit and tenth a millimeter unit.
 *
 */
struct Axis
{
    int abs_pos {0};
    int abs_ref {0};

    /**
     * @brief Static to get fractional and integer part of a float number with the desired precision.
     *
     * This method is used when we want to print a number in hundreth
     * a millimeter. It is worth mentioning that the pi/pico float
     * printf implementation does not support well all capabilities in
     * term of float format, like "%+06.02f".
     */
    static void decimal(const float value, const int precision, char &sign, int &integer, int &frac)
    {
        sign = value < 0 ? '-' : '+';
        auto abs_value = std::abs(value);
        integer = static_cast<int>(abs_value);
        frac = static_cast<int>(abs_value * precision) % precision;
    }

    /**
     * @brief increment the position with the value in pulse (stepper motor unit).
     */
    void incr_pulse(int val)
    {
        abs_pos += val;
    }

    /**
     * @brief Increment the position with the value expressed in half a tenth a millimter.
     */
    void incr_half_tenth(int val)
    {
        abs_pos += val * (TableConfig::pulses_per_half_tenth);
    }

    /**
     * @brief Increment the position with the value expressed in tenth a millimter.
     */
    void incr_tenth(int val)
    {
        abs_pos += val * TableConfig::pulses_per_tenth;
    }

    /**
     * @brief Fully reset the position (ref and abs)
     */
    void reset(void) {
        abs_pos = 0;
        abs_ref = 0;
    }

    /**
     * @brief Set the current position as the new reference.
     */
    void set_ref()
    {
        abs_ref = abs_pos;
    }

    /**
     * @brief Return the position relative to the reference in pulse (stepper motor unit).
     */
    int rel_pulse_pos() const
    {
        return abs_pos - abs_ref;
    }

    /**
     * @brief Return the absolute position in pulse (stepper motor unit).
     */
    int abs_pulse_pos() const
    {
        return abs_pos;
    }

    /**
     * @brief Return the position relative to the reference in millimeter.
     */
    float rel_float_pos() const
    {
        return static_cast<float>(rel_pulse_pos()) / (TableConfig::pulses_per_tenth * 10);
    }

    /**
     * @brief Return the absolute position in millimeter.
     */
    float abs_float_pos() const
    {
        return static_cast<float>(abs_pos) / (TableConfig::pulses_per_tenth * 10);
    }

    /**
     * @brief Format the given buffer with all relative and absolute position in millimeter.
     */
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


/**
 * @brief Handle the absolute and relative position in X and Y of the cross-table.
 */
struct Position
{
    Axis x;
    Axis y;

    /**
     * @brief Update the rel position with the the given PulseUpdate/TenthUpdate value.
     */
    template<class TPosUp> void update(const TPosUp &pos_up) = delete;

    /**
     * @brief Rollback the rel position using the given PulseUpdate/TenthUpdate value.
     */
    template<class TPosUp> void rollback(const TPosUp &pos_rol) = delete;

    /**
     * @brief Full rollback: remove everything incremented to the rel position.
     */
    void rollback()
    {
        x.incr_pulse(-x.rel_pulse_pos());
        y.incr_pulse(-y.rel_pulse_pos());
    }

    /**
     * @brief Reset the position axis.
     */
    void reset()
    {
        x.reset();
        y.reset();
    }

    /**
     * @brief Add the relative position to the absolute position and clear relative position.
     */
    void set_ref()
    {
        x.set_ref();
        y.set_ref();
    }

    /**
     * @brief Return true if the rel position is null
     */
    bool is_null_rel() const
    {
        return (x.rel_pulse_pos() == 0 && y.rel_pulse_pos() == 0);
    }

    /**
     * @brief Format to a string all the position information
     */
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
    y.incr_pulse(pos_up.y);
}

template<> inline void Position::update<TenthUpdate>(const TenthUpdate &pos_up)
{
    x.incr_tenth(pos_up.x);
    y.incr_tenth(pos_up.y);
}

template<> inline void Position::rollback<PulseUpdate>(const PulseUpdate &pos_rollb)
{
    x.incr_pulse(-pos_rollb.x);
    y.incr_pulse(-pos_rollb.y);
}

template<> inline void Position::rollback<TenthUpdate>(const TenthUpdate &pos_rollb)
{
    x.incr_tenth(-pos_rollb.x);
    y.incr_tenth(-pos_rollb.y);
}


/**
 * @Brief Handle the table position using an internal array of PulseUpdate.
 */
class PositionsHandler
{
public:

    /**
     * @brief Set the list of PulseUpdate value
     *
     * The index is set to -1 internally to use it as a flag by the
     * changed() method.
     */
    void set(const std::vector<PulseUpdate> &updates)
    {
        m_updates = updates;
        m_index = -1;
    }

    /**
     * @brief Update the given position with the current PulseUpdate value.
     * @param[inout] pos
     */
    void update_rel_pos(Position &pos) const
    {
        if (m_index >= 0 && m_index < updates_size()) {
            pos.x.incr_pulse(m_updates[m_index].x);
            pos.y.incr_pulse(m_updates[m_index].y);
        }
    }

    /**
     * @brief Rollback the given position with the current PulseUpdate value.
     * @param[inout] pos
     *
     * Subtract the relative pos with the PulseUpdate found at the
     * current index.
     */
    void revert_rel_pos(Position &pos) const
    {
        if (m_index >= 0 && m_index < updates_size()) {
            pos.x.incr_pulse(-m_updates[m_index].x);
            pos.y.incr_pulse(-m_updates[m_index].y);
        }
    }

    /**
     * @brief Return true if the given relative position is the same at current index.
     */
    bool is_same_pos(const Position &pos) const
    {
        if (m_index >= 0 && m_index < updates_size()) {
            if (m_updates[m_index].x == pos.x.rel_pulse_pos() &&
                m_updates[m_index].y == pos.y.rel_pulse_pos()) {
                return true;
            }
        }
        return false;
    }

    /**
     * @brief Is relative position is exactly the opposite than the one found at current index.
     */
    bool is_counter_pos(const Position &pos) const
    {
        if (m_index >= 0 && m_index < updates_size()) {
            if (-m_updates[m_index].x == pos.x.rel_pulse_pos() &&
                -m_updates[m_index].y == pos.y.rel_pulse_pos()) {
                return true;
            }
        }
        return false;
    }

    /**
     * @brief Update the current index with the given update.
     * @param[in] update
     *
     * If the index is at the end, a new element is appended with the
     * given update.
     */
    void commit(const PulseUpdate up)
    {
        int x = up.x;
        int y = up.y;

        if (m_index >= updates_size()) {
            m_updates.emplace_back(x, y);
            return;
        }
        else {
            m_updates[m_index].x = x;
            m_updates[m_index].y = y;
        }
    }

    /**
     * @brief Return true if the list of PulseUpdate has been changed.
     *
     * if changed() returns true, user must call next() before
     * updating a position with update_rel_pos().
     */
    bool changed() const
    {
        return m_index < 0;
    }

    /**
     * @brief Increment the PulseUpdate array index
     * @return true if the index points to a valid value else false.
     */
    bool next()
    {
        if (m_index < updates_size()) {
            // The index can be equal to m_updates.size() in order to
            // detect if a new element must be added when publishing a
            // new value.
            m_index++;
            return true;
        }
        return false;
    }

    /**
     * @brief Decrement the PulseUpdate array index
     * @return true if the index points to a valid value else false.
     */
    bool prev()
    {
        if (m_index > 0) {
            m_index--;
            return true;
        }
        if (m_index == 0) {
            m_index--;
        }
        return false;
    }

private:
    /**
     * @brief return the size of the PulseUpdate array.
     */
    int updates_size() const
    {
        return static_cast<int>(m_updates.size());
    }

private:
    std::vector<PulseUpdate> m_updates;
    int m_index {0};
};
