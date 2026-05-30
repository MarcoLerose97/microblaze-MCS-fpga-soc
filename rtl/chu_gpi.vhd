library ieee;
use ieee.std_logic_1164.all;

entity chu_gpi is
    port(
        din     : in  std_logic_vector(31 downto 0);
        rd_data : out std_logic_vector(31 downto 0)
    );
end chu_gpi;

architecture Behavioral of chu_gpi is
begin

    rd_data <= din;

end Behavioral;
