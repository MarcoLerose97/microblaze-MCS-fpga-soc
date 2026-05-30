# MMIO Timer Peripheral

System timer peripheral connected to the MMIO subsystem.

---

## Function

The timer provides a memory-mapped counter accessible by the
MicroBlaze CPU through the MMIO subsystem.

The peripheral can be used for:
- timing measurements
- delays
- software timing reference
- periodic polling operations

---

## MMIO Slot

- slot_0_sys_timer

---

## RTL Module

- `chu_timer.vhd`

---

## Software Driver

- `chu_timer.c`
- `chu_timer.h`

---

## Base Address

```text
TIMER_BASE_ADDR = 0xC0000000
```

---

## Register Map

```text
         31                             0
         +--------------------------------+
offset 0 |       TIMER_LOW[31:0]         |
         +--------------------------------+

         31             16 15           0
         +----------------+--------------+
offset 4 |    reserved    | TIMER_H[15:0]
         +----------------+--------------+

         31                             0
         +--------------------------------+
offset 8 |            CONTROL             |
         +--------------------------------+
```

---

## Register Summary

| Offset | Register | Bits | Description |
|--------|-----------|------|-------------|
| 0x00 | TIMER_LOW | [31:0] | lower 32 bits of timer counter |
| 0x04 | TIMER_HIGH | [15:0] | upper 16 bits of timer counter |
| 0x08 | CONTROL | [0] | timer enable |
| 0x08 | CONTROL | [1] | timer clear |
| 0x08 | CONTROL | [31:2] | reserved |
---



---

## Notes

The timer peripheral is synchronous with the main system clock.

The timer counter is implemented as a 48-bit counter split across:
- 32-bit low register
- 16-bit high register
