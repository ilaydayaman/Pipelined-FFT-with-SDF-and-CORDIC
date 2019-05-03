library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity complexMult is
    Generic ( w1 : integer := 12;
              w2 : integer := 13);
    Port ( 
           clk       : in  std_logic;
           rst       : in  std_logic; 
           multInRe  : in signed( (w1-1) downto 0);
           multInIm  : in signed( (w1-1) downto 0);
           coeffRe   : in signed( (w1-1) downto 0);
           coeffIm   : in signed( (w1-1) downto 0);
           multOutRe : out signed( (w2-1) downto 0);
           multOutIm : out signed( (w2-1) downto 0));
end complexMult;

architecture Behavioral of complexMult is

signal multOutRe1Reg, multOutRe2Reg, multOutIm1Reg, multOutIm2Reg : signed( (2*w1-1) downto 0);
signal multOutRe1Next, multOutRe2Next, multOutIm1Next, multOutIm2Next : signed( (2*w1-1) downto 0);

begin

process(clk, rst)
  begin
    if(rst = '1') then
      multOutRe1Reg <= (others => '0');
      multOutRe2Reg <= (others => '0');
      multOutIm1Reg <= (others => '0');
      multOutIm2Reg <= (others => '0');
    elsif(clk'event and clk = '1') then
      multOutRe1Reg <= multOutRe1Next;
      multOutRe2Reg <= multOutRe2Next;
      multOutIm1Reg <= multOutIm1Next;
      multOutIm2Reg <= multOutIm2Next;
    end if;
  end process;

multOutRe1Next <= multInRe*coeffRe;
multOutRe2Next <= multInIm*coeffIm;
multOutIm1Next <= multInIm*coeffRe;
multOutIm2Next <= multInRe*coeffIm;

multOutRe <= multOutRe1Reg((w2-1) downto 0) - multOutRe2Reg((w2-1) downto 0);
multOutIm <= multOutIm1Reg((w2-1) downto 0) + multOutIm2Reg((w2-1) downto 0);

end Behavioral;
