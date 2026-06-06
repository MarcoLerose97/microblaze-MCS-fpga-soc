#include "chu_pwm.h"
#include "chu_io_rw.h"

void pwm_init(pwm_core_t *dev, uint32_t base_addr)
{
    dev->base_addr = base_addr;
}

void pwm_set_divisor(pwm_core_t *dev, uint32_t dvsr)
{
    io_write(dev->base_addr, PWM_DVSR_REG, dvsr);
}

void pwm_set_duty_raw(pwm_core_t *dev, uint8_t channel, uint16_t duty)
{
    if (channel >= 16u) {
        return;
    }

    if (duty > 256u) {
        duty = 256u;
    }

    io_write(dev->base_addr, PWM_DUTY_BASE_REG + channel, duty);
}

void pwm_set_duty_percent(pwm_core_t *dev, uint8_t channel, uint8_t percent)
{
    uint16_t duty;

    if (percent > 100u) {
        percent = 100u;
    }

    duty = (uint16_t)((percent * 256u) / 100u);

    pwm_set_duty_raw(dev, channel, duty);
}

uint32_t pwm_calc_divisor(uint32_t sys_clk_hz, uint32_t pwm_freq_hz)
{
    return (sys_clk_hz / (pwm_freq_hz * 256u)) - 1u;
}
