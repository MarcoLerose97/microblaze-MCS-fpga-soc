library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_chu_uart is
end tb_chu_uart;

architecture sim of tb_chu_uart is

    constant CLK_PERIOD : time := 10 ns;
    constant DVSR       : integer := 1;
    constant BIT_PERIOD : time := 16 * (DVSR + 1) * CLK_PERIOD;

    signal clk     : std_logic := '0';
    signal reset   : std_logic := '0';
    signal cs      : std_logic := '0';
    signal write   : std_logic := '0';
    signal read    : std_logic := '0';
    signal addr    : std_logic_vector(4 downto 0) := (others => '0');
    signal rd_data : std_logic_vector(31 downto 0);
    signal wr_data : std_logic_vector(31 downto 0) := (others => '0');
    signal tx      : std_logic;
    signal rx      : std_logic := '1';

begin

    uut : entity work.chu_uart
        generic map(FIFO_DEPTH_BIT => 2)
        port map(
            clk     => clk,
            reset   => reset,
            cs      => cs,
            write   => write,
            read    => read,
            addr    => addr,
            rd_data => rd_data,
            wr_data => wr_data,
            tx      => tx,
            rx      => rx
        );



    clk <= not clk after CLK_PERIOD/2;



    stimulus : process
    
       --PROCEDURE BUS WRITE

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

        --PROCEDURE SEND BYT  (TO SIMULATE RECEIVE)
      
        procedure send_byte(
            constant data : std_logic_vector(7 downto 0)
        ) is
        begin
            rx <= '0';
            wait for BIT_PERIOD;

            for i in 0 to 7 loop
                rx <= data(i);
                wait for BIT_PERIOD;
            end loop;

            rx <= '1';
            wait for BIT_PERIOD;
        end procedure;

       --PROCEDURE CHECK TX 

        procedure check_tx(
            constant data : std_logic_vector(7 downto 0)
        ) is
        begin
            wait until falling_edge(tx);

            -- Centro dello START bit
            wait for BIT_PERIOD/2;
            assert tx = '0'
                report "ERROR: TX START"
                severity failure;

            -- Centro degli 8 DATA bit
            for i in 0 to 7 loop
                wait for BIT_PERIOD;
                assert tx = data(i)
                    report "ERROR: TX DATA"
                    severity failure;
            end loop;

            -- Centro dello STOP bit
            wait for BIT_PERIOD;
            assert tx = '1'
                report "ERROR: TX STOP"
                severity failure;
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

        assert rd_data(8) = '1' and rd_data(9) = '0'
            report "ERROR: RESET STATUS"
            severity failure;

        assert tx = '1'
            report "ERROR: TX IDLE"
            severity failure;

        report "RESET TEST PASSED" severity note;

        ------------------------------------------------
        -- BAUD RATE DIVISOR
        ------------------------------------------------
        bus_write("00001", x"00000001");

        report "BAUD RATE CONFIGURED" severity note;

        ------------------------------------------------
        -- RX BYTE 0xA5
        ------------------------------------------------
        send_byte(x"A5");

        wait for BIT_PERIOD;

        assert rd_data(8) = '0'
            report "ERROR: RX FIFO EMPTY"
            severity failure;

        assert rd_data(7 downto 0) = x"A5"
            report "ERROR: RX A5"
            severity failure;

        report "RX A5 TEST PASSED" severity note;

        ------------------------------------------------
        -- REMOVE RX BYTE
        ------------------------------------------------
        bus_write("00011", x"00000000");

        wait for 1 ns;

        assert rd_data(8) = '1'
            report "ERROR: RX FIFO NOT EMPTY"
            severity failure;

        ------------------------------------------------
        -- RX BYTE 0x3C
        ------------------------------------------------
        send_byte(x"3C");

        wait for BIT_PERIOD;

        assert rd_data(8) = '0'
            report "ERROR: RX FIFO EMPTY"
            severity failure;

        assert rd_data(7 downto 0) = x"3C"
            report "ERROR: RX 3C"
            severity failure;

        report "RX 3C TEST PASSED" severity note;

        bus_write("00011", x"00000000");

        ------------------------------------------------
        -- TX BYTE 0x55
        ------------------------------------------------
        bus_write("00010", x"00000055");

        check_tx(x"55");

        report "TX 55 TEST PASSED" severity note;

        ------------------------------------------------
        -- END
        ------------------------------------------------
        report "ALL CHU_UART TESTS PASSED"
            severity note;

        wait;

    end process;

end sim;
