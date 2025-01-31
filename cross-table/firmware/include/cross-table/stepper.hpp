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


#include <pico/time.h>
#include <hardware/gpio.h>

#include <atomic>
#include <algorithm>
#include <cstdint>


class StepMotorDriver
{
public:
    StepMotorDriver(std::uint32_t pulse_pin, std::uint32_t dir_pin,
                    std::uint32_t ena_pin, std::uint32_t limit_pin) :
        m_pulse_pin (pulse_pin),
        m_dir_pin (dir_pin),
        m_ena_pin (ena_pin),
        m_limit_pin (limit_pin)
    {
        gpio_init(m_pulse_pin);
        gpio_set_dir(m_pulse_pin, GPIO_OUT);
        gpio_put(m_pulse_pin, 1);

        gpio_init(m_dir_pin);
        gpio_set_dir(m_dir_pin, GPIO_OUT);
        gpio_put(m_dir_pin, 1);

        gpio_init(m_ena_pin);
        gpio_set_dir(m_ena_pin, GPIO_OUT);
        gpio_put(m_ena_pin, 0);

        gpio_init(m_limit_pin);
        gpio_set_dir(m_limit_pin, GPIO_IN);
    }

    /**
     * Rotate the step motor
     *
     * If the input pin where the limit switch is plugged is zero, the
     * rotation is stopped and the number of pulses remaining is returned.
     *
     * @param direction, rotation direction (-1 or 1)
     * @param pulses, number of pulses to apply
     * @return the number of pulses remaining is returned.
     */
    std::uint32_t rotate(std::int32_t direction, std::uint32_t pulses)
    {
        hold();
        gpio_put(m_dir_pin, direction >= 0 ? 0 : 1);
        wait_us(50);

        std::int32_t period = m_slow_period;
        std::uint32_t count {0};
        std::uint32_t count_rev{pulses-1};
        for(; count < pulses && gpio_get(m_limit_pin); count++, count_rev--) {
            auto period_clip = std::max(period, m_fast_period);

            gpio_put(m_pulse_pin, 0);
            wait_us(period_clip);

            gpio_put(m_pulse_pin, 1);
            wait_us(period_clip);

            period = count < count_rev ? period - m_period_incr : period + m_period_incr;
        }
        // We prefer controlling the motor release in the main loop.
        // release();
        return pulses-count;
    }

    void hold()
    {
        sleep_us(50);
        gpio_put(m_ena_pin, 0);
   }

    void release()
    {
        sleep_us(50);
        gpio_put(m_ena_pin, 1);
    }

private:
    void wait_async_us(std::int32_t us)
    {
        m_event.store(false);
        add_alarm_in_us(us, StepMotorDriver::alarm_callback, this, false);
    }

    void wait_event()
    {
        while(m_event.load() == false);
    }

    void wait_us(std::int32_t us)
    {
        wait_async_us(us);
        wait_event();
    }

    static std::int64_t alarm_callback(alarm_id_t /*id*/, void *user_data)
    {
        reinterpret_cast<StepMotorDriver*>(user_data)->m_event.store(true);
        return 0;
    }

private:
    const std::uint32_t m_pulse_pin;
    const std::uint32_t m_dir_pin;
    const std::uint32_t m_ena_pin;
    const std::uint32_t m_limit_pin;

    static constexpr std::int32_t m_slow_period {2000};
    static constexpr std::int32_t m_fast_period {100};
    static constexpr std::int32_t m_period_incr {1};

    std::atomic<bool> m_event {false};
};
