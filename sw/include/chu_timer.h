#ifndef CHU_TIMER_H
#define CHU_TIMER_H

#include <stdint.h>

typedef struct {
    uint32_t base_addr;
} timer_core_t;

void timer_init(timer_core_t *dev, uint32_t base_addr);
void timer_clear(timer_core_t *dev);
void timer_start(timer_core_t *dev);
void timer_stop(timer_core_t *dev);
uint32_t timer_read_low(timer_core_t *dev);
uint32_t timer_read_high(timer_core_t *dev);

#endif
