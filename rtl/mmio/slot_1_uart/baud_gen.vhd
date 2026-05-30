library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity baud_gen is
    generic(
        DVSR     : integer := 54;
        DVSR_BIT : integer := 6
    );
    port(
        clk   : in  std_logic;
        reset : in  std_logic;
        tick  : out std_logic
    );
end baud_gen;

architecture Behavioral of baud_gen is

    signal r_reg  : unsigned(DVSR_BIT-1 downto 0);
    signal r_next : unsigned(DVSR_BIT-1 downto 0);

begin

    process(clk, reset)
    begin
        if reset = '1' then
            r_reg <= (others => '0');
        elsif rising_edge(clk) then
            r_reg <= r_next;
        end if;
    end process;

    process(r_reg)
    begin
        tick <= '0';

        if r_reg = to_unsigned(DVSR, DVSR_BIT) then
            r_next <= (others => '0');
            tick   <= '1';
        else
            r_next <= r_reg + 1;
        end if;
    end process;

end Behavioral;
