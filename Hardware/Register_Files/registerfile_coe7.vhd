-- Design of registerfile for coefficients

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity registerfilecoe7 is
  generic(
    constant ROW : natural; -- number of words
    constant NOFW : natural); -- 2^NOFW = Number of words in registerfile
  port (
    readAdd : in std_logic_vector(NOFW-1 downto 0);
    dataOut1 : out std_logic_vector(11 downto 0);
    dataOut2 : out std_logic_vector(11 downto 0));

end registerfilecoe7;

architecture structural of registerfilecoe7 is

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
    regfileReg1(1) <= "011111011001";
    regfileReg1(2) <= "011101100100";
    regfileReg1(3) <= "011010100111";
    regfileReg1(4) <= "010110101000";


    -- coefficients Imaginary
    regfileReg2(0) <= "000000000000";
    regfileReg2(1) <= "111001110000";
    regfileReg2(2) <= "110011110000";
    regfileReg2(3) <= "101110001110";
    regfileReg2(4) <= "101001011000";


end architecture;
