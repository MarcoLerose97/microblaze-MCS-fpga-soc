# MMIO Subsystem Architecture

The MMIO subsystem provides the communication interface between the MicroBlaze CPU and the memory-mapped peripherals.

The subsystem is composed of:

- MMIO controller
- Peripheral slots

## MMIO Controller

The MMIO controller decodes CPU memory accesses and routes read/write transactions to the corresponding peripheral slot.

Main functions:

- address decoding
- slot selection
- read data multiplexing
- write strobe generation
- peripheral communication routing

RTL module:

- chu_mmio_controller.vhd

## Slot Architecture

The MMIO subsystem is organized in slots.

The architecture supports up to 64 peripheral slots.

Each slot can expose up to 32 memory-mapped registers, each 32 bits wide.



## Current Implemented Slots 

| Peripheral | Base Address |
|------------|--------------|
| Timer      | 0xC0000000   |
| UART       | 0xC0000100   |
| GPIO OUT   | 0xC0000200   |
| GPIO IN    | 0xC0000300   |
