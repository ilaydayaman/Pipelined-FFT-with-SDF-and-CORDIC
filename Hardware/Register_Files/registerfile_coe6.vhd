-- Design of registerfile for coefficients
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity registerfilecoe6 is
  generic(
    constant ROW  : natural;            -- number of words
    constant NOFW : natural);  -- 2^NOFW = Number of words in registerfile
  port (
    readAdd  : in  std_logic_vector(NOFW-1 downto 0);
    dataOut1 : out std_logic_vector(11 downto 0);
    dataOut2 : out std_logic_vector(11 downto 0));

end registerfilecoe6;

architecture structural of registerfilecoe6 is

  -- registerfile of size ROW x COL
  type   registerfile is array (ROW-1 downto 0) of std_logic_vector(11 downto 0);
  signal regfileReg1, regfileReg2 : registerfile;

  signal readPtr : unsigned(NOFW-1 downto 0);

begin

  -- address conversion
  readPtr <= (unsigned(readAdd));

  -- output logic
  dataOut1 <= regfileReg1(to_integer(readPtr));
  dataOut2 <= regfileReg2(to_integer(readPtr));

  -- coefficients Real
  regfileReg1(0) <= "010000000000";
  regfileReg1(1) <= "001111111011";
  regfileReg1(2) <= "001111101100";
  regfileReg1(3) <= "001111010100";
  regfileReg1(4) <= "001110110010";
  regfileReg1(5) <= "001110000111";
  regfileReg1(6) <= "001101010011";
  regfileReg1(7) <= "001100011000";
  regfileReg1(8) <= "001011010100";

  -- coefficients Imaginary
  regfileReg2(0) <= "000000000000";
  regfileReg2(1) <= "111110011100";
  regfileReg2(2) <= "111100111000";
  regfileReg2(3) <= "111011010111";
  regfileReg2(4) <= "111001111000";
  regfileReg2(5) <= "111000011101";
  regfileReg2(6) <= "110111000111";
  regfileReg2(7) <= "110101110110";
  regfileReg2(8) <= "110100101100";

end architecture;
