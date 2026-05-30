#include "chu_uart.h"
#include "chu_io_rw.h"

#define UART_STATUS_REG 0u
#define UART_TX_REG     2u
#define UART_RX_REG     3u

#define UART_TX_BUSY_BIT       0u
#define UART_TX_EMPTY_BIT      1u
#define UART_TX_FULL_BIT       2u
#define UART_RX_EMPTY_BIT      3u
#define UART_RX_FULL_BIT       4u

void uart_init(uart_core_t *dev, uint32_t base_addr)
{
    dev->base_addr = base_addr;
}

uint32_t uart_status(uart_core_t *dev)
{
    return io_read(dev->base_addr, UART_STATUS_REG);
}

int uart_tx_fifo_full(uart_core_t *dev)
{
    return (uart_status(dev) >> UART_TX_FULL_BIT) & 1u;
}

int uart_rx_fifo_empty(uart_core_t *dev)
{
    return (uart_status(dev) >> UART_RX_EMPTY_BIT) & 1u;
}

void uart_putc(uart_core_t *dev, char c)
{
    while (uart_tx_fifo_full(dev)) {
    }

    io_write(dev->base_addr, UART_TX_REG, (uint32_t)c);
}

void uart_puts(uart_core_t *dev, const char *s)
{
    while (*s) {
        uart_putc(dev, *s++);
    }
}

int uart_getc(uart_core_t *dev)
{
    if (uart_rx_fifo_empty(dev)) {
        return -1;
    }

    return (int)(io_read(dev->base_addr, UART_RX_REG) & 0xFFu);
}
