-- Design of FIFO top-level
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity FIFO is
  generic (
    constant ROW : natural;-- := 8; -- number of words
    constant COL : natural;-- := 4;  -- wordlength
    constant NOFW : natural);-- := 3); -- 2^NOFW = Number of words in registerfile
  port (
    clk : in std_logic;
    rst : in std_logic;
    writeEn : in std_logic;
    readEn : in std_logic;
    fifoIn : in std_logic_vector(COL-1 downto 0);
    empty : out std_logic;
    full : out std_logic;
    fifoOut : out std_logic_vector(COL-1 downto 0));
end entity;

architecture arch of FIFO is

  component registerfile
  generic(
    constant ROW : natural; -- number of words
    constant COL : natural; -- wordlength
    constant NOFW : natural); -- 2^NOFW = Number of words in registerfile
  port (
    clk : in std_logic;
    rst : in std_logic;
    writeEn : in std_logic;
    --readEn : in std_logic;
    full : in std_logic;
    writeAdd : in std_logic_vector(NOFW-1 downto 0);
    readAdd : in std_logic_vector(NOFW-1 downto 0);
    dataIn : in std_logic_vector(COL-1 downto 0);
    dataOut : out std_logic_vector(COL-1 downto 0));
  end component;

  component fifoctr
  generic (
    constant NOFW : natural); -- 2^NOFW = Number of words in registerfile
  port (
    clk : in std_logic;
    rst : in std_logic;
    writeEn : in std_logic;
    readEn : in std_logic;
    full : out std_logic;
    empty : out std_logic;
    writeAdd : out std_logic_vector(NOFW-1 downto 0);
    readAdd : out std_logic_vector(NOFW-1 downto 0));
  end component;

  -- internal wires
  signal fullWire : std_logic;
  signal writeAddWire, readAddWire : std_logic_vector(NOFW-1 downto 0);

begin
  full <= fullWire;

  unit_registerfile : registerfile
  generic map (ROW=>ROW, COL=>COL, NOFW=>NOFW)
  port map (clk => clk,
            rst => rst,
            writeEn => writeEn,
            full => fullWire,
            writeAdd => writeAddWire,
            readAdd => readAddWire,
            dataIn => fifoIn,
            dataOut => fifoOut);

  unit_ficocontroller : fifoctr
  generic map (NOFW=>NOFW)
  port map (clk => clk,
            rst => rst,
            writeEn => writeEn,
            readEn => readEn,
            full => fullWire,
            empty => empty,
            writeAdd => writeAddWire,
            readAdd => readAddWire);

end architecture;
