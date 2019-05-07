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

    -- coefficients Imaginary
    regfileReg2(0) <= "000000000000";
    regfileReg2(1) <= "100000011001";
    regfileReg2(2) <= "100000110010";
    regfileReg2(3) <= "100001001011";
    regfileReg2(4) <= "100001100100";
    regfileReg2(5) <= "100001111101";
    regfileReg2(6) <= "100010010110";
    regfileReg2(7) <= "100010101111";
    regfileReg2(8) <= "100011001000";
    regfileReg2(9) <= "100011100000";
    regfileReg2(10) <= "100011111001";
    regfileReg2(11) <= "100100010001";
    regfileReg2(12) <= "100100101001";
    regfileReg2(13) <= "100101000001";
    regfileReg2(14) <= "100101011001";
    regfileReg2(15) <= "100101110001";
    regfileReg2(16) <= "100110001000";
    regfileReg2(17) <= "100110011111";
    regfileReg2(18) <= "100110110110";
    regfileReg2(19) <= "100111001100";
    regfileReg2(20) <= "100111100011";
    regfileReg2(21) <= "100111111001";
    regfileReg2(22) <= "101000001110";
    regfileReg2(23) <= "101000100100";
    regfileReg2(24) <= "101000111001";
    regfileReg2(25) <= "101001001110";
    regfileReg2(26) <= "101001100010";
    regfileReg2(27) <= "101001110110";
    regfileReg2(28) <= "101010001010";
    regfileReg2(29) <= "101010011101";
    regfileReg2(30) <= "101010110000";
    regfileReg2(31) <= "101011000010";
  
end architecture;
