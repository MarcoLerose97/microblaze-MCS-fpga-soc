#ifndef CHU_UART_H
#define CHU_UART_H

#include <stdint.h>

typedef struct {
    uint32_t base_addr;
} uart_core_t;

void uart_init(uart_core_t *dev, uint32_t base_addr);

uint32_t uart_status(uart_core_t *dev);

int uart_tx_fifo_full(uart_core_t *dev);
int uart_rx_fifo_empty(uart_core_t *dev);

void uart_putc(uart_core_t *dev, char c);
void uart_puts(uart_core_t *dev, const char *s);

int uart_getc(uart_core_t *dev);

#endif
