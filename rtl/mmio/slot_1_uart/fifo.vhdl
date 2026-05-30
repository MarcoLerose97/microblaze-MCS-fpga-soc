library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo is
    generic(
        DATA_WIDTH : integer := 8;
        ADDR_WIDTH : integer := 4
    );
    port(
        clk    : in  std_logic;
        reset  : in  std_logic;

        rd     : in  std_logic;
        wr     : in  std_logic;

        w_data : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        empty  : out std_logic;
        full   : out std_logic;
        r_data : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end fifo;

architecture Behavioral of fifo is

    type reg_file_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);

    signal array_reg : reg_file_type;

    signal w_ptr_reg, w_ptr_next : unsigned(ADDR_WIDTH-1 downto 0);
    signal r_ptr_reg, r_ptr_next : unsigned(ADDR_WIDTH-1 downto 0);

    signal full_reg, full_next   : std_logic;
    signal empty_reg, empty_next : std_logic;

    signal wr_op : std_logic_vector(1 downto 0);

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if wr = '1' and full_reg = '0' then
                array_reg(to_integer(w_ptr_reg)) <= w_data;
            end if;
        end if;
    end process;

    r_data <= array_reg(to_integer(r_ptr_reg));

    process(clk, reset)
    begin
        if reset = '1' then
            w_ptr_reg <= (others => '0');
            r_ptr_reg <= (others => '0');
            full_reg  <= '0';
            empty_reg <= '1';

        elsif rising_edge(clk) then
            w_ptr_reg <= w_ptr_next;
            r_ptr_reg <= r_ptr_next;
            full_reg  <= full_next;
            empty_reg <= empty_next;
        end if;
    end process;

    wr_op <= wr & rd;

    process(w_ptr_reg, r_ptr_reg, full_reg, empty_reg, wr_op)
    begin
        w_ptr_next <= w_ptr_reg;
        r_ptr_next <= r_ptr_reg;
        full_next  <= full_reg;
        empty_next <= empty_reg;

        case wr_op is

            when "00" =>
                null;

            when "01" =>
                if empty_reg = '0' then
                    r_ptr_next <= r_ptr_reg + 1;
                    full_next  <= '0';

                    if r_ptr_reg + 1 = w_ptr_reg then
                        empty_next <= '1';
                    end if;
                end if;

            when "10" =>
                if full_reg = '0' then
                    w_ptr_next <= w_ptr_reg + 1;
                    empty_next <= '0';

                    if w_ptr_reg + 1 = r_ptr_reg then
                        full_next <= '1';
                    end if;
                end if;

            when "11" =>
                w_ptr_next <= w_ptr_reg + 1;
                r_ptr_next <= r_ptr_reg + 1;

            when others =>
                null;

        end case;
    end process;

    full  <= full_reg;
    empty <= empty_reg;

end Behavioral;
