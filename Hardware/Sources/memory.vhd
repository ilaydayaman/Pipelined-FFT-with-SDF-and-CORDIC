-- Memory for stage 1
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity memory is
  generic (
    constant ROW  : natural;   -- number of words
    constant COL  : natural;   -- wordlength
    constant NOFW : natural);  -- 2^NOFW = Number of words in registerfile
  port (
    clk     : in  std_logic;
    rst     : in  std_logic;
    writeEn : in  std_logic;
    readEn  : in  std_logic;
    dataIn  : in  std_logic_vector(39 downto 0);
    dataOut : out std_logic_vector(39 downto 0));
end entity;

architecture arch of memory is

COMPONENT blk_mem_gen_0
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
    clkb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
  );
END COMPONENT;

  component fifoctr
    generic (
      constant NOFW : natural);
    port (
      clk      : in  std_logic;
      rst      : in  std_logic;
      writeEn  : in  std_logic;
      readEn   : in  std_logic;
      writeAdd : out std_logic_vector(NOFW-1 downto 0);
      readAdd  : out std_logic_vector(NOFW-1 downto 0));
  end component;

  signal writeAddWire, readAddWire : std_logic_vector(NOFW-1 downto 0);
  signal RYxSO1, RYxSO2            : std_logic;

begin

 RAM_inst : blk_mem_gen_0
  PORT MAP (
    clka => clk,
    wea => '1', --write enable
    addra => writeAddWire,
    dina => dataIn,
    douta => douta, --not used
    clkb => clk,
    web => '0', --write enable 
    addrb => readAddWire,
    dinb => dinb, --not used
    doutb => dataOut
  );

  unit_ficocontroller : fifoctr
    generic map (NOFW => NOFW)
    port map (clk      => clk,
              rst      => rst,
              writeEn  => writeEn,
              readEn   => readEn,
              writeAdd => writeAddWire,
              readAdd  => readAddWire);

end architecture;
