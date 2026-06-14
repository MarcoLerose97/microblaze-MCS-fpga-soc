# MMIO SPI Peripheral

SPI peripheral connected to the MMIO subsystem.

---

## Function

The SPI peripheral provides synchronous serial communication between the MicroBlaze CPU and external SPI devices.

The peripheral supports:

* SPI transmit
* SPI receive
* Programmable serial clock frequency
* CPOL configuration
* CPHA configuration
* Multiple slave-select outputs
* Transfer completion monitoring

---

## MMIO Slot

* slot_6_spi

---

## RTL Modules

* `chu_spi.vhd`
* `spi.vhd`

---

## Software Driver

* `chu_spi.c`
* `chu_spi.h`

---

## Base Address

```text
SPI_BASE_ADDR = 0xC0000300
```

---

## Register Map

```text
offset 0 : status and received data register (read)

         31                 9 8 7              0
         +-------------------+---+--------------+
         |     reserved      |RDY| RX_DATA[7:0]|
         +-------------------+---+--------------+


offset 1 : slave-select register (write)

         31                             0
         +--------------------------------+
         |         SS_N register          |
         +--------------------------------+


offset 2 : transmit register (write)

         31                             8 7              0
         +--------------------------------+---------------+
         |           reserved             | TX_DATA[7:0] |
         +--------------------------------+---------------+


offset 3 : control register (write)

         31         17      16      15              0
         +------------+-------+-------+--------------+
         | reserved   | CPHA  | CPOL  | DVSR[15:0]  |
         +------------+-------+-------+--------------+
```

---

## Register Summary

| Offset | Register | Bits    | Description            |
| ------ | -------- | ------- | ---------------------- |
| 0x00   | STATUS   | [7:0]   | received SPI byte      |
| 0x00   | STATUS   | [8]     | SPI ready flag         |
| 0x00   | STATUS   | [31:9]  | reserved               |
| 0x04   | SS_N     | [31:0]  | slave-select outputs   |
| 0x08   | TX_DATA  | [7:0]   | byte to be transmitted |
| 0x08   | TX_DATA  | [31:8]  | reserved               |
| 0x0C   | CONTROL  | [15:0]  | clock divisor          |
| 0x0C   | CONTROL  | [16]    | CPOL                   |
| 0x0C   | CONTROL  | [17]    | CPHA                   |
| 0x0C   | CONTROL  | [31:18] | reserved               |

---

## Notes

The SPI peripheral operates as an SPI master.

The slave-select outputs are active low.

Writing a byte to the TX_DATA register starts a new SPI transfer.

The received byte is available in the status register when the ready flag is asserted.

---

## Clock Configuration

The SPI serial clock is generated internally from the FPGA system clock.

The clock divisor (`DVSR`) is programmed through the control register.

The generated SPI clock frequency is:

```text
f_spi = f_clk / (2 × (DVSR + 1))
```

where:

```text
f_clk = FPGA system clock frequency
DVSR  = SPI clock divisor
```

For a 100 MHz system clock and a target SPI clock of 200 kHz:

```text
DVSR = f_clk / (2 × f_spi) - 1

DVSR = 100000000 / (2 × 200000) - 1
DVSR = 249
```

Therefore:

```text
DVSR = 249
```

generates approximately:

```text
f_spi = 200 kHz
```

---

## SPI Modes

The peripheral supports the four standard SPI modes through the CPOL and CPHA configuration bits.

| Mode | CPOL | CPHA |
| ---- | ---- | ---- |
| 0    | 0    | 0    |
| 1    | 0    | 1    |
| 2    | 1    | 0    |
| 3    | 1    | 1    |

The CPOL bit controls the idle state of the serial clock, while the CPHA bit selects the clock edge used for sampling and shifting data.

