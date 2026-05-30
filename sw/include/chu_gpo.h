#ifndef CHU_GPO_H
#define CHU_GPO_H

#include <stdint.h>

typedef struct {
    uint32_t base_addr;
} gpo_core_t;

void gpo_init(gpo_core_t *dev, uint32_t base_addr);
void gpo_write(gpo_core_t *dev, uint32_t data);
void gpo_write_bit(gpo_core_t *dev, uint32_t bit_value, uint32_t bit_pos);

#endif
