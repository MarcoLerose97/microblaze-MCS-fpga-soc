#include <stdint.h>

#include "chu_uart.h"
#include "chu_io_map.h"

int main(void)
{
    uart_core_t uart;
    uint8_t data;

    uart_init(&uart, UART_BASE);

    uart_set_baud_rate(&uart, SYS_CLK_FREQ * 1000000u, 9600u);

    uart_write_string(&uart, "UART ready\r\n");

    while (1)
    {
        data = uart_read_byte(&uart);

        uart_write_byte(&uart, data);
    }
}
