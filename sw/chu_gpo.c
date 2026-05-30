#include "chu_gpo.h"
#include "chu_io_rw.h"

void gpo_init(gpo_core_t *dev, uint32_t base_addr)
{
    dev->base_addr = base_addr;
}

void gpo_write(gpo_core_t *dev, uint32_t data)
{
    io_write(dev->base_addr, 0u, data);
}

void gpo_write_bit(gpo_core_t *dev, uint32_t bit_value, uint32_t bit_pos)
{
    uint32_t mask = 1u << bit_pos;
    uint32_t data = io_read(dev->base_addr, 0u);

    if (bit_value) {
        data |= mask;
    } else {
        data &= ~mask;
    }

    io_write(dev->base_addr, 0u, data);
}
