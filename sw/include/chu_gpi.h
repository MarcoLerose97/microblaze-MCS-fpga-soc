/******************************************************************************
*
* CHU GPI (GENERAL PURPOSE INPUT)
*
* DESCRIPTION:
*
*   16-bit read-only switch input peripheral.
*
*
* BASE ADDRESS:
*
*   SW_BASE_ADDR = 0xC0000180
*
*
* REGISTER MAP
*
*          31                             16 15             0
*          +--------------------------------+----------------+
* offset 0 |            reserved            | SW[15:0]       |
*          +--------------------------------+----------------+
*
*
* REGISTER SUMMARY
*
*   offset 0:
*       returns current switch state
*
******************************************************************************/



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
