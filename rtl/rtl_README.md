# RTL Structure

```text
rtl/
├── top/
│   └── mcs_top_vanilla.vhd
│           │
│           ├── CPU (MicroBlaze MCS)
│           │
│           │
│           ├── bridge/
│           │   └── chu_mcs_bridge.vhd
│           │
│           └── mmio_sys_vanilla/
|               │
│               ├── (chu_io_map.vhd)
│               │  
│               ├── chu_mmio_controller.vhd
|               |
│               ├── slot_0_sys_timer/
│               │   └── chu_timer.vhd
|               │
│               ├── slot_1_uart/
│               │   └── chu_uart.vhd
│               │          └── uart_core.vhd
│               │                 ├── uart_tx.vhd
│               │                 ├── uart_rx.vhd
│               │                 ├── baud_gen.vhd
│               │                 ├── fifo_core.vhd
│               │                        ├── fifo_ctrl.vhd
│               │                        └── reg_file.vhd
│               ├── slot_2_gpo/
│               │   └── chu_gpo.vhd
│               │
│               └── slot_3_gpi/
│               │     └── chu_gpi.vhd
│               │
│               │  
│               │  
│               │  
│               │ ── slot_5_pwm/
│               │       └── chu_pwm.vhd
│               │ 

```

## Description

- `top/` → top-level SoC integration
- `mmio/` → memory-mapped peripheral subsystem
- `slot_0_sys_timer/` → timer peripheral
- `slot_1_uart/` → UART communication peripheral
- `slot_2_gpo/` → general-purpose output peripheral
- `slot_3_gpi/` → general-purpose input peripheral

- - `slot_5_pwm/` → pwm peripheral
