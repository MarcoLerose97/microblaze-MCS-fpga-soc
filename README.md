# MicroBlaze FPGA SoC

Custom FPGA SoC platform based on a MicroBlaze soft-core processor.

## Features
- Custom UART peripheral
- GPIO controller
- Timer peripheral
- Memory mapped I/O
- FIFO modules
- Embedded software drivers
- Vivado FPGA project structure

## Repository structure
- `/rtl` → VHDL RTL sources
- `/sw` → embedded software sources
- `/constraints` → FPGA pin constraints
- `/docs` → project documentation

## Target FPGA
- Digilent Basys3
- Xilinx Vivado

## Status
Work in progress.  
Additional peripherals and video subsystem support planned.


## Documentation
- [SoC overview](docs/architecture/soc_overview.md)
- [MMIO memory map](docs/architecture/mmio_subsystem_memory_map.md)
- [MMIO slot architecture](docs/architecture/mmio_subsystem_slots_architecture.md)
- [UART peripheral](docs/peripherals/mmio_uart.md)
- [Timer peripheral](docs/peripherals/mmio_timer.md)
- [GPO peripheral](docs/peripherals/mmio_gpo.md)
- [GPI peripheral](docs/peripherals/mmio_gpi.md)
