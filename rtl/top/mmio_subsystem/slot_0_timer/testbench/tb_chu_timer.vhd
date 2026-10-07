library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_chu_timer is
end tb_chu_timer;


architecture sim of tb_chu_timer is

    constant CLK_PERIOD : time := 10 ns;

    signal clk     : std_logic := '0';
    signal reset   : std_logic := '0';

    signal cs      : std_logic := '0';
    signal write   : std_logic := '0';
    signal read    : std_logic := '0';

    signal addr    : std_logic_vector(4 downto 0) := (others => '0');
    signal rd_data : std_logic_vector(31 downto 0);
    signal wr_data : std_logic_vector(31 downto 0) := (others => '0');

begin


    ------------------------------------------------------------
    -- DUT
    ------------------------------------------------------------

    uut : entity work.chu_timer
        port map(
            clk     => clk,
            reset   => reset,
            cs      => cs,
            write   => write,
            read    => read,
            addr    => addr,
            rd_data => rd_data,
            wr_data => wr_data
        );


    ------------------------------------------------------------
    -- CLOCK
    ------------------------------------------------------------

    clk_process : process
    begin

        while true loop

            clk <= '0';
            wait for CLK_PERIOD / 2;

            clk <= '1';
            wait for CLK_PERIOD / 2;

        end loop;

    end process;


    ------------------------------------------------------------
    -- STIMULUS
    ------------------------------------------------------------

    stimulus : process
    begin


        --------------------------------------------------------
        -- TEST 1 : RESET
        --------------------------------------------------------

        reset <= '1';

        wait for 20 ns;

        reset <= '0';

        wait for 10 ns;


        addr <= "00000";       -- TIMER_LOW

        wait for 1 ns;


        assert rd_data = x"00000000"
            report "ERROR: Counter not zero after RESET"
            severity failure;


        report "RESET TEST PASSED"
            severity note;



        --------------------------------------------------------
        -- TEST 2 : START TIMER
        --------------------------------------------------------
        --
        -- CONTROL = 0x01
        --
        -- bit 0 = GO    = 1
        -- bit 1 = CLEAR = 0
        --------------------------------------------------------

        wait until rising_edge(clk);

        addr    <= "00010";       -- CONTROL
        wr_data <= x"00000001";

        cs      <= '1';
        write   <= '1';


        --------------------------------------------------------
        -- ctrl_reg acquisisce GO = 1
        --------------------------------------------------------

        wait until rising_edge(clk);

        cs    <= '0';
        write <= '0';


        --------------------------------------------------------
        -- Primo incremento
        --
        -- counter: 0 -> 1
        --------------------------------------------------------

        wait until rising_edge(clk);



        --------------------------------------------------------
        -- TEST 3 : STOP TIMER
        --------------------------------------------------------
        --
        -- Inizio lo STOP quando il counter vale 1.
        --
        -- CONTROL = 0x00
        --------------------------------------------------------

        addr    <= "00010";
        wr_data <= x"00000000";

        cs      <= '1';
        write   <= '1';


        --------------------------------------------------------
        -- Rising successivo:
        --
        -- counter: 1 -> 2
        -- ctrl_reg acquisisce GO = 0
        --------------------------------------------------------

        wait until rising_edge(clk);

        cs    <= '0';
        write <= '0';


        --------------------------------------------------------
        -- GO = 0
        -- counter rimane a 2
        --------------------------------------------------------

        wait until rising_edge(clk);

        wait for 1 ns;


        --------------------------------------------------------
        -- TIMER_LOW
        --------------------------------------------------------

        addr <= "00000";

        wait for 1 ns;


        assert unsigned(rd_data) = 2
            report "ERROR: Counter did not stop at 2"
            severity failure;


        report "START/STOP TEST PASSED"
            severity note;



        --------------------------------------------------------
        -- TEST 4 : HOLD
        --------------------------------------------------------
        --
        -- Aspetto un clock.
        -- Il counter deve rimanere a 2.
        --------------------------------------------------------

        wait until rising_edge(clk);

        wait for 1 ns;


        assert unsigned(rd_data) = 2
            report "ERROR: Counter changed while stopped"
            severity failure;


        report "HOLD TEST PASSED"
            severity note;



        --------------------------------------------------------
        -- TEST 5 : CLEAR + GO
        --------------------------------------------------------
        --
        -- CONTROL = 0x03
        --
        -- bit 1 = CLEAR = 1
        -- bit 0 = GO    = 1
        --
        -- CLEAR ha priorita' su GO.
        --------------------------------------------------------

        wait until rising_edge(clk);

        addr    <= "00010";
        wr_data <= x"00000003";

        cs      <= '1';
        write   <= '1';


        --------------------------------------------------------
        -- Rising successivo:
        --
        -- CLEAR = 1
        -- GO    = 1
        --
        -- counter: 2 -> 0
        --------------------------------------------------------

        wait until rising_edge(clk);

        cs    <= '0';
        write <= '0';


        wait for 1 ns;


        --------------------------------------------------------
        -- TIMER_LOW
        --------------------------------------------------------

        addr <= "00000";

        wait for 1 ns;


        assert rd_data = x"00000000"
            report "ERROR: CLEAR failed"
            severity failure;


        report "CLEAR TEST PASSED"
            severity note;



        --------------------------------------------------------
        -- TEST 6 : AUTOMATIC RESTART
        --------------------------------------------------------
        --
        -- CLEAR torna a 0.
        -- GO rimane a 1.
        --
        -- Il timer riparte automaticamente.
        --------------------------------------------------------

        wait until rising_edge(clk);

        -- counter: 0 -> 1

        wait until rising_edge(clk);

        -- counter: 1 -> 2

        wait for 1 ns;


        assert unsigned(rd_data) = 2
            report "ERROR: Timer did not restart after CLEAR"
            severity failure;


        report "RESTART TEST PASSED"
            severity note;



        --------------------------------------------------------
        -- TEST 7 : TIMER_HIGH
        --------------------------------------------------------
        --
        -- Prima lascio TIMER_LOW visibile per 10 ns.
        --------------------------------------------------------

        addr <= "00000";

        wait for 10 ns;


        --------------------------------------------------------
        -- Selezione TIMER_HIGH
        --
        -- addr = 00001
        --
        -- count_reg(47 downto 32)
        --
        --------------------------------------------------------

        addr <= "00001";

        wait for 20 ns;


        assert rd_data = x"00000000"
            report "ERROR: TIMER_HIGH is not zero"
            severity failure;


        report "TIMER_HIGH TEST PASSED"
            severity note;



        --------------------------------------------------------
        -- RITORNO A TIMER_LOW
        --------------------------------------------------------

        addr <= "00000";

        wait for 10 ns;



        --------------------------------------------------------
        -- FINE TEST
        --------------------------------------------------------

        report "ALL TIMER TESTS PASSED"
            severity note;


        wait;


    end process;


end sim;
