-- Design of fifo controller
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity fifoctr is
  generic (
    constant NOFW : natural  -- 2^NOFW = Number of words in registerfile
    );
  port (
    clk      : in  std_logic;
    rst      : in  std_logic;
    writeEn  : in  std_logic;
    readEn   : in  std_logic;
    writeAdd : out std_logic_vector(NOFW-1 downto 0);
    readAdd  : out std_logic_vector(NOFW-1 downto 0)
    );
end fifoctr;

architecture arch of fifoctr is

  signal writePtrReg, writePtrNext : unsigned(NOFW downto 0);  -- MSB used for status full/empty
  signal readPtrReg, readPtrNext   : unsigned(NOFW downto 0);  -- MSB used for status full/empty
  signal statFull                  : std_logic;  -- '1' = Full & '0' = not full
  signal statEmpty                 : std_logic;  -- '1' = empty & '0' = not empty

begin
  -- register logic
  register_logic : process(clk, rst)
  begin
    if (rst = '1') then
      writePtrReg <= (others => '0');
      readPtrReg  <= (others => '0');
    elsif rising_edge(clk) then
      writePtrReg <= writePtrNext;
      readPtrReg  <= readPtrNext;
    end if;
  end process;

  -- next state logic write and read pointers
  writePtrNext <= writePtrReg + 1 when (writeEn = '1') else writePtrReg;
  readPtrNext  <= readPtrReg + 1  when (readEn = '1') and (statEmpty = '0') else readPtrReg;

  -- status logic for full/empty
  statFull  <= '1' when (writePtrReg(NOFW) /= readPtrReg(NOFW)) and (writePtrReg(NOFW-1 downto 0) = readPtrReg(NOFW-1 downto 0)) else '0';
  statEmpty <= '1' when (writePtrReg = readPtrReg) else '0';

  -- outputs
  writeAdd <= std_logic_vector(writePtrReg(NOFW-1 downto 0));
  readAdd  <= std_logic_vector(readPtrReg(NOFW-1 downto 0));

end architecture;
