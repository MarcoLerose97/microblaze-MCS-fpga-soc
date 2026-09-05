#include "chu_timer.h"
#include "chu_io_rw.h"

/* Register offsets */
#define TIMER_COUNTER_LOW_REG   0u
#define TIMER_COUNTER_HIGH_REG  1u
#define TIMER_CONTROL_REG       2u

/* Control bits */
#define TIMER_GO_BIT            0u
#define TIMER_CLEAR_BIT         1u

void timer_init(timer_core_t *dev, uint32_t base_addr)
{
    dev->base_addr = base_addr;
    dev->ctrl = 0u;

    io_write(dev->base_addr,
             TIMER_CONTROL_REG,
             dev->ctrl);
}

void timer_start(timer_core_t *dev)
{
    dev->ctrl |= (1u << TIMER_GO_BIT);

    io_write(dev->base_addr,
             TIMER_CONTROL_REG,
             dev->ctrl);
}

void timer_stop(timer_core_t *dev)
{
    dev->ctrl &= ~(1u << TIMER_GO_BIT);

    io_write(dev->base_addr,
             TIMER_CONTROL_REG,
             dev->ctrl);
}

void timer_clear(timer_core_t *dev)
{
    uint32_t wdata;

    wdata = dev->ctrl | (1u << TIMER_CLEAR_BIT);

    io_write(dev->base_addr,
             TIMER_CONTROL_REG,
             wdata);
}

uint32_t timer_read_low(timer_core_t *dev)
{
    return io_read(dev->base_addr,
                   TIMER_COUNTER_LOW_REG);
}

uint32_t timer_read_high(timer_core_t *dev)
{
    return io_read(dev->base_addr,
                   TIMER_COUNTER_HIGH_REG);
}

uint64_t timer_read_tick(timer_core_t *dev)
{
    uint64_t lower;
    uint64_t upper;

    lower = (uint64_t)timer_read_low(dev);
    upper = (uint64_t)timer_read_high(dev);

    return (upper << 32) | lower;
}
