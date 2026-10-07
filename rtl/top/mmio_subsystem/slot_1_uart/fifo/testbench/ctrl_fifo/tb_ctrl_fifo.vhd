library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fifo_ctrl is
end tb_fifo_ctrl;

architecture sim of tb_fifo_ctrl is

    constant ADDR_WIDTH : natural := 2;
    constant CLK_PERIOD : time := 10 ns;

    signal clk    : std_logic := '0';
    signal reset  : std_logic := '0';
    signal rd     : std_logic := '0';
    signal wr     : std_logic := '0';
    signal empty  : std_logic;
    signal full   : std_logic;
    signal w_addr : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal r_addr : std_logic_vector(ADDR_WIDTH-1 downto 0);

begin

    uut : entity work.fifo_ctrl
        generic map(
            ADDR_WIDTH => ADDR_WIDTH
        )
        port map(
            clk    => clk,
            reset  => reset,
            rd     => rd,
            wr     => wr,
            empty  => empty,
            full   => full,
            w_addr => w_addr,
            r_addr => r_addr
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

        assert empty = '1' and
               full = '0' and
               w_addr = "00" and
               r_addr = "00"
            report "ERROR: RESET"
            severity failure;

        report "RESET TEST PASSED" severity note;


        ------------------------------------------------
        -- WRITE 1 ELEMENT
        ------------------------------------------------
        wr <= '1';

        wait until rising_edge(clk);
        wr <= '0';

        wait for 1 ns;

        assert w_addr = "01" and empty = '0'
            report "ERROR: WRITE"
            severity failure;

        report "WRITE TEST PASSED" severity note;


        ------------------------------------------------
        -- READ 1 ELEMENT
        ------------------------------------------------
        wait until rising_edge(clk);
        rd <= '1';

        wait until rising_edge(clk);
        rd <= '0';

        wait for 1 ns;

        assert r_addr = "01" and empty = '1'
            report "ERROR: READ"
            severity failure;

        report "READ TEST PASSED" severity note;


        ------------------------------------------------
        -- READ WHILE EMPTY
        ------------------------------------------------
        wait until rising_edge(clk);
        rd <= '1';

        wait until rising_edge(clk);
        rd <= '0';

        wait for 1 ns;

        assert r_addr = "01" and empty = '1'
            report "ERROR: READ WHILE EMPTY"
            severity failure;

        report "EMPTY PROTECTION TEST PASSED" severity note;


        ------------------------------------------------
        -- FILL FIFO: 4 WRITES
        ------------------------------------------------
        wait until rising_edge(clk);
        wr <= '1';

        wait until rising_edge(clk);   -- write 1
        wait until rising_edge(clk);   -- write 2
        wait until rising_edge(clk);   -- write 3
        wait until rising_edge(clk);   -- write 4

        wr <= '0';

        wait for 1 ns;

        assert full = '1'
            report "ERROR: FIFO NOT FULL"
            severity failure;

        assert w_addr = "01"
            report "ERROR: WRITE POINTER AFTER FILL"
            severity failure;

        report "FULL TEST PASSED" severity note;


        ------------------------------------------------
        -- WRITE WHILE FULL
        ------------------------------------------------
        wait until rising_edge(clk);
        wr <= '1';

        wait until rising_edge(clk);
        wr <= '0';

        wait for 1 ns;

        assert full = '1' and w_addr = "01"
            report "ERROR: WRITE WHILE FULL"
            severity failure;

        report "FULL PROTECTION TEST PASSED" severity note;


        ------------------------------------------------
        -- READ FROM FULL FIFO
        ------------------------------------------------
        wait until rising_edge(clk);
        rd <= '1';

        wait until rising_edge(clk);
        rd <= '0';

        wait for 1 ns;

        assert full = '0' and r_addr = "10"
            report "ERROR: READ FROM FULL FIFO"
            severity failure;

        report "READ FROM FULL TEST PASSED" severity note;


        ------------------------------------------------
        -- SIMULTANEOUS READ + WRITE
        ------------------------------------------------
        wait until rising_edge(clk);
        rd <= '1';
        wr <= '1';

        wait until rising_edge(clk);
        rd <= '0';
        wr <= '0';

        wait for 1 ns;

        assert w_addr = "10" and r_addr = "11"
            report "ERROR: SIMULTANEOUS READ/WRITE"
            severity failure;

        report "READ/WRITE TEST PASSED" severity note;


        ------------------------------------------------
        -- END
        ------------------------------------------------
        report "ALL FIFO_CTRL TESTS PASSED"
            severity note;

        wait;

    end process;

end sim;
