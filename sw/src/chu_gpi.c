#include "chu_gpi.h"
#include "chu_io_rw.h"

void gpi_init(gpi_core_t *dev, uint32_t base_addr)
{
    dev->base_addr = base_addr;
}

uint32_t gpi_read(gpi_core_t *dev)
{
    return io_read(dev->base_addr, 0u);
}

uint32_t gpi_read_bit(gpi_core_t *dev, uint32_t bit_pos)
{
    return (gpi_read(dev) >> bit_pos) & 1u;
}
