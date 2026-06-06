## Clock 100 MHz
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]

## Reset button C
set_property PACKAGE_PIN U18 [get_ports reset_n]
set_property IOSTANDARD LVCMOS33 [get_ports reset_n]

## Switches
set_property PACKAGE_PIN V17 [get_ports {sw[0]}]
set_property PACKAGE_PIN V16 [get_ports {sw[1]}]
set_property PACKAGE_PIN W16 [get_ports {sw[2]}]
set_property PACKAGE_PIN W17 [get_ports {sw[3]}]
set_property PACKAGE_PIN W15 [get_ports {sw[4]}]
set_property PACKAGE_PIN V15 [get_ports {sw[5]}]
set_property PACKAGE_PIN W14 [get_ports {sw[6]}]
set_property PACKAGE_PIN W13 [get_ports {sw[7]}]
set_property PACKAGE_PIN V2  [get_ports {sw[8]}]
set_property PACKAGE_PIN T3  [get_ports {sw[9]}]
set_property PACKAGE_PIN T2  [get_ports {sw[10]}]
set_property PACKAGE_PIN R3  [get_ports {sw[11]}]
set_property PACKAGE_PIN W2  [get_ports {sw[12]}]
set_property PACKAGE_PIN U1  [get_ports {sw[13]}]
set_property PACKAGE_PIN T1  [get_ports {sw[14]}]
set_property PACKAGE_PIN R2  [get_ports {sw[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports sw]

## LEDs
set_property PACKAGE_PIN U16 [get_ports {led[0]}]
set_property PACKAGE_PIN E19 [get_ports {led[1]}]
set_property PACKAGE_PIN U19 [get_ports {led[2]}]
set_property PACKAGE_PIN V19 [get_ports {led[3]}]
set_property PACKAGE_PIN W18 [get_ports {led[4]}]
set_property PACKAGE_PIN U15 [get_ports {led[5]}]
set_property PACKAGE_PIN U14 [get_ports {led[6]}]
set_property PACKAGE_PIN V14 [get_ports {led[7]}]
set_property PACKAGE_PIN V13 [get_ports {led[8]}]
set_property PACKAGE_PIN V3  [get_ports {led[9]}]
set_property PACKAGE_PIN W3  [get_ports {led[10]}]
set_property PACKAGE_PIN U3  [get_ports {led[11]}]
set_property PACKAGE_PIN P3  [get_ports {led[12]}]
set_property PACKAGE_PIN N3  [get_ports {led[13]}]
set_property PACKAGE_PIN P1  [get_ports {led[14]}]
set_property PACKAGE_PIN L1  [get_ports {led[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports led]

## UART USB
set_property PACKAGE_PIN B18 [get_ports rx]
set_property PACKAGE_PIN A18 [get_ports tx]
set_property IOSTANDARD LVCMOS33 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports tx]


## PWM outputs on PMOD JA
set_property PACKAGE_PIN J1 [get_ports {pwm_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pwm_out[0]}]

set_property PACKAGE_PIN L2 [get_ports {pwm_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pwm_out[1]}]

set_property PACKAGE_PIN J2 [get_ports {pwm_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pwm_out[2]}]

set_property PACKAGE_PIN G2 [get_ports {pwm_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pwm_out[3]}]

set_property PACKAGE_PIN H1 [get_ports {pwm_out[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pwm_out[4]}]

set_property PACKAGE_PIN K2 [get_ports {pwm_out[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pwm_out[5]}]

set_property PACKAGE_PIN H2 [get_ports {pwm_out[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pwm_out[6]}]

set_property PACKAGE_PIN G3 [get_ports {pwm_out[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pwm_out[7]}]


## PWM outputs on PMOD JB
set_property PACKAGE_PIN A14 [get_ports {pwm_out[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pwm_out[8]}]

set_property PACKAGE_PIN A16 [get_ports {pwm_out[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pwm_out[9]}]

set_property PACKAGE_PIN B15 [get_ports {pwm_out[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pwm_out[10]}]

set_property PACKAGE_PIN B16 [get_ports {pwm_out[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pwm_out[11]}]

set_property PACKAGE_PIN A15 [get_ports {pwm_out[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pwm_out[12]}]

set_property PACKAGE_PIN A17 [get_ports {pwm_out[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pwm_out[13]}]

set_property PACKAGE_PIN C15 [get_ports {pwm_out[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pwm_out[14]}]

set_property PACKAGE_PIN C16 [get_ports {pwm_out[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pwm_out[15]}]
