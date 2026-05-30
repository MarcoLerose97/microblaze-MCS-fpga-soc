# MMIO Subsystem Slots Architecture

The MMIO subsystem is organized in slots.

The architecture supports up to 64 peripheral slots.

Each slot can expose up to 32 memory-mapped registers,
each 32 bits wide.

Current implemented slots:
- slot_0_sys_timer
- slot_1_uart
- slot_2_gpo
- slot_3_gpi
