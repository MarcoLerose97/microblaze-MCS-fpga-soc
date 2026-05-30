#ifndef CHU_IO_MAP_H
#define CHU_IO_MAP_H

#include <stdint.h>

#define BRIDGE_BASE 0xC0000000u

#define S0_SYS_TIMER 0u
#define S1_UART1     1u
#define S2_LED       2u
#define S3_SW        3u

#define SLOT_SIZE_REGS 32u
#define SLOT_SIZE_BYTES (SLOT_SIZE_REGS * 4u)

#define get_slot_addr(mmio_base, slot) \
    ((uint32_t)((mmio_base) + ((slot) * SLOT_SIZE_BYTES)))

#define TIMER_BASE_ADDR get_slot_addr(BRIDGE_BASE, S0_SYS_TIMER)
#define UART_BASE       get_slot_addr(BRIDGE_BASE, S1_UART1)
#define LED_BASE get_slot_addr(BRIDGE_BASE, S2_LED)
#define SW_BASE  get_slot_addr(BRIDGE_BASE, S3_SW)

#endif
