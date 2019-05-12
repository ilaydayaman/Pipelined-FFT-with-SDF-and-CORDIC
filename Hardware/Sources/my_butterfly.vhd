library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;   

entity myButterfly is
    generic ( w1 : integer);
    Port ( n1 : in std_logic_vector( (w1-1) downto 0);
           n2 : in std_logic_vector( (w1-1) downto 0);
           sumOut : out std_logic_vector( (w1-1) downto 0);
           subOut : out std_logic_vector( (w1-1) downto 0));
end myButterfly;

architecture Behavioral of myButterfly is

begin

sumOut <= std_logic_vector(signed(n1) + signed(n2));
subOut <= std_logic_vector(signed(n1) - signed(n2));

end Behavioral;
