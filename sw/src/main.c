#include <stdint.h>

#include "chu_io_map.h"
#include "chu_pwm.h"

#define SYS_CLK_HZ 100000000u

int main(void)
{
    pwm_core_t pwm;
    uint32_t dvsr;

    pwm_init(&pwm, PWM_BASE);

    /*
     * 50 kHz PWM frequency
     */
    dvsr = pwm_calc_divisor(SYS_CLK_HZ, 50000u);
    pwm_set_divisor(&pwm, dvsr);

    /*
     * Channel 0 -> 20%
     * Channel 1 -> 40%
     * Channel 2 -> 60%
     */
    pwm_set_duty_percent(&pwm, 0u, 20u);
    pwm_set_duty_percent(&pwm, 1u, 40u);
    pwm_set_duty_percent(&pwm, 2u, 60u);

    while (1)
    {
        /* nothing */
    }

    return 0;
}
