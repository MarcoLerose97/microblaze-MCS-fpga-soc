/******************************************************************************
*
* CHU GPO (GENERAL PURPOSE OUTPUT)
*
* DESCRIPTION:
*
*   16-bit writeable LED output peripheral.
*
*   Writing updates the LED outputs.
*
*
* BASE ADDRESS:
*
*   LED_BASE_ADDR = 0xC0000100
*
*
* REGISTER MAP
*
*          31                             16 15             0
*          +--------------------------------+----------------+
* offset 0 |            reserved            | LED[15:0]      |
*          +--------------------------------+----------------+
*
*
* REGISTER SUMMARY
*
*   offset 0:
*       LED output register
*
******************************************************************************/



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
