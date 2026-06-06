# MMIO PWM Peripheral

PWM peripheral connected to the MMIO subsystem.

---

## Function

The PWM peripheral generates multiple pulse-width modulated output signals.

The peripheral supports:

* 16 PWM output channels
* Global PWM frequency configuration
* Independent duty-cycle configuration for each channel
* 8-bit PWM resolution
* PMOD output mapping

---

## MMIO Slot

* slot_5_pwm

---

## RTL Module

* `chu_pwm.vhd`

---

## Software Driver

* `chu_pwm.c`
* `chu_pwm.h`

---

## Base Address

```text
PWM_BASE_ADDR = 0xC0000280
```

---

## Register Map

```text
offset 0 : PWM divisor register (write)

         31                              0
         +--------------------------------+
         |          DVSR[31:0]            |
         +--------------------------------+


offset 16 : PWM channel 0 duty register (write)

         31                            9 8              0
         +------------------------------+----------------+
         |           reserved           | DUTY[8:0]      |
         +------------------------------+----------------+


offset 17 : PWM channel 1 duty register (write)

         31                            9 8              0
         +------------------------------+----------------+
         |           reserved           | DUTY[8:0]      |
         +------------------------------+----------------+


...

offset 31 : PWM channel 15 duty register (write)

         31                            9 8              0
         +------------------------------+----------------+
         |           reserved           | DUTY[8:0]      |
         +------------------------------+----------------+
```

---

## Register Summary

| Offset | Register      | Bits   | Description                   |
| ------ | ------------- | ------ | ----------------------------- |
| 0x00   | PWM_DVSR      | [31:0] | PWM prescaler divisor         |
| 0x40   | PWM_DUTY_CH0  | [8:0]  | duty value for PWM channel 0  |
| 0x40   | PWM_DUTY_CH0  | [31:9] | reserved                      |
| 0x44   | PWM_DUTY_CH1  | [8:0]  | duty value for PWM channel 1  |
| 0x44   | PWM_DUTY_CH1  | [31:9] | reserved                      |
| 0x48   | PWM_DUTY_CH2  | [8:0]  | duty value for PWM channel 2  |
| 0x48   | PWM_DUTY_CH2  | [31:9] | reserved                      |
| ...    | ...           | ...    | ...                           |
| 0x7C   | PWM_DUTY_CH15 | [8:0]  | duty value for PWM channel 15 |
| 0x7C   | PWM_DUTY_CH15 | [31:9] | reserved                      |

---

## Frequency Formula

The PWM frequency is defined by:

```text
f_pwm = f_clk / ((DVSR + 1) * 2^R)
```

where:

```text
f_clk = 100 MHz
R = 8
```

Examples:

```text
DVSR = 6  -> f_pwm ≈ 55.8 kHz
DVSR = 7  -> f_pwm ≈ 48.8 kHz
DVSR = 38 -> f_pwm ≈ 10.0 kHz
DVSR = 77 -> f_pwm ≈ 5.0 kHz
```

---

## Duty Cycle

The PWM core uses an 8-bit resolution counter:

```text
2^8 = 256 levels
```

Common duty-cycle values:

| Duty Cycle | Register Value |
| ---------- | -------------- |
| 2%         | 5              |
| 20%        | 51             |
| 40%        | 102            |
| 50%        | 128            |
| 60%        | 154            |
| 70%        | 179            |
| 75%        | 192            |
| 90%        | 230            |
| 100%       | 256            |

---

## PMOD Mapping

The PWM outputs are routed to two PMOD connectors:

```text
JA[0] -> pwm_out[0]
JA[1] -> pwm_out[1]
JA[2] -> pwm_out[2]
JA[3] -> pwm_out[3]
JA[4] -> pwm_out[4]
JA[5] -> pwm_out[5]
JA[6] -> pwm_out[6]
JA[7] -> pwm_out[7]

JB[0] -> pwm_out[8]
JB[1] -> pwm_out[9]
JB[2] -> pwm_out[10]
JB[3] -> pwm_out[11]
JB[4] -> pwm_out[12]
JB[5] -> pwm_out[13]
JB[6] -> pwm_out[14]
JB[7] -> pwm_out[15]
```

---

## Notes

The PWM frequency is shared by all channels through the global divisor register.

Each PWM channel has an independent duty-cycle register.

The duty registers are mapped starting at offset 16, therefore channel 0 is accessed at:

```text
PWM_BASE_ADDR + 0x40
```

The peripheral is implemented as MMIO slot 5 and integrated into the MMIO subsystem through the standard slot interface.
