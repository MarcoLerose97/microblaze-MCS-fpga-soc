#include <stdint.h>
#include "chu_uart.h"

#define UART_BASE_ADDR  0xC0000200u   // Metti il vero indirizzo della UART
#define SYS_CLK_HZ      100000000u
#define BAUD_RATE       9600u

int main(void)
{
    uart_core_t uart;
    uint8_t data;

    /* Inizializzazione */
    uart_init(&uart, UART_BASE_ADDR);

    /* Imposta il baud rate */
    uart_set_baud_rate(&uart, SYS_CLK_HZ, BAUD_RATE);

    /* Trasmette una stringa iniziale */
    uart_write_string(&uart, "UART ready\r\n");

    while (1)
    {
        /* Rimane qui finché non riceve un byte */
        data = uart_read_byte(&uart);

        /* Ritrasmette il byte ricevuto */
        uart_write_byte(&uart, data);
    }
}
