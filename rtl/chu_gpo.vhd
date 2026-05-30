library ieee;
use ieee.std_logic_1164.all;

entity chu_gpo is
    port(
        clk      : in  std_logic;
        reset    : in  std_logic;

        wr_en    : in  std_logic;
        wr_data  : in  std_logic_vector(31 downto 0);

        dout     : out std_logic_vector(31 downto 0)
    );
end chu_gpo;

architecture Behavioral of chu_gpo is

    signal reg_data : std_logic_vector(31 downto 0);

begin

    process(clk, reset)
    begin

        if reset = '1' then
            reg_data <= (others => '0');

        elsif rising_edge(clk) then

            if wr_en = '1' then
                reg_data <= wr_data;
            end if;

        end if;

    end process;

    dout <= reg_data;

end Behavioral;