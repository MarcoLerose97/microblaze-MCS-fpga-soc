# Slot Architecture

The MMIO subsystem is organized in slots.

The architecture supports up to 64 peripheral slots.
Each slot can expose up to 32 memory-mapped registers, each 32 bits wide.

The SoC architecture is divided into two main subsystems:

- MMIO subsystem
- VideoCore subsystem

The MMIO subsystem manages standard peripherals and register-based communication.

The VideoCore subsystem is dedicated to graphics and video-related processing.
