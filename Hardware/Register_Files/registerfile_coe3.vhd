-- Design of registerfile for coefficients
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity registerfilecoe3 is
  generic(
    constant ROW  : natural;            -- number of words
    constant NOFW : natural);  -- 2^NOFW = Number of words in registerfile
  port (
    readAdd  : in  std_logic_vector(NOFW-1 downto 0);
    dataOut1 : out std_logic_vector(11 downto 0);
    dataOut2 : out std_logic_vector(11 downto 0));

end registerfilecoe3;

architecture structural of registerfilecoe3 is

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
  regfileReg1(0)  <= "010000000000";
  regfileReg1(1)  <= "010000000000";
  regfileReg1(2)  <= "010000000000";
  regfileReg1(3)  <= "001111111111";
  regfileReg1(4)  <= "001111111111";
  regfileReg1(5)  <= "001111111110";
  regfileReg1(6)  <= "001111111101";
  regfileReg1(7)  <= "001111111100";
  regfileReg1(8)  <= "001111111011";
  regfileReg1(9)  <= "001111111010";
  regfileReg1(10) <= "001111111000";
  regfileReg1(11) <= "001111110111";
  regfileReg1(12) <= "001111110101";
  regfileReg1(13) <= "001111110011";
  regfileReg1(14) <= "001111110001";
  regfileReg1(15) <= "001111101111";
  regfileReg1(16) <= "001111101100";
  regfileReg1(17) <= "001111101010";
  regfileReg1(18) <= "001111100111";
  regfileReg1(19) <= "001111100100";
  regfileReg1(20) <= "001111100001";
  regfileReg1(21) <= "001111011110";
  regfileReg1(22) <= "001111011011";
  regfileReg1(23) <= "001111010111";
  regfileReg1(24) <= "001111010100";
  regfileReg1(25) <= "001111010000";
  regfileReg1(26) <= "001111001100";
  regfileReg1(27) <= "001111001000";
  regfileReg1(28) <= "001111000100";
  regfileReg1(29) <= "001111000000";
  regfileReg1(30) <= "001110111011";
  regfileReg1(31) <= "001110110111";
  regfileReg1(32) <= "001110110010";
  regfileReg1(33) <= "001110101101";
  regfileReg1(34) <= "001110101000";
  regfileReg1(35) <= "001110100011";
  regfileReg1(36) <= "001110011110";
  regfileReg1(37) <= "001110011000";
  regfileReg1(38) <= "001110010011";
  regfileReg1(39) <= "001110001101";
  regfileReg1(40) <= "001110000111";
  regfileReg1(41) <= "001110000001";
  regfileReg1(42) <= "001101111011";
  regfileReg1(43) <= "001101110101";
  regfileReg1(44) <= "001101101110";
  regfileReg1(45) <= "001101101000";
  regfileReg1(46) <= "001101100001";
  regfileReg1(47) <= "001101011010";
  regfileReg1(48) <= "001101010011";
  regfileReg1(49) <= "001101001100";
  regfileReg1(50) <= "001101000101";
  regfileReg1(51) <= "001100111110";
  regfileReg1(52) <= "001100110110";
  regfileReg1(53) <= "001100101111";
  regfileReg1(54) <= "001100100111";
  regfileReg1(55) <= "001100011111";
  regfileReg1(56) <= "001100011000";
  regfileReg1(57) <= "001100010000";
  regfileReg1(58) <= "001100000111";
  regfileReg1(59) <= "001011111111";
  regfileReg1(60) <= "001011110111";
  regfileReg1(61) <= "001011101110";
  regfileReg1(62) <= "001011100110";
  regfileReg1(63) <= "001011011101";
  regfileReg1(64) <= "001011010100";


  -- coefficients Imaginary
  regfileReg2(0)  <= "000000000000";
  regfileReg2(1)  <= "111111110011";
  regfileReg2(2)  <= "111111100111";
  regfileReg2(3)  <= "111111011010";
  regfileReg2(4)  <= "111111001110";
  regfileReg2(5)  <= "111111000001";
  regfileReg2(6)  <= "111110110101";
  regfileReg2(7)  <= "111110101000";
  regfileReg2(8)  <= "111110011100";
  regfileReg2(9)  <= "111110001111";
  regfileReg2(10) <= "111110000011";
  regfileReg2(11) <= "111101110110";
  regfileReg2(12) <= "111101101010";
  regfileReg2(13) <= "111101011101";
  regfileReg2(14) <= "111101010001";
  regfileReg2(15) <= "111101000101";
  regfileReg2(16) <= "111100111000";
  regfileReg2(17) <= "111100101100";
  regfileReg2(18) <= "111100100000";
  regfileReg2(19) <= "111100010011";
  regfileReg2(20) <= "111100000111";
  regfileReg2(21) <= "111011111011";
  regfileReg2(22) <= "111011101111";
  regfileReg2(23) <= "111011100011";
  regfileReg2(24) <= "111011010111";
  regfileReg2(25) <= "111011001011";
  regfileReg2(26) <= "111010111111";
  regfileReg2(27) <= "111010110011";
  regfileReg2(28) <= "111010100111";
  regfileReg2(29) <= "111010011011";
  regfileReg2(30) <= "111010001111";
  regfileReg2(31) <= "111010000100";
  regfileReg2(32) <= "111001111000";
  regfileReg2(33) <= "111001101101";
  regfileReg2(34) <= "111001100001";
  regfileReg2(35) <= "111001010110";
  regfileReg2(36) <= "111001001010";
  regfileReg2(37) <= "111000111111";
  regfileReg2(38) <= "111000110100";
  regfileReg2(39) <= "111000101000";
  regfileReg2(40) <= "111000011101";
  regfileReg2(41) <= "111000010010";
  regfileReg2(42) <= "111000000111";
  regfileReg2(43) <= "110111111100";
  regfileReg2(44) <= "110111110010";
  regfileReg2(45) <= "110111100111";
  regfileReg2(46) <= "110111011100";
  regfileReg2(47) <= "110111010010";
  regfileReg2(48) <= "110111000111";
  regfileReg2(49) <= "110110111101";
  regfileReg2(50) <= "110110110010";
  regfileReg2(51) <= "110110101000";
  regfileReg2(52) <= "110110011110";
  regfileReg2(53) <= "110110010100";
  regfileReg2(54) <= "110110001010";
  regfileReg2(55) <= "110110000000";
  regfileReg2(56) <= "110101110110";
  regfileReg2(57) <= "110101101101";
  regfileReg2(58) <= "110101100011";
  regfileReg2(59) <= "110101011010";
  regfileReg2(60) <= "110101010000";
  regfileReg2(61) <= "110101000111";
  regfileReg2(62) <= "110100111110";
  regfileReg2(63) <= "110100110101";
  regfileReg2(64) <= "110100101100";

end architecture;
