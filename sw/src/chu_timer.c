#include "chu_timer.h"
#include "chu_io_rw.h"

#define TIMER_COUNTER_LOW_REG   0u
#define TIMER_COUNTER_HIGH_REG  1u
#define TIMER_CONTROL_REG       2u

#define TIMER_GO_BIT     0u
#define TIMER_CLEAR_BIT  1u

void timer_init(timer_core_t *dev, uint32_t base_addr)
{
    dev->base_addr = base_addr;
}

void timer_clear(timer_core_t *dev)
{
    io_write(dev->base_addr, TIMER_CONTROL_REG, (1u << TIMER_CLEAR_BIT));
}

void timer_start(timer_core_t *dev)
{
    io_write(dev->base_addr, TIMER_CONTROL_REG, (1u << TIMER_GO_BIT));
}

void timer_stop(timer_core_t *dev)
{
    io_write(dev->base_addr, TIMER_CONTROL_REG, 0u);
}

uint32_t timer_read_low(timer_core_t *dev)
{
    return io_read(dev->base_addr, TIMER_COUNTER_LOW_REG);
}

uint32_t timer_read_high(timer_core_t *dev)
{
    return io_read(dev->base_addr, TIMER_COUNTER_HIGH_REG);
}
