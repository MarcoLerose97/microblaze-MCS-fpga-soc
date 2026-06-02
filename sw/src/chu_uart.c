#include "chu_uart.h"
#include "chu_io_rw.h"

void uart_init(uart_core_t *dev, uint32_t base_addr)
{
    dev->base_addr = base_addr;
}

/*
 * baud generator:
 * tick frequency = baud_rate * 16
 *
 * dvsr = sys_clk_hz / (baud_rate * 16) - 1
 *
 * Example 100 MHz, 115200:
 * dvsr = 100000000 / (115200*16) - 1
 *      = 53.25 -> use 54 circa, or integer 53 depending rounding.
 */
void uart_set_baud_rate(uart_core_t *dev, uint32_t sys_clk_hz, uint32_t baud_rate)
{
    uint32_t dvsr;

    dvsr = (sys_clk_hz / (baud_rate * 16u)) - 1u;

    io_write(dev->base_addr, UART_DVSR_REG, dvsr);
}

uint32_t uart_read_status(uart_core_t *dev)
{
    return io_read(dev->base_addr, 0u);
}

uint8_t uart_rx_empty(uart_core_t *dev)
{
    return (uart_read_status(dev) & UART_RX_EMPTY_MASK) ? 1u : 0u;
}

uint8_t uart_tx_full(uart_core_t *dev)
{
    return (uart_read_status(dev) & UART_TX_FULL_MASK) ? 1u : 0u;
}

void uart_write_byte(uart_core_t *dev, uint8_t data)
{
    while (uart_tx_full(dev)) {
    }

    io_write(dev->base_addr, UART_TX_REG, (uint32_t)data);
}

uint8_t uart_read_byte(uart_core_t *dev)
{
    uint32_t status;
    uint8_t data;

    while (uart_rx_empty(dev)) {
    }

    status = uart_read_status(dev);
    data = (uint8_t)(status & UART_RX_DATA_MASK);

    /*
     * Dummy write to remove one byte from RX FIFO.
     */
    io_write(dev->base_addr, UART_RX_REMOVE_REG, 0u);

    return data;
}

void uart_write_string(uart_core_t *dev, const char *s)
{
    while (*s != '\0') {
        uart_write_byte(dev, (uint8_t)(*s));
        s++;
    }
}
