library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_reg_file is
end tb_reg_file;

architecture sim of tb_reg_file is

    constant CLK_PERIOD : time := 10 ns;

    signal clk    : std_logic := '0';
    signal wr_en  : std_logic := '0';
    signal w_addr : std_logic_vector(1 downto 0) := (others => '0');
    signal r_addr : std_logic_vector(1 downto 0) := (others => '0');
    signal w_data : std_logic_vector(7 downto 0) := (others => '0');
    signal r_data : std_logic_vector(7 downto 0);

begin

    uut : entity work.reg_file
        generic map(
            ADDR_WIDTH => 2,
            DATA_WIDTH => 8
        )
        port map(
            clk    => clk,
            wr_en  => wr_en,
            w_addr => w_addr,
            r_addr => r_addr,
            w_data => w_data,
            r_data => r_data
        );

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;


    stimulus : process
    begin

        -- WRITE address 00
        w_addr <= "00";
        w_data <= x"12";
        wr_en  <= '1';
        wait until rising_edge(clk);

        -- WRITE address 01
        w_addr <= "01";
        w_data <= x"AB";
        wait until rising_edge(clk);

        -- WRITE address 10
        w_addr <= "10";
        w_data <= x"55";
        wait until rising_edge(clk);

        -- WRITE address 11
        w_addr <= "11";
        w_data <= x"FF";
        wait until rising_edge(clk);

        wr_en <= '0';

        -- READ + CHECK
        r_addr <= "00";
        wait for 1 ns;
        assert r_data = x"12"
            report "ERROR address 00" severity failure;

        r_addr <= "01";
        wait for 1 ns;
        assert r_data = x"AB"
            report "ERROR address 01" severity failure;

        r_addr <= "10";
        wait for 1 ns;
        assert r_data = x"55"
            report "ERROR address 10" severity failure;

        r_addr <= "11";
        wait for 1 ns;
        assert r_data = x"FF"
            report "ERROR address 11" severity failure;

        report "ALL REG_FILE TESTS PASSED" severity note;

        wait;
    end process;

end sim;
