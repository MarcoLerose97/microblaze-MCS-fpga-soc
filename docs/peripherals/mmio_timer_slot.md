# MMIO Timer Peripheral

System timer peripheral connected to the MMIO subsystem.

## Function

The timer provides a memory-mapped counter that can be accessed by the MicroBlaze CPU.

## MMIO Slot

- slot_0_sys_timer

## RTL Module

- chu_timer.vhd

## Software Driver

- chu_timer.c
- chu_timer.h

## Notes

The timer is part of the MMIO peripheral subsystem and can be used by embedded software for timing and basic time measurement.
