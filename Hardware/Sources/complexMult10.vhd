library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity complexMult10 is
  generic (w1  : integer;
            w2 : integer);
  port (
    clk         : in  std_logic;
    rst         : in  std_logic;
    counter3Bit : in  std_logic_vector (2 downto 0);
    multInRe    : in  std_logic_vector((w1-1) downto 0);
    multInIm    : in  std_logic_vector((w1-1) downto 0);
    multOutRe   : out std_logic_vector((w2-1) downto 0);
    multOutIm   : out std_logic_vector((w2-1) downto 0));
end complexMult10;

architecture Behavioral of complexMult10 is

--Input registers for critical path
  signal multInReNext, multInImNext : signed((w1-1) downto 0);
  signal multInReReg , multInImReg  : signed((w1-1) downto 0);

  signal multOutRe1Reg, multOutIm1Reg   : signed((w1-1) downto 0);
  signal multOutRe1Next, multOutIm1Next : signed((w1-1) downto 0);

begin

  process(clk, rst)
  begin
    if(rst = '1') then
      multOutRe1Reg <= (others => '0');
      multOutIm1Reg <= (others => '0');
      multInReReg   <= (others => '0');
      multInImReg   <= (others => '0');
    elsif(clk'event and clk = '1') then
      multOutRe1Reg <= multOutRe1Next;
      multOutIm1Reg <= multOutIm1Next;
      multInReReg   <= multInReNext;
      multInImReg   <= multInImNext;
    end if;
  end process;

  multInReNext <= signed(multInRe);
  multInImNext <= signed(multInIm);



  with counter3Bit select
    multOutRe1Next <= "0000000000000000" when "000",
    multInImReg                          when "100",
    multInReReg                          when others;

  with counter3Bit select
    multOutIm1Next <= "0000000000000000" when "000",
    not(multInReReg)+1                   when "100",
    multInImReg                          when others;

  multOutRe <= '0' & std_logic_vector(multOutRe1Reg(15 downto 1)) when (multOutRe1Reg(15) = '0') else '1' & std_logic_vector(multOutRe1Reg(15 downto 1));
  multOutIm <= '0' & std_logic_vector(multOutIm1Reg(15 downto 1)) when (multOutIm1Reg(15) = '0') else '1' & std_logic_vector(multOutIm1Reg(15 downto 1));

end Behavioral;

