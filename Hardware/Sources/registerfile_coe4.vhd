-- Design of registerfile for coefficients

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity registerfilecoe4 is
  generic(
    constant ROW : natural; -- number of words
    constant NOFW : natural); -- 2^NOFW = Number of words in registerfile
  port (
    readAdd : in std_logic_vector(NOFW-1 downto 0);
    dataOut1 : out std_logic_vector(11 downto 0);
    dataOut2 : out std_logic_vector(11 downto 0));

end registerfilecoe4;

architecture structural of registerfilecoe4 is

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
    regfileReg1(0) <= "010000000000";
    regfileReg1(1) <= "010000000000";
    regfileReg1(2) <= "001111111111";
    regfileReg1(3) <= "001111111101";
    regfileReg1(4) <= "001111111011";
    regfileReg1(5) <= "001111111000";
    regfileReg1(6) <= "001111110101";
    regfileReg1(7) <= "001111110001";
    regfileReg1(8) <= "001111101100";
    regfileReg1(9) <= "001111100111";
    regfileReg1(10) <= "001111100001";
    regfileReg1(11) <= "001111011011";
    regfileReg1(12) <= "001111010100";
    regfileReg1(13) <= "001111001100";
    regfileReg1(14) <= "001111000100";
    regfileReg1(15) <= "001110111011";
    regfileReg1(16) <= "001110110010";
    regfileReg1(17) <= "001110101000";
    regfileReg1(18) <= "001110011110";
    regfileReg1(19) <= "001110010011";
    regfileReg1(20) <= "001110000111";
    regfileReg1(21) <= "001101111011";
    regfileReg1(22) <= "001101101110";
    regfileReg1(23) <= "001101100001";
    regfileReg1(24) <= "001101010011";
    regfileReg1(25) <= "001101000101";
    regfileReg1(26) <= "001100110110";
    regfileReg1(27) <= "001100100111";
    regfileReg1(28) <= "001100011000";
    regfileReg1(29) <= "001100000111";
    regfileReg1(30) <= "001011110111";
    regfileReg1(31) <= "001011100110";
    regfileReg1(32) <= "001011010100";


    -- coefficients Imaginary
    regfileReg2(0) <= "000000000000";
    regfileReg2(1) <= "111111100111";
    regfileReg2(2) <= "111111001110";
    regfileReg2(3) <= "111110110101";
    regfileReg2(4) <= "111110011100";
    regfileReg2(5) <= "111110000011";
    regfileReg2(6) <= "111101101010";
    regfileReg2(7) <= "111101010001";
    regfileReg2(8) <= "111100111000";
    regfileReg2(9) <= "111100100000";
    regfileReg2(10) <= "111100000111";
    regfileReg2(11) <= "111011101111";
    regfileReg2(12) <= "111011010111";
    regfileReg2(13) <= "111010111111";
    regfileReg2(14) <= "111010100111";
    regfileReg2(15) <= "111010001111";
    regfileReg2(16) <= "111001111000";
    regfileReg2(17) <= "111001100001";
    regfileReg2(18) <= "111001001010";
    regfileReg2(19) <= "111000110100";
    regfileReg2(20) <= "111000011101";
    regfileReg2(21) <= "111000000111";
    regfileReg2(22) <= "110111110010";
    regfileReg2(23) <= "110111011100";
    regfileReg2(24) <= "110111000111";
    regfileReg2(25) <= "110110110010";
    regfileReg2(26) <= "110110011110";
    regfileReg2(27) <= "110110001010";
    regfileReg2(28) <= "110101110110";
    regfileReg2(29) <= "110101100011";
    regfileReg2(30) <= "110101010000";
    regfileReg2(31) <= "110100111110";
    regfileReg2(32) <= "110100101100";

end architecture;
