# SoC Overview

The system is based on a MicroBlaze soft-core processor connected
to memory-mapped peripherals through a custom MMIO controller.

The MMIO subsystem is designed to be modular and scalable up to 64 peripherals.

Main components:
- MicroBlaze CPU
- MMIO controller
- UART peripheral
- GPIO input peripheral
- GPIO output peripheral
- Timer peripheral
