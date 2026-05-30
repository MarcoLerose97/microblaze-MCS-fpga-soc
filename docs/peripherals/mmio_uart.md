# MMIO UART Peripheral

UART peripheral connected to the MMIO subsystem.

## Features

- UART TX/RX communication
- Memory-mapped interface
- Configurable baud rate
- FIFO-based communication

## RTL Modules

- uart_core.vhd
- uart_rx.vhd
- uart_tx.vhd
- baud_gen.vhd

## MMIO Slot

Current slot:
- slot_1_uart


## Software Driver

Software driver:
- chu_uart.c
- chu_uart.h
