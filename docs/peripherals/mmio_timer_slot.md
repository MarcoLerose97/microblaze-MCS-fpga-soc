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

| Offset | Register | Description |
|--------|-----------|-------------|
| 0x00 | TIMER_LOW | lower 32 bits of timer counter |
| 0x04 | TIMER_HIGH | upper 16 bits of timer counter |
| 0x08 | CONTROL | timer control register |

---

## Control Register Bit Fields

| Bit | Name | Description |
|-----|------|-------------|
| 0 | TIMER_EN | timer enable |
| 1 | TIMER_CLR | clear timer counter |
| 31:2 | reserved | reserved |

---

## Notes

The timer peripheral is synchronous with the main system clock.

The timer counter is implemented as a 48-bit counter split across:
- 32-bit low register
- 16-bit high register
