-- Design of FIFO top-level
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity FIFO is
  generic (
    constant ROW  : natural; -- number of words
    constant COL  : natural; -- wordlength
    constant NOFW : natural);-- 2^NOFW = Number of words in registerfile
  port (
    clk     : in  std_logic;
    rst     : in  std_logic;
    writeEn : in  std_logic;
    readEn  : in  std_logic;
    fifoIn  : in  std_logic_vector(COL-1 downto 0);
    fifoOut : out std_logic_vector(COL-1 downto 0));
end entity;

architecture arch of FIFO is

  component shiftregisterfile
    generic(
      constant ROW  : natural;  -- number of words
      constant COL  : natural;  -- wordlength
      constant NOFW : natural); -- 2^NOFW = Number of words in registerfile
    port (
      clk     : in  std_logic;
      rst     : in  std_logic;
      writeEn : in  std_logic;
      dataIn  : in  std_logic_vector(COL-1 downto 0);
      dataOut : out std_logic_vector(COL-1 downto 0));
  end component;

begin

  unit_shiftregisterfile : shiftregisterfile
    generic map (ROW => ROW, COL => COL, NOFW => NOFW)
    port map (clk     => clk,
              rst     => rst,
              writeEn => writeEn,
              dataIn  => fifoIn,
              dataOut => fifoOut);

end architecture;
