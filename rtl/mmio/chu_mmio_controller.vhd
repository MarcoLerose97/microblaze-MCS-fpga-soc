library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.chu_io_map.all;

entity chu_mmio_controller is
    port(
        clk             : in  std_logic;
        reset           : in  std_logic;

        io_addr_strobe  : in  std_logic;
        io_read_strobe  : in  std_logic;
        io_write_strobe : in  std_logic;
        io_address      : in  std_logic_vector(31 downto 0);
        io_write_data   : in  std_logic_vector(31 downto 0);
        io_read_data    : out std_logic_vector(31 downto 0);
        io_ready        : out std_logic;

        sw              : in  std_logic_vector(15 downto 0);
        led             : out std_logic_vector(15 downto 0);

        uart_rx         : in  std_logic;
        uart_tx         : out std_logic
    );
end chu_mmio_controller;

architecture Behavioral of chu_mmio_controller is

    signal timer_wr_en   : std_logic;
    signal timer_rd_data : std_logic_vector(31 downto 0);

    signal uart_wr_en    : std_logic;
    signal uart_rd_data  : std_logic_vector(31 downto 0);

    signal led_wr_en     : std_logic;
    signal led_reg_data  : std_logic_vector(31 downto 0);

    signal sw_32         : std_logic_vector(31 downto 0);
    signal sw_rd_data    : std_logic_vector(31 downto 0);

    signal slot_id       : unsigned(4 downto 0);
    signal reg_offset    : std_logic_vector(4 downto 0);

begin

    slot_id    <= unsigned(io_address(11 downto 7));
    reg_offset <= io_address(6 downto 2);

    sw_32 <= x"0000" & sw;

    timer_wr_en <= '1' when
        io_write_strobe = '1' and
        slot_id = to_unsigned(S0_SYS_TIMER, 5)
        else '0';

    uart_wr_en <= '1' when
        io_write_strobe = '1' and
        slot_id = to_unsigned(S1_UART1, 5)
        else '0';

    led_wr_en <= '1' when
        io_write_strobe = '1' and
        slot_id = to_unsigned(S2_LED, 5)
        else '0';

    timer_unit : entity work.chu_timer
        port map(
            clk     => clk,
            reset   => reset,
            wr_en   => timer_wr_en,
            wr_addr => reg_offset,
            wr_data => io_write_data,
            rd_addr => reg_offset,
            rd_data => timer_rd_data
        );

    uart_unit : entity work.uart_core
        port map(
            clk     => clk,
            reset   => reset,

            wr_en   => uart_wr_en,
            wr_addr => reg_offset,
            wr_data => io_write_data,

            rd_addr => reg_offset,
            rd_data => uart_rd_data,

            rx      => uart_rx,
            tx      => uart_tx
        );

    gpo_led_unit : entity work.chu_gpo
        port map(
            clk     => clk,
            reset   => reset,
            wr_en   => led_wr_en,
            wr_data => io_write_data,
            dout    => led_reg_data
        );

    gpi_sw_unit : entity work.chu_gpi
        port map(
            din     => sw_32,
            rd_data => sw_rd_data
        );

    process(io_read_strobe, slot_id, timer_rd_data, uart_rd_data, led_reg_data, sw_rd_data)
    begin
        io_read_data <= (others => '0');

        if io_read_strobe = '1' then
            if slot_id = to_unsigned(S0_SYS_TIMER, 5) then
                io_read_data <= timer_rd_data;

            elsif slot_id = to_unsigned(S1_UART1, 5) then
                io_read_data <= uart_rd_data;

            elsif slot_id = to_unsigned(S2_LED, 5) then
                io_read_data <= led_reg_data;

            elsif slot_id = to_unsigned(S3_SW, 5) then
                io_read_data <= sw_rd_data;
            end if;
        end if;
    end process;

    io_ready <= '1';
    led <= led_reg_data(15 downto 0);

end Behavioral;
