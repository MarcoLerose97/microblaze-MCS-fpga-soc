library ieee;
use ieee.std_logic_1164.all;

entity tb_chu_gpo is
end tb_chu_gpo;


architecture sim of tb_chu_gpo is

    constant W          : integer := 16;
    constant CLK_PERIOD : time := 10 ns;

    signal clk     : std_logic := '0';
    signal reset   : std_logic := '0';

    signal cs      : std_logic := '0';
    signal write   : std_logic := '0';
    signal read    : std_logic := '0';

    signal addr    : std_logic_vector(31 downto 0) := (others => '0');
    signal rd_data : std_logic_vector(31 downto 0);
    signal wr_data : std_logic_vector(31 downto 0) := (others => '0');

    signal dout    : std_logic_vector(W-1 downto 0);

begin


    ------------------------------------------------------------
    -- DUT
    ------------------------------------------------------------

    uut : entity work.chu_gpo
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

            dout    => dout
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


        assert dout = x"0000"
            report "ERROR: Reset failed"
            severity failure;



        --------------------------------------------------------
        -- TEST 2 : SCRITTURA 0x1234
        --------------------------------------------------------
        --
        -- Rising N:
        -- il controller genera cs, write e wr_data.
        --------------------------------------------------------

        wait until rising_edge(clk);

        cs      <= '1';
        write   <= '1';
        wr_data <= x"00001234";


        --------------------------------------------------------
        -- Rising N+1:
        --
        -- Il DUT vede ancora:
        --
        -- cs      = 1
        -- write   = 1
        -- wr_data = 0x1234
        --
        -- quindi acquisisce il dato.
        --
        -- Contemporaneamente il TB termina l'impulso.
        --------------------------------------------------------

        wait until rising_edge(clk);

        cs    <= '0';
        write <= '0';


        -- Aspetto che gli aggiornamenti del DUT siano visibili prima dell'assert.

        wait for 1 ns;


        assert dout = x"1234"
            report "ERROR: Write 0x1234 failed"
            severity failure;



        --------------------------------------------------------
        -- TEST 3 : CAMBIO wr_data SENZA SCRITTURA
        --------------------------------------------------------
        --
        -- Cambio wr_data al rising edge.
        -- cs e write rimangono a 0.
        --
        -- Il DUT NON deve modificare dout.
        --------------------------------------------------------

        wait until rising_edge(clk);

        wr_data <= x"0000ABCD";


        -- Aspetto un altro rising per verificare
        -- che il registro non venga modificato.

        wait until rising_edge(clk);

        wait for 1 ns;


        assert dout = x"1234"
            report "ERROR: dout changed without write"
            severity failure;



        --------------------------------------------------------
        -- TEST 4 : SCRITTURA 0xABCD
        --------------------------------------------------------
        --
        -- wr_data contiene gia' ABCD.
        --
        -- Rising N:
        -- genero cs e write.
        --------------------------------------------------------

        wait until rising_edge(clk);

        cs    <= '1';
        write <= '1';


        --------------------------------------------------------
        -- Rising N+1:
        -- il DUT acquisisce ABCD.
        --
        -- Termino contemporaneamente l'impulso.
        --------------------------------------------------------

        wait until rising_edge(clk);

        cs    <= '0';
        write <= '0';


        wait for 1 ns;


        assert dout = x"ABCD"
            report "ERROR: Write 0xABCD failed"
            severity failure;



        --------------------------------------------------------
        -- TEST 5 : WRITE = 1 MA CS = 0
        --------------------------------------------------------
        --
        -- wr_en = cs AND write
        --
        -- Con cs=0 la scrittura NON deve avvenire.
        --------------------------------------------------------

        wait until rising_edge(clk);

        cs      <= '0';
        write   <= '1';
        wr_data <= x"00005678";


        --------------------------------------------------------
        -- Un ciclo dopo terminiamo write
        --------------------------------------------------------

        wait until rising_edge(clk);

        write <= '0';


        wait for 1 ns;


        assert dout = x"ABCD"
            report "ERROR: Write occurred with CS = 0"
            severity failure;



        --------------------------------------------------------
        -- TEST 6 : rd_data
        --------------------------------------------------------
        --
        -- Nel DUT rd_data e' sempre zero.
        --------------------------------------------------------

        assert rd_data = x"00000000"
            report "ERROR: rd_data is not zero"
            severity failure;



        --------------------------------------------------------
        -- FINE TEST
        --------------------------------------------------------
        --
        -- Se arrivo qui, nessun assert precedente
        -- ha generato FAILURE.
        --------------------------------------------------------

        report "ALL TESTS PASSED"
            severity note;


        wait;


    end process;


end sim;
