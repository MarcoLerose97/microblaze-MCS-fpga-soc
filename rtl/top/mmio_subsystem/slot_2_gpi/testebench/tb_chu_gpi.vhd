library ieee;
use ieee.std_logic_1164.all;

entity tb_chu_gpi is
end tb_chu_gpi;


architecture sim of tb_chu_gpi is

    constant W          : integer := 8;
    constant CLK_PERIOD : time := 10 ns;

    signal clk     : std_logic := '0';
    signal reset   : std_logic := '0';

    signal cs      : std_logic := '0';
    signal write   : std_logic := '0';
    signal read    : std_logic := '0';

    signal addr    : std_logic_vector(4 downto 0) := (others => '0');
    signal rd_data : std_logic_vector(31 downto 0);
    signal wr_data : std_logic_vector(31 downto 0) := (others => '0');

    signal din     : std_logic_vector(W-1 downto 0) := (others => '0');


begin


    ------------------------------------------------------------
    -- DUT
    ------------------------------------------------------------

    uut : entity work.chu_gpi
        generic map(
            W => W
        )
        port map(
            clk     => clk,
            reset   => reset,

            cs      => cs,
            write   => write,
            read    => read,
            addr    => addr,
            rd_data => rd_data,
            wr_data => wr_data,

            din     => din
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


        assert rd_data = x"00000000"
            report "ERROR: Reset failed"
            severity failure;



        --------------------------------------------------------
        -- TEST 2 : din = 0x12
        --------------------------------------------------------
        --
        -- Al rising N cambio din.
        -- Il GPI a quel rising vede ancora il vecchio din.
        --------------------------------------------------------

        wait until rising_edge(clk);

        din <= x"12";


        --------------------------------------------------------
        -- Rising N+1:
        -- il GPI acquisisce 0x12
        --------------------------------------------------------

        wait until rising_edge(clk);

        wait for 1 ns;


        assert rd_data = x"00000012"
            report "ERROR: Input 0x12 not acquired"
            severity failure;



        --------------------------------------------------------
        -- TEST 3 : din = 0xAB
        --------------------------------------------------------

        wait until rising_edge(clk);

        din <= x"AB";


        --------------------------------------------------------
        -- Rising successivo:
        -- il GPI acquisisce 0xAB
        --------------------------------------------------------

        wait until rising_edge(clk);

        wait for 1 ns;


        assert rd_data = x"000000AB"
            report "ERROR: Input 0xAB not acquired"
            severity failure;



        --------------------------------------------------------
        -- TEST 4 : din = 0xFF
        --------------------------------------------------------

        wait until rising_edge(clk);

        din <= x"FF";


        wait until rising_edge(clk);

        wait for 1 ns;


        assert rd_data = x"000000FF"
            report "ERROR: Input 0xFF not acquired"
            severity failure;



        --------------------------------------------------------
        -- TEST 5 : din = 0x00
        --------------------------------------------------------

        wait until rising_edge(clk);

        din <= x"00";


        wait until rising_edge(clk);

        wait for 1 ns;


        assert rd_data = x"00000000"
            report "ERROR: Input 0x00 not acquired"
            severity failure;



        --------------------------------------------------------
        -- FINE TEST
        --------------------------------------------------------

        report "ALL TESTS PASSED"
            severity note;


        wait;


    end process;


end sim;
