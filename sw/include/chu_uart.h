#ifndef CHU_UART_H
#define CHU_UART_H

#include <stdint.h>

#define UART_DVSR_REG      1u
#define UART_TX_REG        2u
#define UART_RX_REMOVE_REG 3u

#define UART_RX_DATA_MASK  0x000000FFu
#define UART_RX_EMPTY_MASK 0x00000100u
#define UART_TX_FULL_MASK  0x00000200u

typedef struct {
    uint32_t base_addr;
} uart_core_t;

void uart_init(uart_core_t *dev, uint32_t base_addr);
void uart_set_baud_rate(uart_core_t *dev, uint32_t sys_clk_hz, uint32_t baud_rate);

uint32_t uart_read_status(uart_core_t *dev);
uint8_t uart_rx_empty(uart_core_t *dev);
uint8_t uart_tx_full(uart_core_t *dev);

void uart_write_byte(uart_core_t *dev, uint8_t data);
uint8_t uart_read_byte(uart_core_t *dev);

void uart_write_string(uart_core_t *dev, const char *s);

#endif
