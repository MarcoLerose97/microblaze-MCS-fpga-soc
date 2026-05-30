# RTL Structure

```text
rtl/
├── top/
│   └── top_soc.vhd
│
└── mmio/
    ├── chu_io_map.vhd
    ├── chu_mmio_controller.vhd
    │
    ├── slot_0_sys_timer/
    │   └── chu_timer.vhd
    │
    ├── slot_1_uart/
    │   ├── uart_core.vhd
    │   ├── uart_tx.vhd
    │   ├── uart_rx.vhd
    │   ├── baud_gen.vhd
    │   └── fifo.vhd
    │
    ├── slot_2_gpo/
    │   └── chu_gpo.vhd
    │
    └── slot_3_gpi/
        └── chu_gpi.vhd
```

## Description

- `top/` → top-level SoC integration
- `mmio/` → memory-mapped peripheral subsystem
- `slot_0_sys_timer/` → timer peripheral
- `slot_1_uart/` → UART communication peripheral
- `slot_2_gpo/` → general-purpose output peripheral
- `slot_3_gpi/` → general-purpose input peripheral
