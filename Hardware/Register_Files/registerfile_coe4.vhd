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
    regfileReg1(0) <= "011111111111";
    regfileReg1(1) <= "011111111111";
    regfileReg1(2) <= "011111111110";
    regfileReg1(3) <= "011111111010";
    regfileReg1(4) <= "011111110110";
    regfileReg1(5) <= "011111110001";
    regfileReg1(6) <= "011111101010";
    regfileReg1(7) <= "011111100010";
    regfileReg1(8) <= "011111011001";
    regfileReg1(9) <= "011111001110";
    regfileReg1(10) <= "011111000011";
    regfileReg1(11) <= "011110110110";
    regfileReg1(12) <= "011110101000";
    regfileReg1(13) <= "011110011001";
    regfileReg1(14) <= "011110001000";
    regfileReg1(15) <= "011101110111";
    regfileReg1(16) <= "011101100100";
    regfileReg1(17) <= "011101010000";
    regfileReg1(18) <= "011100111011";
    regfileReg1(19) <= "011100100101";
    regfileReg1(20) <= "011100001110";
    regfileReg1(21) <= "011011110110";
    regfileReg1(22) <= "011011011101";
    regfileReg1(23) <= "011011000010";
    regfileReg1(24) <= "011010100111";
    regfileReg1(25) <= "011010001010";
    regfileReg1(26) <= "011001101101";
    regfileReg1(27) <= "011001001111";
    regfileReg1(28) <= "011000101111";
    regfileReg1(29) <= "011000001111";
    regfileReg1(30) <= "010111101101";
    regfileReg1(31) <= "010111001011";
    regfileReg1(32) <= "010110101000";


    -- coefficients Imaginary
    regfileReg2(0) <= "000000000000";
    regfileReg2(1) <= "111111001110";
    regfileReg2(2) <= "111110011100";
    regfileReg2(3) <= "111101101001";
    regfileReg2(4) <= "111100110111";
    regfileReg2(5) <= "111100000101";
    regfileReg2(6) <= "111011010011";
    regfileReg2(7) <= "111010100010";
    regfileReg2(8) <= "111001110000";
    regfileReg2(9) <= "111000111111";
    regfileReg2(10) <= "111000001110";
    regfileReg2(11) <= "110111011110";
    regfileReg2(12) <= "110110101101";
    regfileReg2(13) <= "110101111110";
    regfileReg2(14) <= "110101001110";
    regfileReg2(15) <= "110100011111";
    regfileReg2(16) <= "110011110000";
    regfileReg2(17) <= "110011000010";
    regfileReg2(18) <= "110010010100";
    regfileReg2(19) <= "110001100111";
    regfileReg2(20) <= "110000111011";
    regfileReg2(21) <= "110000001111";
    regfileReg2(22) <= "101111100011";
    regfileReg2(23) <= "101110111000";
    regfileReg2(24) <= "101110001110";
    regfileReg2(25) <= "101101100101";
    regfileReg2(26) <= "101100111100";
    regfileReg2(27) <= "101100010100";
    regfileReg2(28) <= "101011101101";
    regfileReg2(29) <= "101011000110";
    regfileReg2(30) <= "101010100001";
    regfileReg2(31) <= "101001111100";
    regfileReg2(32) <= "101001011000";



end architecture;
