library ieee;
use ieee.std_logic_1164.all;

entity chu_gpo is
    generic(
        W : integer := 16
    );
    port(
        clk     : in  std_logic;
        reset   : in  std_logic;

        cs      : in  std_logic;
        write   : in  std_logic;
        read    : in  std_logic;
        addr    : in  std_logic_vector(4 downto 0);
        rd_data : out std_logic_vector(31 downto 0);
        wr_data : in  std_logic_vector(31 downto 0);

        dout    : out std_logic_vector(W-1 downto 0)
    );
end chu_gpo;

architecture arch of chu_gpo is
    signal buf_reg : std_logic_vector(W-1 downto 0);
    signal wr_en   : std_logic;
begin

    process(clk, reset)
    begin
        if reset = '1' then
            buf_reg <= (others => '0');
        elsif rising_edge(clk) then
            if wr_en = '1' then
                buf_reg <= wr_data(W-1 downto 0);
            end if;
        end if;
    end process;

    wr_en <= '1' when write = '1' and cs = '1' else '0';

    rd_data <= (others => '0');

    dout <= buf_reg;

end arch;
