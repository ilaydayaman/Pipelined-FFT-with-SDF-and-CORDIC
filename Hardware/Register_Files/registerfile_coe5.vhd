-- Design of registerfile for coefficients

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity registerfilecoe5 is
  generic(
    constant ROW : natural; -- number of words
    constant NOFW : natural); -- 2^NOFW = Number of words in registerfile
  port (
    readAdd : in std_logic_vector(NOFW-1 downto 0);
    dataOut1 : out std_logic_vector(11 downto 0);
    dataOut2 : out std_logic_vector(11 downto 0));

end registerfilecoe5;

architecture structural of registerfilecoe5 is

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
    regfileReg1(1) <= "011111111110";
    regfileReg1(2) <= "011111110110";
    regfileReg1(3) <= "011111101010";
    regfileReg1(4) <= "011111011001";
    regfileReg1(5) <= "011111000011";
    regfileReg1(6) <= "011110101000";
    regfileReg1(7) <= "011110001000";
    regfileReg1(8) <= "011101100100";
    regfileReg1(9) <= "011100111011";
    regfileReg1(10) <= "011100001110";
    regfileReg1(11) <= "011011011101";
    regfileReg1(12) <= "011010100111";
    regfileReg1(13) <= "011001101101";
    regfileReg1(14) <= "011000101111";
    regfileReg1(15) <= "010111101101";
    regfileReg1(16) <= "010110101000";

    -- coefficients Imaginary
    regfileReg2(0) <= "000000000000";
    regfileReg2(1) <= "111110011100";
    regfileReg2(2) <= "111100110111";
    regfileReg2(3) <= "111011010011";
    regfileReg2(4) <= "111001110000";
    regfileReg2(5) <= "111000001110";
    regfileReg2(6) <= "110110101101";
    regfileReg2(7) <= "110101001110";
    regfileReg2(8) <= "110011110000";
    regfileReg2(9) <= "110010010100";
    regfileReg2(10) <= "110000111011";
    regfileReg2(11) <= "101111100011";
    regfileReg2(12) <= "101110001110";
    regfileReg2(13) <= "101100111100";
    regfileReg2(14) <= "101011101101";
    regfileReg2(15) <= "101010100001";
    regfileReg2(16) <= "101001011000";


end architecture;
