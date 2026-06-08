library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity chu_pwm_tb is
end chu_pwm_tb;

architecture sim of chu_pwm_tb is

   constant W : integer := 4;
   constant R : integer := 4;

   signal clk      : std_logic := '0';
   signal reset    : std_logic := '0';

   signal cs       : std_logic := '0';
   signal write    : std_logic := '0';
   signal read     : std_logic := '0';
   signal addr     : std_logic_vector(4 downto 0) := (others => '0');
   signal rd_data  : std_logic_vector(31 downto 0);
   signal wr_data  : std_logic_vector(31 downto 0) := (others => '0');

   signal pwm_out  : std_logic_vector(W - 1 downto 0);

begin

   DUT : entity work.chu_pwm
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

   -- clock 100 MHz
   clk <= not clk after 5 ns;

   process
   begin
      ------------------------------------------------------------
      -- reset
      ------------------------------------------------------------
      reset <= '1';
      wait for 50 ns;

      reset <= '0';
      wait for 50 ns;

      ------------------------------------------------------------
      -- write divisor register
      -- addr 00000 = offset 0x00
      -- divisor = 0 -> tick every clock
      ------------------------------------------------------------
      cs      <= '1';
      write   <= '1';
      addr    <= "00000";
      wr_data <= x"00000000";

      wait for 10 ns;

      cs      <= '0';
      write   <= '0';
      addr    <= "00000";
      wr_data <= x"00000000";

      wait for 20 ns;

      ------------------------------------------------------------
      -- write PWM0 duty
      -- addr 10000 = offset 0x10
      -- duty = 0 -> 0%
      ------------------------------------------------------------
      cs      <= '1';
      write   <= '1';
      addr    <= "10000";
      wr_data <= x"00000000";

      wait for 10 ns;

      cs      <= '0';
      write   <= '0';

      wait for 20 ns;

      ------------------------------------------------------------
      -- write PWM1 duty
      -- addr 10001 = offset 0x11
      -- duty = 8 -> 50%, because R=4 and period=16
      ------------------------------------------------------------
      cs      <= '1';
      write   <= '1';
      addr    <= "10001";
      wr_data <= x"00000008";

      wait for 10 ns;

      cs      <= '0';
      write   <= '0';

      wait for 20 ns;

      ------------------------------------------------------------
      -- write PWM2 duty
      -- addr 10010 = offset 0x12
      -- duty = 16 -> 100%
      ------------------------------------------------------------
      cs      <= '1';
      write   <= '1';
      addr    <= "10010";
      wr_data <= x"00000010";

      wait for 10 ns;

      cs      <= '0';
      write   <= '0';

      wait for 20 ns;

      ------------------------------------------------------------
      -- write PWM3 duty
      -- addr 10011 = offset 0x13
      -- duty = 4 -> 25%
      ------------------------------------------------------------
      cs      <= '1';
      write   <= '1';
      addr    <= "10011";
      wr_data <= x"00000004";

      wait for 10 ns;

      cs      <= '0';
      write   <= '0';

      ------------------------------------------------------------
      -- observe waveform
      ------------------------------------------------------------
      wait for 1000 ns;

      wait;
   end process;

end sim;
