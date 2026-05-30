#ifndef CHU_GPI_H
#define CHU_GPI_H

#include <stdint.h>

typedef struct {
    uint32_t base_addr;
} gpi_core_t;

void gpi_init(gpi_core_t *dev, uint32_t base_addr);
uint32_t gpi_read(gpi_core_t *dev);
uint32_t gpi_read_bit(gpi_core_t *dev, uint32_t bit_pos);

#endif
