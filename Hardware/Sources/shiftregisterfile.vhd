-- Shiftregister
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity shiftregisterfile is
  generic (
    constant ROW  : natural;            -- number of words
    constant COL  : natural;            -- wordlength
    constant NOFW : natural);  -- 2^NOFW = Number of words in registerfile
  port (
    clk     : in  std_logic;
    rst     : in  std_logic;
    writeEn : in  std_logic;
    dataIn  : in  std_logic_vector(COL-1 downto 0);
    dataOut : out std_logic_vector(COL-1 downto 0));
end entity;

architecture arch of shiftregisterfile is

  -- registerfile of size ROW x COL
  type   registerfile is array (ROW-1 downto 0) of std_logic_vector(COL-1 downto 0);
  signal regfileReg, regfileNext : registerfile;

begin

  -- register logic
  process(clk, rst)
  begin
    if (rst = '1') then
      for i in ROW-1 downto 0 loop
        regfileReg(i) <= (others => '0');
      elsif rising_edge(clk) then
        for i in ROW-1 downto 0 loop
          regfileReg(i) <= regfileNext(i);
        end loop;
      end if;
    end process;

      -- register next state logic
      writing : process(writeEn, dataIn, regfileReg)
      begin
        -- next state for regfileNext
        for i in ROW-1 downto 1 loop
          regfileNext(i) <= regfileReg(i-1);
        end loop;

        -- data written to registerfile if writeEn is high and its not full
        if (writeEn = '1') then
          regfileNext(0) <= dataIn;
        else
          regfileNext(0) <= regfileReg(0);
        end if;
      end process;

      -- output from registerfile to read port
      dataOut <= regfileReg(ROW-1);

    end architecture;
