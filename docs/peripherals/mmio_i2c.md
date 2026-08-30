# MMIO I2C Peripheral

I2C peripheral connected to the MMIO subsystem.

---

## Function

The I2C peripheral provides synchronous serial communication between the MicroBlaze CPU and external I2C devices.

The peripheral supports:

* I2C master operation
* START condition generation
* STOP condition generation
* RESTART condition generation
* Byte transmission
* Byte reception
* ACK/NACK handling
* Programmable I2C clock frequency
* Transfer completion monitoring

---

## MMIO Slot

* slot_7_i2c

---

## RTL Modules

* `chu_i2c_core.vhd`
* `i2c_master.vhd`

---

## Software Driver

* `i2c_core.c`
* `i2c_core.h`

---

## Base Address

```text
I2C_BASE_ADDR = 0xC0000380
```

---

## Register Map

```text
offset 0 : received data and status register (read)

         31                 10 9   8 7              0
         +--------------------+---+---+---------------+
         |      reserved      |ACK|RDY| RX_DATA[7:0] |
         +--------------------+---+---+---------------+


offset 0 : clock divisor register (write)

         31                             16 15             0
         +--------------------------------+----------------+
         |            reserved            |   DVSR[15:0]   |
         +--------------------------------+----------------+


offset 1 : data and command register (write)

         31                 11 10       8 7              0
         +--------------------+-----------+----------------+
         |      reserved      | CMD[2:0]  | TX_DATA[7:0]  |
         +--------------------+-----------+----------------+
```

---

## Register Summary

| Offset | Access | Register | Bits | Description |
| ------ | ------ | -------- | ---- | ----------- |
| 0x00 | Read | STATUS | [7:0] | received I2C byte |
| 0x00 | Read | STATUS | [8] | I2C ready flag |
| 0x00 | Read | STATUS | [9] | acknowledge bit |
| 0x00 | Read | STATUS | [31:10] | reserved |
| 0x00 | Write | DVSR | [15:0] | I2C clock divisor |
| 0x00 | Write | DVSR | [31:16] | reserved |
| 0x04 | Write | DATA_CMD | [7:0] | transmit data |
| 0x04 | Write | DATA_CMD | [10:8] | I2C command |
| 0x04 | Write | DATA_CMD | [31:11] | reserved |

---

## I2C Commands

The command field `CMD[2:0]` selects the operation performed by the I2C controller.

| Command | CMD[2:0] | Value |
| ------- | -------- | ----- |
| START | `000` | 0 |
| WRITE | `001` | 1 |
| READ | `010` | 2 |
| STOP | `011` | 3 |
| RESTART | `100` | 4 |

Writing to the DATA_CMD register starts the selected I2C operation.

For WRITE operations, bits `[7:0]` contain the byte to be transmitted.

For READ operations, the received byte is returned in bits `[7:0]` of the STATUS register.

---

## Notes

The I2C peripheral operates as an I2C master.

The ready flag indicates that the controller can accept a new command.

After a write operation, the acknowledge bit indicates whether the transmitted byte was acknowledged by the slave.

The SDA line is bidirectional and uses open-drain signaling.

Both SDA and SCL require pull-up resistors.

---

## Clock Configuration

The I2C serial clock is generated internally from the FPGA system clock.

The clock divisor (`DVSR`) is programmed through the divisor register.

The I2C clock frequency is:

```text
f_i2c = f_clk / (4 × DVSR)
```

Therefore:

```text
DVSR = f_clk / (4 × f_i2c)
```

For a 100 MHz system clock and a target I2C clock of 100 kHz:

```text
DVSR = 100000000 / (4 × 100000)
DVSR = 250
```

Therefore:

```text
DVSR = 250
```

generates approximately:

```text
f_i2c = 100 kHz
```

---

## I2C Transfer Sequence

A typical I2C write transaction consists of:

```text
START
  ↓
Device Address + Write bit
  ↓
ACK
  ↓
Data Byte(s)
  ↓
ACK
  ↓
STOP
```

A typical I2C read transaction consists of:

```text
START
  ↓
Device Address + Read bit
  ↓
ACK
  ↓
Data Byte(s)
  ↓
NACK on last byte
  ↓
STOP
```

A RESTART command can be used instead of STOP when another I2C transaction must immediately follow the current transaction.
