library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity complexMult is
    Generic ( w1 : integer := 12;
              w2 : integer := 13);
    Port ( 
           clk       : in  std_logic;
           rst       : in  std_logic; 
           multInRe  : in std_logic_vector( (w1-1) downto 0);
           multInIm  : in std_logic_vector( (w1-1) downto 0);
           coeffRe   : in std_logic_vector( (w1-1) downto 0);
           coeffIm   : in std_logic_vector( (w1-1) downto 0);
           multOutRe : out std_logic_vector( (w2-1) downto 0);
           multOutIm : out std_logic_vector( (w2-1) downto 0));
end complexMult;

architecture Behavioral of complexMult is

--Input registers for critical path 
signal multInReNext, multInImNext : signed( (w1-1) downto 0);
signal multInReReg , multInImReg  : signed( (w1-1) downto 0);
signal coeffReNext, coeffImNext   : signed( (w1-1) downto 0);
signal coeffReReg, coeffImReg     : signed( (w1-1) downto 0);

signal multOutRe1Reg, multOutRe2Reg, multOutIm1Reg, multOutIm2Reg : signed( (2*w1-1) downto 0);
signal multOutRe1Next, multOutRe2Next, multOutIm1Next, multOutIm2Next : signed( (2*w1-1) downto 0);

--Output registers for critical path 
signal multOutReNext, multOutImNext : signed( (2*w1-1) downto 0);
signal multOutReReg, multOutImReg : signed( (2*w1-1) downto 0);

begin

process(clk, rst)
  begin
    if(rst = '1') then
      multOutRe1Reg <= (others => '0');
      multOutRe2Reg <= (others => '0');
      multOutIm1Reg <= (others => '0');
      multOutIm2Reg <= (others => '0');
      multOutReReg <=  (others => '0');
      multOutImReg <=  (others => '0');
      multInReReg  <=  (others => '0');
      multInImReg  <=  (others => '0');
      coeffReReg   <=  (others => '0');
      coeffImReg   <=  (others => '0');
    elsif(clk'event and clk = '1') then
      multOutRe1Reg <= multOutRe1Next;
      multOutRe2Reg <= multOutRe2Next;
      multOutIm1Reg <= multOutIm1Next;
      multOutIm2Reg <= multOutIm2Next;
      multOutReReg  <= multOutReNext;
      multOutImReg  <= multOutImNext;
      multInReReg   <= multInReNext;
      multInImReg   <= multInImNext;
      coeffReReg    <= coeffReNext;
      coeffImReg    <= coeffImNext;
    end if;
  end process;

multInReNext <= signed(multInRe);
multInImNext <= signed(multInIm);
coeffReNext  <= signed(coeffRe);
coeffImNext  <= signed(coeffIm);

multOutRe1Next <= multInReReg*coeffReReg;
multOutRe2Next <= multInImReg*coeffImReg;
multOutIm1Next <= multInImReg*coeffReReg;
multOutIm2Next <= multInReReg*coeffImReg;

multOutReNext <= multOutRe1Reg - multOutRe2Reg;
multOutImNext <= multOutIm1Reg + multOutIm2Reg;

multOutRe <= std_logic_vector(multOutReReg((w2-1) downto 0));
multOutIm <= std_logic_vector(multOutImReg((w2-1) downto 0));

end Behavioral;
