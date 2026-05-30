library ieee;
use ieee.std_logic_1164.all;

entity top_soc is
    port(
        clk   : in  std_logic;
        reset : in  std_logic;
        sw    : in  std_logic_vector(15 downto 0);
        led   : out std_logic_vector(15 downto 0);
        rx    : in  std_logic;
        tx    : out std_logic
    );
end top_soc;

architecture Behavioral of top_soc is

    signal io_addr_strobe  : std_logic;
    signal io_read_strobe  : std_logic;
    signal io_write_strobe : std_logic;
    signal io_address      : std_logic_vector(31 downto 0);
    signal io_byte_enable  : std_logic_vector(3 downto 0);
    signal io_write_data   : std_logic_vector(31 downto 0);
    signal io_read_data    : std_logic_vector(31 downto 0);
    signal io_ready        : std_logic;

    component microblaze_mcs_0
        port(
            Clk             : in  std_logic;
            Reset           : in  std_logic;
            IO_addr_strobe  : out std_logic;
            IO_address      : out std_logic_vector(31 downto 0);
            IO_byte_enable  : out std_logic_vector(3 downto 0);
            IO_read_data    : in  std_logic_vector(31 downto 0);
            IO_read_strobe  : out std_logic;
            IO_ready        : in  std_logic;
            IO_write_data   : out std_logic_vector(31 downto 0);
            IO_write_strobe : out std_logic
        );
    end component;

    component chu_mmio_controller
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
    end component;

begin

    cpu_unit : microblaze_mcs_0
        port map(
            Clk             => clk,
            Reset           => reset,
            IO_addr_strobe  => io_addr_strobe,
            IO_address      => io_address,
            IO_byte_enable  => io_byte_enable,
            IO_read_data    => io_read_data,
            IO_read_strobe  => io_read_strobe,
            IO_ready        => io_ready,
            IO_write_data   => io_write_data,
            IO_write_strobe => io_write_strobe
        );

    mmio_unit : chu_mmio_controller
        port map(
            clk             => clk,
            reset           => reset,
            io_addr_strobe  => io_addr_strobe,
            io_read_strobe  => io_read_strobe,
            io_write_strobe => io_write_strobe,
            io_address      => io_address,
            io_write_data   => io_write_data,
            io_read_data    => io_read_data,
            io_ready        => io_ready,
            sw              => sw,
            led             => led,
            uart_rx         => rx,
            uart_tx         => tx
        );

end Behavioral;
