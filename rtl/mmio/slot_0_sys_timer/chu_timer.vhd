library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity chu_timer is
    port(
        clk      : in  std_logic;
        reset    : in  std_logic;

        wr_en    : in  std_logic;
        wr_addr  : in  std_logic_vector(4 downto 0);
        wr_data  : in  std_logic_vector(31 downto 0);

        rd_addr  : in  std_logic_vector(4 downto 0);
        rd_data  : out std_logic_vector(31 downto 0)
    );
end chu_timer;

architecture Behavioral of chu_timer is

    signal counter_reg : unsigned(63 downto 0) := (others => '0');
    signal go_reg      : std_logic := '0';

begin

    process(clk, reset)
    begin
        if reset = '1' then
            counter_reg <= (others => '0');
            go_reg      <= '0';

        elsif rising_edge(clk) then

            if go_reg = '1' then
                counter_reg <= counter_reg + 1;
            end if;

            if wr_en = '1' then
                case wr_addr is

                    -- offset 2: control register
                    -- bit 0 = go
                    -- bit 1 = clear
                    when "00010" =>
                        go_reg <= wr_data(0);

                        if wr_data(1) = '1' then
                            counter_reg <= (others => '0');
                        end if;

                    when others =>
                        null;

                end case;
            end if;

        end if;
    end process;

    process(rd_addr, counter_reg, go_reg)
    begin
        rd_data <= (others => '0');

        case rd_addr is

            -- offset 0: counter low
            when "00000" =>
                rd_data <= std_logic_vector(counter_reg(31 downto 0));

            -- offset 1: counter high
            when "00001" =>
                rd_data <= std_logic_vector(counter_reg(63 downto 32));

            -- offset 2: control/status
            when "00010" =>
                rd_data(0) <= go_reg;

            when others =>
                rd_data <= (others => '0');

        end case;
    end process;

end Behavioral;
