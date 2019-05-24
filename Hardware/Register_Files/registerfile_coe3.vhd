-- Design of registerfile for coefficients

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity registerfilecoe3 is
  generic(
    constant ROW : natural; -- number of words
    constant NOFW : natural); -- 2^NOFW = Number of words in registerfile
  port (
    readAdd : in std_logic_vector(NOFW-1 downto 0);
    dataOut1 : out std_logic_vector(11 downto 0);
    dataOut2 : out std_logic_vector(11 downto 0));

end registerfilecoe3;

architecture structural of registerfilecoe3 is

  type registerfile is array (ROW-1 downto 0) of std_logic_vector(11 downto 0); -- registerfile of size ROW x COL
  signal regfileReg1, regfileReg2 : registerfile;

  signal readPtr : unsigned(NOFW-1 downto 0);

begin

    -- address conversion
    readPtr <= (unsigned(readAdd));

    -- output logic
    dataOut1 <= regfileReg1(to_integer(readPtr));
    dataOut2 <= regfileReg2(to_integer(readPtr));

    -- coefficients Real
    regfileReg1(0) <= "011111111111";
    regfileReg1(1) <= "011111111111";
    regfileReg1(2) <= "011111111111";
    regfileReg1(3) <= "011111111111";
    regfileReg1(4) <= "011111111110";
    regfileReg1(5) <= "011111111100";
    regfileReg1(6) <= "011111111010";
    regfileReg1(7) <= "011111111000";
    regfileReg1(8) <= "011111110110";
    regfileReg1(9) <= "011111110100";
    regfileReg1(10) <= "011111110001";
    regfileReg1(11) <= "011111101101";
    regfileReg1(12) <= "011111101010";
    regfileReg1(13) <= "011111100110";
    regfileReg1(14) <= "011111100010";
    regfileReg1(15) <= "011111011101";
    regfileReg1(16) <= "011111011001";
    regfileReg1(17) <= "011111010100";
    regfileReg1(18) <= "011111001110";
    regfileReg1(19) <= "011111001001";
    regfileReg1(20) <= "011111000011";
    regfileReg1(21) <= "011110111100";
    regfileReg1(22) <= "011110110110";
    regfileReg1(23) <= "011110101111";
    regfileReg1(24) <= "011110101000";
    regfileReg1(25) <= "011110100000";
    regfileReg1(26) <= "011110011001";
    regfileReg1(27) <= "011110010001";
    regfileReg1(28) <= "011110001000";
    regfileReg1(29) <= "011110000000";
    regfileReg1(30) <= "011101110111";
    regfileReg1(31) <= "011101101110";
    regfileReg1(32) <= "011101100100";
    regfileReg1(33) <= "011101011010";
    regfileReg1(34) <= "011101010000";
    regfileReg1(35) <= "011101000110";
    regfileReg1(36) <= "011100111011";
    regfileReg1(37) <= "011100110000";
    regfileReg1(38) <= "011100100101";
    regfileReg1(39) <= "011100011010";
    regfileReg1(40) <= "011100001110";
    regfileReg1(41) <= "011100000010";
    regfileReg1(42) <= "011011110110";
    regfileReg1(43) <= "011011101001";
    regfileReg1(44) <= "011011011101";
    regfileReg1(45) <= "011011010000";
    regfileReg1(46) <= "011011000010";
    regfileReg1(47) <= "011010110101";
    regfileReg1(48) <= "011010100111";
    regfileReg1(49) <= "011010011001";
    regfileReg1(50) <= "011010001010";
    regfileReg1(51) <= "011001111100";
    regfileReg1(52) <= "011001101101";
    regfileReg1(53) <= "011001011110";
    regfileReg1(54) <= "011001001111";
    regfileReg1(55) <= "011000111111";
    regfileReg1(56) <= "011000101111";
    regfileReg1(57) <= "011000011111";
    regfileReg1(58) <= "011000001111";
    regfileReg1(59) <= "010111111110";
    regfileReg1(60) <= "010111101101";
    regfileReg1(61) <= "010111011100";
    regfileReg1(62) <= "010111001011";
    regfileReg1(63) <= "010110111010";
    regfileReg1(64) <= "010110101000";


    -- coefficients Imaginary
    regfileReg2(0) <= "000000000000";
    regfileReg2(1) <= "111111100111";
    regfileReg2(2) <= "111111001110";
    regfileReg2(3) <= "111110110101";
    regfileReg2(4) <= "111110011100";
    regfileReg2(5) <= "111110000010";
    regfileReg2(6) <= "111101101001";
    regfileReg2(7) <= "111101010000";
    regfileReg2(8) <= "111100110111";
    regfileReg2(9) <= "111100011110";
    regfileReg2(10) <= "111100000101";
    regfileReg2(11) <= "111011101100";
    regfileReg2(12) <= "111011010011";
    regfileReg2(13) <= "111010111011";
    regfileReg2(14) <= "111010100010";
    regfileReg2(15) <= "111010001001";
    regfileReg2(16) <= "111001110000";
    regfileReg2(17) <= "111001011000";
    regfileReg2(18) <= "111000111111";
    regfileReg2(19) <= "111000100111";
    regfileReg2(20) <= "111000001110";
    regfileReg2(21) <= "110111110110";
    regfileReg2(22) <= "110111011110";
    regfileReg2(23) <= "110111000110";
    regfileReg2(24) <= "110110101101";
    regfileReg2(25) <= "110110010101";
    regfileReg2(26) <= "110101111110";
    regfileReg2(27) <= "110101100110";
    regfileReg2(28) <= "110101001110";
    regfileReg2(29) <= "110100110110";
    regfileReg2(30) <= "110100011111";
    regfileReg2(31) <= "110100001000";
    regfileReg2(32) <= "110011110000";
    regfileReg2(33) <= "110011011001";
    regfileReg2(34) <= "110011000010";
    regfileReg2(35) <= "110010101011";
    regfileReg2(36) <= "110010010100";
    regfileReg2(37) <= "110001111110";
    regfileReg2(38) <= "110001100111";
    regfileReg2(39) <= "110001010001";
    regfileReg2(40) <= "110000111011";
    regfileReg2(41) <= "110000100100";
    regfileReg2(42) <= "110000001111";
    regfileReg2(43) <= "101111111001";
    regfileReg2(44) <= "101111100011";
    regfileReg2(45) <= "101111001110";
    regfileReg2(46) <= "101110111000";
    regfileReg2(47) <= "101110100011";
    regfileReg2(48) <= "101110001110";
    regfileReg2(49) <= "101101111001";
    regfileReg2(50) <= "101101100101";
    regfileReg2(51) <= "101101010000";
    regfileReg2(52) <= "101100111100";
    regfileReg2(53) <= "101100101000";
    regfileReg2(54) <= "101100010100";
    regfileReg2(55) <= "101100000000";
    regfileReg2(56) <= "101011101101";
    regfileReg2(57) <= "101011011001";
    regfileReg2(58) <= "101011000110";
    regfileReg2(59) <= "101010110011";
    regfileReg2(60) <= "101010100001";
    regfileReg2(61) <= "101010001110";
    regfileReg2(62) <= "101001111100";
    regfileReg2(63) <= "101001101010";
    regfileReg2(64) <= "101001011000";


end architecture;
