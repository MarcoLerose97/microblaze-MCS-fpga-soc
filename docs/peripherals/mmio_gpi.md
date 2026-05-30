# MMIO GPI Peripheral

General Purpose Input peripheral connected to the MMIO subsystem.

---

## Function

The peripheral provides a memory-mapped input interface
that can be read by the MicroBlaze CPU.

---

## MMIO Slot

- slot_3_gpi

---

## RTL Module

- `chu_gpi.vhd`

---

## Software Driver

- `chu_gpi.c`
- `chu_gpi.h`

---

## Base Address

```text
GPI_BASE_ADDR = 0xC0000180
```

---

## Register Map

```text
         31                             16 15             0
         +--------------------------------+----------------+
offset 0 |            reserved            | SW[15:0]       |
         +--------------------------------+----------------+
```

---

## Register Summary

| Offset | Register | Bits | Description |
|--------|-----------|------|-------------|
| 0x00 | SWITCH_INPUT | [15:0] | current switch input value |
| 0x00 | SWITCH_INPUT | [31:16] | reserved |

---

## Notes

The register returns the current GPIO input state.
