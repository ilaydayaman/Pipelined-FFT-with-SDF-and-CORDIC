library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;   

entity myButterfly is
    generic ( w1 : integer := 12);
    Port ( n1 : in signed( (w1-1) downto 0);
           n2 : in signed( (w1-1) downto 0);
           sumOut : out signed( (w1-1) downto 0);
           subOut : out signed( (w1-1) downto 0));
end myButterfly;

architecture Behavioral of myButterfly is

begin

sumOut <= n1 + n2;
subOut <= n1 - n2;

end Behavioral;
