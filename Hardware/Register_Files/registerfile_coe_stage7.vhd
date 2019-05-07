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
    regfileReg1(1) <= "001111101100";
    regfileReg1(2) <= "001110110010";
    regfileReg1(3) <= "001101010011";

    -- coefficients Imaginary
    regfileReg2(0) <= "000000000000";
    regfileReg2(1) <= "100011001000";
    regfileReg2(2) <= "100110001000";
    regfileReg2(3) <= "101000111001";
  
end architecture;
