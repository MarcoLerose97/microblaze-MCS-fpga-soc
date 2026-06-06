#ifndef CHU_PWM_H
#define CHU_PWM_H

#include <stdint.h>

#define PWM_DVSR_REG      0u
#define PWM_DUTY_BASE_REG 16u

typedef struct {
    uint32_t base_addr;
} pwm_core_t;

void pwm_init(pwm_core_t *dev, uint32_t base_addr);

void pwm_set_divisor(pwm_core_t *dev, uint32_t dvsr);
void pwm_set_duty_raw(pwm_core_t *dev, uint8_t channel, uint16_t duty);
void pwm_set_duty_percent(pwm_core_t *dev, uint8_t channel, uint8_t percent);

uint32_t pwm_calc_divisor(uint32_t sys_clk_hz, uint32_t pwm_freq_hz);

#endif
