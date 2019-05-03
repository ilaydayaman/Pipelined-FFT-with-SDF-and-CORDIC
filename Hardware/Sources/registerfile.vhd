-- Design of registerfile
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity registerfile is
  generic (
    constant ROW : natural; -- number of words
    constant COL : natural; -- wordlength
    constant NOFW : natural); -- 2^NOFW = Number of words in registerfile
  port (
    clk : in std_logic;
    rst : in std_logic;
    writeEn : in std_logic;
    --readEn : in std_logic;
    full : in std_logic;
    writeAdd : in std_logic_vector(NOFW-1 downto 0);
    readAdd : in std_logic_vector(NOFW-1 downto 0);
    dataIn : in std_logic_vector(COL-1 downto 0);
    dataOut : out std_logic_vector(COL-1 downto 0));
end entity;

architecture arch of registerfile is

  type registerfile is array (ROW-1 downto 0) of std_logic_vector(COL-1 downto 0); -- registerfile of size ROW x COL
  signal regfileReg, regfileNext : registerfile;

  signal writePtr : unsigned(NOFW-1 downto 0);
  signal readPtr : unsigned(NOFW-1 downto 0);

begin

  -- register logic
  process(clk,rst)
  begin
    for i in ROW-1 downto 0 loop
      if (rst = '1') then
        regfileReg(i) <= (others=>'0'); --(others=>(others=>'1'));
      elsif rising_edge(clk) then
        regfileReg(i) <= regfileNext(i);
      end if;
    end loop;
  end process;

  -- register next state logic
  writePtr <= unsigned(writeAdd); -- converting input, std_logic to unsigned
  readPtr <= unsigned(readAdd); -- converting input, std_logic to unsigned

  writing : process(writeEn,writePtr,dataIn,regfileReg,full)
  begin
    -- next state for regfileNext
    for i in ROW-1 downto 0 loop
      regfileNext(i) <= regfileReg(i);
    end loop;

    -- data written to registerfile if writeEn is high and its not full
    if (writeEn = '1') and (full = '0') then
        regfileNext(to_integer(writePtr)) <= dataIn;
    end if;
  end process;

  -- output from registerfile to read port
  dataOut <= regfileReg(to_integer(readPtr));

end architecture;
