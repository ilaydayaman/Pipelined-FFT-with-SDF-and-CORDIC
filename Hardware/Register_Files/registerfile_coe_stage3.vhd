-- Design of registerfile for coefficients

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity coeRegisterfile is
  generic(
    constant ROW : natural; -- number of words
    constant COL : natural; -- wordlength
    constant NOFW : natural); -- 2^NOFW = Number of words in registerfile
  port (
    readAdd1 : in std_logic_vector(NOFW-1 downto 0);
    readAdd2 : in std_logic_vector(NOFW-1 downto 0);
    dataOut1 : out std_logic_vector(COL-1 downto 0);
    dataOut2 : out std_logic_vector(COL-1 downto 0));

end entity;

architecture structural of coeRegisterfile is

  type registerfile is array (ROW-1 downto 0) of std_logic_vector(COL-1 downto 0); -- registerfile of size ROW x COL
  signal regfileReg1, regfileReg2 : registerfile;

  signal readPtr1 : unsigned(NOFW-1 downto 0);
  signal readPtr2 : unsigned(NOFW-1 downto 0);

begin

    -- address conversion
    readPtr1 <= (unsigned(readAdd1));
    readPtr2 <= (unsigned(readAdd2));

    -- output logic
    dataOut1 <= regfileReg1(to_integer(readPtr1));
    dataOut2 <= regfileReg2(to_integer(readPtr2));

    -- coefficients Real
    regfileReg1(0) <= "010000000000";
    regfileReg1(1) <= "010000000000";
    regfileReg1(2) <= "010000000000";
    regfileReg1(3) <= "001111111111";
    regfileReg1(4) <= "001111111111";
    regfileReg1(5) <= "001111111110";
    regfileReg1(6) <= "001111111101";
    regfileReg1(7) <= "001111111100";
    regfileReg1(8) <= "001111111011";
    regfileReg1(9) <= "001111111010";
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

    -- coefficients Imaginary
    regfileReg2(0) <= "000000000000";
    regfileReg2(1) <= "100000001101";
    regfileReg2(2) <= "100000011001";
    regfileReg2(3) <= "100000100110";
    regfileReg2(4) <= "100000110010";
    regfileReg2(5) <= "100000111111";
    regfileReg2(6) <= "100001001011";
    regfileReg2(7) <= "100001011000";
    regfileReg2(8) <= "100001100100";
    regfileReg2(9) <= "100001110001";
    regfileReg2(10) <= "100001111101";
    regfileReg2(11) <= "100010001010";
    regfileReg2(12) <= "100010010110";
    regfileReg2(13) <= "100010100011";
    regfileReg2(14) <= "100010101111";
    regfileReg2(15) <= "100010111011";
    regfileReg2(16) <= "100011001000";
    regfileReg2(17) <= "100011010100";
    regfileReg2(18) <= "100011100000";
    regfileReg2(19) <= "100011101101";
    regfileReg2(20) <= "100011111001";
    regfileReg2(21) <= "100100000101";
    regfileReg2(22) <= "100100010001";
    regfileReg2(23) <= "100100011101";
    regfileReg2(24) <= "100100101001";
    regfileReg2(25) <= "100100110101";
    regfileReg2(26) <= "100101000001";
    regfileReg2(27) <= "100101001101";
    regfileReg2(28) <= "100101011001";
    regfileReg2(29) <= "100101100101";
    regfileReg2(30) <= "100101110001";
    regfileReg2(31) <= "100101111100";
    regfileReg2(32) <= "100110001000";
    regfileReg2(33) <= "100110010011";
    regfileReg2(34) <= "100110011111";
    regfileReg2(35) <= "100110101010";
    regfileReg2(36) <= "100110110110";
    regfileReg2(37) <= "100111000001";
    regfileReg2(38) <= "100111001100";
    regfileReg2(39) <= "100111011000";
    regfileReg2(40) <= "100111100011";
    regfileReg2(41) <= "100111101110";
    regfileReg2(42) <= "100111111001";
    regfileReg2(43) <= "101000000100";
    regfileReg2(44) <= "101000001110";
    regfileReg2(45) <= "101000011001";
    regfileReg2(46) <= "101000100100";
    regfileReg2(47) <= "101000101110";
    regfileReg2(48) <= "101000111001";
    regfileReg2(49) <= "101001000011";
    regfileReg2(50) <= "101001001110";
    regfileReg2(51) <= "101001011000";
    regfileReg2(52) <= "101001100010";
    regfileReg2(53) <= "101001101100";
    regfileReg2(54) <= "101001110110";
    regfileReg2(55) <= "101010000000";
    regfileReg2(56) <= "101010001010";
    regfileReg2(57) <= "101010010011";
    regfileReg2(58) <= "101010011101";
    regfileReg2(59) <= "101010100110";
    regfileReg2(60) <= "101010110000";
    regfileReg2(61) <= "101010111001";
    regfileReg2(62) <= "101011000010";
    regfileReg2(63) <= "101011001011";
  
end architecture;
