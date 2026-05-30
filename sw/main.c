#include "chu_uart.h"
#include "chu_io_map.h"

uart_core_t uart;

int main(void)
{
    uart_init(&uart, UART_BASE);

    while (1) {

        uart_puts(&uart, "Hello from FPGA\r\n");
    }

    return 0;
}