// Il file chu_io_map.h definisce la mappa di memoria delle periferiche del sistema SoC implementato su 
FPGA. Le periferiche, come timer, UART, LED, switch, PWM, SPI e I2C, sono associate a specifici slot di
Indirizzamento all'interno di uno spazio di memoria condiviso, il cui indirizzo base è 0xC0000000.
Ogni slot occupa 128 byte, equivalenti a 32 registri da 32 bit. Attraverso la macro get_slot_addr(), viene
calcolato automaticamente l'indirizzo base di ciascuna periferica in funzione dello slot assegnato.
In questo modo, il firmware eseguito dal processore MicroBlaze può accedere ai registri delle periferiche
hardware mediante indirizzi di memoria, senza dover conoscere direttamente i dettagli della loro
implementazione VHDL. //


#ifndef CHU_IO_MAP_H
#define CHU_IO_MAP_H

#include <stdint.h>

#define BRIDGE_BASE 0xC0000000u

#define SYS_CLK_FREQ 100

#define S0_SYS_TIMER 0u
#define S1_UART1     1u
#define S2_LED       2u
#define S3_SW        3u

#define S5_PWM       5u
#define S6_SPI       6u
#define S7_I2C       7u

#define SLOT_SIZE_REGS 32u
#define SLOT_SIZE_BYTES (SLOT_SIZE_REGS * 4u)

#define get_slot_addr(mmio_base, slot) \
    ((uint32_t)((mmio_base) + ((slot) * SLOT_SIZE_BYTES)))

#define TIMER_BASE_ADDR get_slot_addr(BRIDGE_BASE, S0_SYS_TIMER)
#define UART_BASE       get_slot_addr(BRIDGE_BASE, S1_UART1)
#define LED_BASE get_slot_addr(BRIDGE_BASE, S2_LED)
#define SW_BASE  get_slot_addr(BRIDGE_BASE, S3_SW)

#define PWM_BASE  get_slot_addr(BRIDGE_BASE, S5_PWM)
#define SPI_BASE get_slot_addr(BRIDGE_BASE, S6_SPI)
#define I2C_BASE get_slot_addr(BRIDGE_BASE, S7_I2C)

#endif
