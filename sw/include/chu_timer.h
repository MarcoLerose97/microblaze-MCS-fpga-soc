/******************************************************************************
*
* CHU TIMER (64-BIT UP COUNTER)
*
* DESCRIPTION:
*
*   Free-running 64-bit hardware timer.
*
*   The counter increments every clock cycle when GO = 1.
*
*   Writing CLEAR = 1 resets the counter to 0.
*
*
* BASE ADDRESS:
*
*   TIMER_BASE_ADDR = 0xC0000000
*
*
* REGISTER MAP
*
*          31                             0
*          +-------------------------------+
* offset 0 |      COUNTER LOW WORD         |
*          |        counter[31:0]          |
*          +-------------------------------+
*
*          31                             0
*          +-------------------------------+
* offset 1 |      COUNTER HIGH WORD        |
*          |       counter[63:32]          |
*          +-------------------------------+
*
*          31                             2 1 0
*          +-------------------------------+-+-+
* offset 2 |                               |C|G|
*          +-------------------------------+-+-+
*
* G = GO
*     1 = counter enabled
*     0 = counter stopped
*
* C = CLEAR
*     1 = reset counter to 0
*
*
* REGISTER SUMMARY
*
*   offset 0:
*       counter low word
*
*   offset 1:
*       counter high word
*
*   offset 2:
*       control register
*
******************************************************************************/



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
