
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_chu_spi_core is
end tb_chu_spi_core;

architecture sim of tb_chu_spi_core is

    constant CLK_PERIOD : time := 10 ns;
    constant DVSR       : integer := 4;
    constant HALF_SPI   : time := (DVSR + 1) * CLK_PERIOD;

    signal clk      : std_logic := '0';
    signal reset    : std_logic := '0';

    signal cs       : std_logic := '0';
    signal write    : std_logic := '0';
    signal read     : std_logic := '0';
    signal addr     : std_logic_vector(4 downto 0) := (others => '0');

    signal rd_data  : std_logic_vector(31 downto 0);
    signal wr_data  : std_logic_vector(31 downto 0) := (others => '0');

    signal spi_sclk : std_logic;
    signal spi_mosi : std_logic;
    signal spi_miso : std_logic := '0';
    signal spi_ss_n : std_logic_vector(1 downto 0);

    constant TX_BYTE : std_logic_vector(7 downto 0) := x"A5";
    constant RX_BYTE : std_logic_vector(7 downto 0) := x"3C";

begin

    uut : entity work.chu_spi_core
        generic map(S => 2)
        port map(
            clk      => clk,
            reset    => reset,
            cs       => cs,
            write    => write,
            read     => read,
            addr     => addr,
            rd_data  => rd_data,
            wr_data  => wr_data,
            spi_sclk => spi_sclk,
            spi_mosi => spi_mosi,
            spi_miso => spi_miso,
            spi_ss_n => spi_ss_n
        );

    clk <= not clk after CLK_PERIOD/2;

    ------------------------------------------------
    -- SPI SLAVE MODEL (MODE 0)
    ------------------------------------------------
    slave_model : process
    begin
        wait until spi_ss_n(0) = '0';

        -- Primo bit MISO disponibile prima del primo rising SCLK
        spi_miso <= RX_BYTE(7);

        for i in 7 downto 0 loop

            wait until rising_edge(spi_sclk);
            wait for 1 ns;

            assert spi_mosi = TX_BYTE(i)
                report "ERROR: MOSI DATA"
                severity failure;

            wait until falling_edge(spi_sclk);

            if i > 0 then
                spi_miso <= RX_BYTE(i-1);
            end if;

        end loop;

        report "SPI MOSI TEST PASSED" severity note;
        wait;
    end process;

    ------------------------------------------------
    -- MAIN STIMULUS
    ------------------------------------------------
    stimulus : process

        procedure bus_write(
            constant address : std_logic_vector(4 downto 0);
            constant data    : std_logic_vector(31 downto 0)
        ) is
        begin
            wait until rising_edge(clk);

            addr    <= address;
            wr_data <= data;
            cs      <= '1';
            write   <= '1';

            wait until rising_edge(clk);

            cs    <= '0';
            write <= '0';

            wait for 1 ns;
        end procedure;

    begin

        ------------------------------------------------
        -- RESET
        ------------------------------------------------
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        wait until rising_edge(clk);
        wait for 1 ns;

        assert spi_ss_n = "11"
            report "ERROR: RESET SS"
            severity failure;

        assert rd_data(8) = '1'
            report "ERROR: SPI NOT READY AFTER RESET"
            severity failure;

        report "RESET TEST PASSED" severity note;

        ------------------------------------------------
        -- CONFIGURE SPI MODE 0, DVSR = 4
        ------------------------------------------------
        bus_write("00011", x"00000004");

        report "SPI CONFIGURATION PASSED" severity note;

        ------------------------------------------------
        -- SELECT SLAVE 0
        ------------------------------------------------
        bus_write("00001", x"00000002");

        assert spi_ss_n = "10"
            report "ERROR: SLAVE SELECT"
            severity failure;

        report "SLAVE SELECT TEST PASSED" severity note;

        ------------------------------------------------
        -- START SPI TRANSFER
        ------------------------------------------------
        bus_write("00010", x"000000A5");

        wait until rd_data(8) = '0';
        wait until rd_data(8) = '1';
        wait for 1 ns;

        ------------------------------------------------
        -- CHECK RECEIVED BYTE
        ------------------------------------------------
        assert rd_data(7 downto 0) = RX_BYTE
            report "ERROR: SPI MISO DATA"
            severity failure;

        report "SPI MISO TEST PASSED" severity note;

        ------------------------------------------------
        -- DESELECT SLAVE
        ------------------------------------------------
        bus_write("00001", x"00000003");

        assert spi_ss_n = "11"
            report "ERROR: SLAVE DESELECT"
            severity failure;

        report "ALL SPI TESTS PASSED" severity note;

        wait;

    end process;

end sim;
