#include "chu_gpo.h"
#include "chu_io_rw.h"

void gpo_init(gpo_core_t *dev, uint32_t base_addr)
{
    dev->base_addr = base_addr;
    dev->wr_data = 0u;
}

void gpo_write(gpo_core_t *dev, uint32_t data)
{
    dev->wr_data = data;
    io_write(dev->base_addr, 0u, dev->wr_data);
}

void gpo_write_bit(gpo_core_t *dev, uint32_t bit_value, uint32_t bit_pos)
{
    if (bit_value) {
        dev->wr_data |= (1u << bit_pos);
    } else {
        dev->wr_data &= ~(1u << bit_pos);
    }

    io_write(dev->base_addr, 0u, dev->wr_data);
}
