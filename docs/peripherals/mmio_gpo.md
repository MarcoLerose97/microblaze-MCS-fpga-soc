# MMIO GPO Peripheral

General Purpose Output peripheral connected to the MMIO subsystem.

---

## Function

The peripheral provides a memory-mapped output interface
that can be controlled by the MicroBlaze CPU.

---

## MMIO Slot

- slot_2_gpo

---

## RTL Module

- `chu_gpo.vhd`

---

## Software Driver

- `chu_gpo.c`
- `chu_gpo.h`

---

## Base Address

```text
GPO_BASE_ADDR = 0xC0000100
```

---

## Register Map

```text
         31                             16 15             0
         +--------------------------------+----------------+
offset 0 |            reserved            | LED[15:0]      |
         +--------------------------------+----------------+
```

---

## Register Summary

| Offset | Register | Bits | Description |
|--------|-----------|------|-------------|
| 0x00 | LED_OUTPUT | [15:0] | GPIO output value |
| 0x00 | LED_OUTPUT | [31:16] | reserved |

---

## Notes

Writing to the output register updates the GPIO output pins.
