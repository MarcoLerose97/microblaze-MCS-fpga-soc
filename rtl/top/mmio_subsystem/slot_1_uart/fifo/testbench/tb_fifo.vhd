library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fifo is
end tb_fifo;

architecture sim of tb_fifo is

    constant ADDR_WIDTH : integer := 2;
    constant DATA_WIDTH : integer := 8;
    constant CLK_PERIOD : time := 10 ns;

    signal clk    : std_logic := '0';
    signal reset  : std_logic := '0';
    signal rd     : std_logic := '0';
    signal wr     : std_logic := '0';
    signal w_data : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal empty  : std_logic;
    signal full   : std_logic;
    signal r_data : std_logic_vector(DATA_WIDTH-1 downto 0);

begin

    uut : entity work.fifo
        generic map(
            ADDR_WIDTH => ADDR_WIDTH,
            DATA_WIDTH => DATA_WIDTH
        )
        port map(
            clk    => clk,
            reset  => reset,
            rd     => rd,
            wr     => wr,
            w_data => w_data,
            empty  => empty,
            full   => full,
            r_data => r_data
        );


    ------------------------------------------------
    -- CLOCK
    ------------------------------------------------
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;

            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;


    ------------------------------------------------
    -- STIMULUS
    ------------------------------------------------
    stimulus : process
    begin

        ------------------------------------------------
        -- RESET
        ------------------------------------------------
        reset <= '1';

        wait until rising_edge(clk);
        wait until rising_edge(clk);

        reset <= '0';

        wait until rising_edge(clk);
        wait for 1 ns;

        assert empty = '1' and full = '0'
            report "ERROR: RESET"
            severity failure;

        report "RESET TEST PASSED" severity note;


        ------------------------------------------------
        -- WRITE 0x12
        ------------------------------------------------
        wr     <= '1';
        w_data <= x"12";

        wait until rising_edge(clk);

        wr <= '0';
        wait for 1 ns;

        assert empty = '0'
            report "ERROR: FIFO still EMPTY"
            severity failure;

        report "WRITE TEST PASSED" severity note;


        ------------------------------------------------
        -- WRITE 0xAB
        ------------------------------------------------
        wait until rising_edge(clk);
        wr     <= '1';
        w_data <= x"AB";

        wait until rising_edge(clk);
        wr <= '0';


        ------------------------------------------------
        -- WRITE 0x55
        ------------------------------------------------
        wait until rising_edge(clk);
        wr     <= '1';
        w_data <= x"55";

        wait until rising_edge(clk);
        wr <= '0';


        ------------------------------------------------
        -- WRITE 0xFF
        ------------------------------------------------
        wait until rising_edge(clk);
        wr     <= '1';
        w_data <= x"FF";

        wait until rising_edge(clk);
        wr <= '0';

        wait for 1 ns;

        assert full = '1'
            report "ERROR: FIFO not FULL"
            severity failure;

        report "FULL TEST PASSED" severity note;


        ------------------------------------------------
        -- READ 0x12
        ------------------------------------------------
        assert r_data = x"12"
            report "ERROR: Expected 0x12"
            severity failure;

        wait until rising_edge(clk);
        rd <= '1';

        wait until rising_edge(clk);
        rd <= '0';

        wait for 1 ns;


        ------------------------------------------------
        -- READ 0xAB
        ------------------------------------------------
        assert r_data = x"AB"
            report "ERROR: Expected 0xAB"
            severity failure;

        wait until rising_edge(clk);
        rd <= '1';

        wait until rising_edge(clk);
        rd <= '0';

        wait for 1 ns;


        ------------------------------------------------
        -- READ 0x55
        ------------------------------------------------
        assert r_data = x"55"
            report "ERROR: Expected 0x55"
            severity failure;

        wait until rising_edge(clk);
        rd <= '1';

        wait until rising_edge(clk);
        rd <= '0';

        wait for 1 ns;


        ------------------------------------------------
        -- READ 0xFF
        ------------------------------------------------
        assert r_data = x"FF"
            report "ERROR: Expected 0xFF"
            severity failure;

        wait until rising_edge(clk);
        rd <= '1';

        wait until rising_edge(clk);
        rd <= '0';

        wait for 1 ns;

        assert empty = '1'
            report "ERROR: FIFO not EMPTY"
            severity failure;

        report "FIFO ORDER TEST PASSED" severity note;


        ------------------------------------------------
        -- END
        ------------------------------------------------
        report "ALL FIFO TESTS PASSED"
            severity note;

        wait;

    end process;

end sim;
