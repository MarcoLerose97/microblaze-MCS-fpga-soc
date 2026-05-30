library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_core is
    port(
        clk      : in  std_logic;
        reset    : in  std_logic;

        wr_en    : in  std_logic;
        wr_addr  : in  std_logic_vector(4 downto 0);
        wr_data  : in  std_logic_vector(31 downto 0);

        rd_addr  : in  std_logic_vector(4 downto 0);
        rd_data  : out std_logic_vector(31 downto 0);

        rx       : in  std_logic;
        tx       : out std_logic
    );
end uart_core;

architecture Behavioral of uart_core is

    signal s_tick : std_logic;

    signal tx_start     : std_logic;
    signal tx_done_tick : std_logic;

    signal tx_fifo_wr    : std_logic;
    signal tx_fifo_rd    : std_logic;
    signal tx_fifo_empty : std_logic;
    signal tx_fifo_full  : std_logic;
    signal tx_fifo_data  : std_logic_vector(7 downto 0);

    signal tx_busy_reg : std_logic := '0';

    signal rx_done_tick  : std_logic;
    signal rx_data       : std_logic_vector(7 downto 0);

    signal rx_fifo_wr    : std_logic;
    signal rx_fifo_rd    : std_logic;
    signal rx_fifo_empty : std_logic;
    signal rx_fifo_full  : std_logic;
    signal rx_fifo_data  : std_logic_vector(7 downto 0);

begin

    baud_unit : entity work.baud_gen
        port map(
            clk   => clk,
            reset => reset,
            tick  => s_tick
        );

    tx_fifo_unit : entity work.fifo
        generic map(
            DATA_WIDTH => 8,
            ADDR_WIDTH => 4
        )
        port map(
            clk    => clk,
            reset  => reset,
            rd     => tx_fifo_rd,
            wr     => tx_fifo_wr,
            w_data => wr_data(7 downto 0),
            empty  => tx_fifo_empty,
            full   => tx_fifo_full,
            r_data => tx_fifo_data
        );

    tx_unit : entity work.uart_tx
        port map(
            clk          => clk,
            reset        => reset,
            tx_start     => tx_start,
            s_tick       => s_tick,
            din          => tx_fifo_data,
            tx_done_tick => tx_done_tick,
            tx           => tx
        );

    rx_unit : entity work.uart_rx
        port map(
            clk          => clk,
            reset        => reset,
            rx           => rx,
            s_tick       => s_tick,
            rx_done_tick => rx_done_tick,
            dout         => rx_data
        );

    rx_fifo_unit : entity work.fifo
        generic map(
            DATA_WIDTH => 8,
            ADDR_WIDTH => 4
        )
        port map(
            clk    => clk,
            reset  => reset,
            rd     => rx_fifo_rd,
            wr     => rx_fifo_wr,
            w_data => rx_data,
            empty  => rx_fifo_empty,
            full   => rx_fifo_full,
            r_data => rx_fifo_data
        );

    -- offset 2: write TX byte into TX FIFO
    tx_fifo_wr <= '1' when wr_en = '1' and wr_addr = "00010" and tx_fifo_full = '0'
                  else '0';

    -- start TX when UART is idle and TX FIFO has data
    tx_start <= '1' when tx_busy_reg = '0' and tx_fifo_empty = '0'
                else '0';

    -- pop TX FIFO when transmission starts
    tx_fifo_rd <= tx_start;

    -- push RX byte into RX FIFO when a byte is received
    rx_fifo_wr <= '1' when rx_done_tick = '1' and rx_fifo_full = '0'
                  else '0';

    -- offset 3: CPU reads/pops RX FIFO
    rx_fifo_rd <= '1' when rd_addr = "00011" and rx_fifo_empty = '0'
                  else '0';

    process(clk, reset)
    begin
        if reset = '1' then
            tx_busy_reg <= '0';

        elsif rising_edge(clk) then
            if tx_start = '1' then
                tx_busy_reg <= '1';

            elsif tx_done_tick = '1' then
                tx_busy_reg <= '0';
            end if;
        end if;
    end process;

    process(rd_addr, tx_busy_reg, tx_fifo_empty, tx_fifo_full,
            rx_fifo_empty, rx_fifo_full, rx_fifo_data)
    begin
        rd_data <= (others => '0');

        case rd_addr is

            -- offset 0: status register
            -- bit 0 = tx_busy
            -- bit 1 = tx_fifo_empty
            -- bit 2 = tx_fifo_full
            -- bit 3 = rx_fifo_empty
            -- bit 4 = rx_fifo_full
            when "00000" =>
                rd_data(0) <= tx_busy_reg;
                rd_data(1) <= tx_fifo_empty;
                rd_data(2) <= tx_fifo_full;
                rd_data(3) <= rx_fifo_empty;
                rd_data(4) <= rx_fifo_full;

            -- offset 3: RX data register
            when "00011" =>
                rd_data(7 downto 0) <= rx_fifo_data;

            when others =>
                rd_data <= (others => '0');

        end case;
    end process;

end Behavioral;
