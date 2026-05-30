library ieee;
use ieee.std_logic_1164.all;

package chu_io_map is

    constant BRIDGE_BASE : std_logic_vector(31 downto 0)
        := x"C0000000";

    constant S0_SYS_TIMER : integer := 0;
    constant S1_UART1     : integer := 1;
    constant S2_LED       : integer := 2;
    constant S3_SW        : integer := 3;

end package;
