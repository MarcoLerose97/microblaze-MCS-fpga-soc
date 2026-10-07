library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_chu_pwm is
end tb_chu_pwm;

architecture sim of tb_chu_pwm is

    constant W          : integer := 4;
    constant R          : integer := 4;
    constant CLK_PERIOD : time := 10 ns;

    signal clk     : std_logic := '0';
    signal reset   : std_logic := '0';

    signal cs      : std_logic := '0';
    signal write   : std_logic := '0';
    signal read    : std_logic := '0';
    signal addr    : std_logic_vector(4 downto 0) := (others => '0');
    signal rd_data : std_logic_vector(31 downto 0);
    signal wr_data : std_logic_vector(31 downto 0) := (others => '0');

    signal pwm_out : std_logic_vector(W-1 downto 0);

begin

    ------------------------------------------------------------
    -- DUT
    ------------------------------------------------------------

    uut : entity work.chu_pwm
        generic map(
            W => W,
            R => R
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
            pwm_out => pwm_out
        );


    ------------------------------------------------------------
    -- CLOCK
    ------------------------------------------------------------

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;


    ------------------------------------------------------------
    -- STIMULUS
    ------------------------------------------------------------

    stimulus : process

        variable high0 : integer := 0;
        variable high1 : integer := 0;
        variable high2 : integer := 0;
        variable high3 : integer := 0;

    begin

        --------------------------------------------------------
        -- RESET
        --------------------------------------------------------

        reset <= '1';
        wait for 20 ns;

        reset <= '0';
        wait for 10 ns;


        --------------------------------------------------------
        -- DIVISOR = 0
        --------------------------------------------------------

        wait until rising_edge(clk);

        cs      <= '1';
        write   <= '1';
        addr    <= "00000";
        wr_data <= x"00000000";

        wait until rising_edge(clk);

        cs    <= '0';
        write <= '0';


        --------------------------------------------------------
        -- PWM0 = 0/16 = 0%
        --------------------------------------------------------

        wait until rising_edge(clk);

        cs      <= '1';
        write   <= '1';
        addr    <= "10000";
        wr_data <= x"00000000";

        wait until rising_edge(clk);

        cs    <= '0';
        write <= '0';


        --------------------------------------------------------
        -- PWM1 = 8/16 = 50%
        --------------------------------------------------------

        wait until rising_edge(clk);

        cs      <= '1';
        write   <= '1';
        addr    <= "10001";
        wr_data <= x"00000008";

        wait until rising_edge(clk);

        cs    <= '0';
        write <= '0';


        --------------------------------------------------------
        -- PWM2 = 16/16 = 100%
        --------------------------------------------------------

        wait until rising_edge(clk);

        cs      <= '1';
        write   <= '1';
        addr    <= "10010";
        wr_data <= x"00000010";

        wait until rising_edge(clk);

        cs    <= '0';
        write <= '0';


        --------------------------------------------------------
        -- PWM3 = 4/16 = 25%
        --------------------------------------------------------

        wait until rising_edge(clk);

        cs      <= '1';
        write   <= '1';
        addr    <= "10011";
        wr_data <= x"00000004";

        wait until rising_edge(clk);

        cs    <= '0';
        write <= '0';


        --------------------------------------------------------
        -- Aspetto l'inizio di un nuovo periodo PWM
        --------------------------------------------------------

        wait for 160 ns;


        --------------------------------------------------------
        -- ANALISI DI UN PERIODO = 16 CLOCK
        --------------------------------------------------------

        for i in 1 to 16 loop

            wait until rising_edge(clk);
            wait for 1 ns;

            if pwm_out(0) = '1' then
                high0 := high0 + 1;
            end if;

            if pwm_out(1) = '1' then
                high1 := high1 + 1;
            end if;

            if pwm_out(2) = '1' then
                high2 := high2 + 1;
            end if;

            if pwm_out(3) = '1' then
                high3 := high3 + 1;
            end if;

        end loop;


        --------------------------------------------------------
        -- CHECK DUTY CYCLES
        --------------------------------------------------------

        assert high0 = 0
            report "ERROR: PWM0 duty cycle"
            severity failure;

        assert high1 = 8
            report "ERROR: PWM1 duty cycle"
            severity failure;

        assert high2 = 16
            report "ERROR: PWM2 duty cycle"
            severity failure;

        assert high3 = 4
            report "ERROR: PWM3 duty cycle"
            severity failure;


        report "ALL PWM TESTS PASSED"
            severity note;


        wait;

    end process;

end sim;
