library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_mem is
    generic ( STATE : integer := 11 );
    Port ( 
         rst : in STD_LOGIC;
         clk : in STD_LOGIC;
         T1  : in STD_LOGIC;
         T2  : in STD_LOGIC;
         T3  : in STD_LOGIC;
         T4  : in STD_LOGIC;
         T5  : in STD_LOGIC;
         T6  : in STD_LOGIC;
         T7  : in STD_LOGIC;
         T8  : in STD_LOGIC;
         T9  : in STD_LOGIC;
         T10 : in STD_LOGIC;
         T11 : in STD_LOGIC;
         S1  : in STD_LOGIC;
         S2  : in STD_LOGIC;
         S3  : in STD_LOGIC;
         S4  : in STD_LOGIC;
         S5  : in STD_LOGIC;
         S6  : in STD_LOGIC;
         S7  : in STD_LOGIC;
         S8  : in STD_LOGIC;
         S9  : in STD_LOGIC;
         S10 : in STD_LOGIC;
         S11 : in STD_LOGIC;
         externalInput : in std_logic_vector(11 downto 0);
         externalOutput : out std_logic_vector(11 downto 0)
         );
end alu_mem;

architecture Behavioral of alu_mem is

component myButterfly
    generic(
             w1 : integer := 12
             );
    Port( 
         n1 : in signed( (w1-1) downto 0);
         n2 : in signed( (w1-1) downto 0);
         sumOut : out signed( (w1-1) downto 0);
         subOut : out signed( (w1-1) downto 0)
         );
end component;

component complexMult
    generic( 
            w1 : integer := 12;
            w2 : integer := 13
            );
    port(
          clk       : in  std_logic;
          rst       : in  std_logic; 
          multInRe  : in signed( (w1-1) downto 0);
          multInIm  : in signed( (w1-1) downto 0);
          coeffRe   : in signed( (w1-1) downto 0);
          coeffIm   : in signed( (w1-1) downto 0);
          multOutRe : out signed( (w2-1) downto 0);
          multOutIm : out signed( (w2-1) downto 0)
        );
end component;

component FIFO
  generic (
        constant ROW  : natural := 8; -- number of words
        constant COL  : natural := 4;  -- wordlength
        constant NOFW : natural := 3
        ); -- 2^NOFW = Number of words in registerfile
  port (
        clk     : in std_logic;
        rst     : in std_logic;
        writeEn : in std_logic;
        readEn  : in std_logic;
        fifoIn  : in std_logic_vector(COL-1 downto 0);
        empty   : out std_logic;
        full    : out std_logic;
        fifoOut : out std_logic_vector(COL-1 downto 0)
        );
end component;

signal n1, n2 : signed( 11 downto 0);
signal sumOut,subOut :  signed( 11 downto 0);
signal multInRe, multInIm : signed( 11 downto 0);
signal coeffRe, coeffIm : signed( 11 downto 0);
signal multOutRe, multOutIm : signed( 12 downto 0);

--FIFO definitions
constant ROW  : natural := 8; -- number of words
constant COL  : natural := 4;  -- wordlength
constant NOFW : natural := 3;

signal writeEn : std_logic;
signal readEn  : std_logic;
signal fifoIn  : std_logic_vector(COL-1 downto 0);
signal empty   : std_logic;
signal full    : std_logic;
signal fifoOut : std_logic_vector(COL-1 downto 0);

begin


myButterfly_Inst : myButterfly
    generic map ( 
            w1 => 12
            ) 
    port map(
            n1 => n1,
            n2 => n2,
            sumOut => sumOut,
            subOut => subOut
            );

complexMult_Inst : complexMult
    generic map ( 
            w1 => 12,
            w2 => 13
            )
    port map(
            clk     => clk,
            rst     => rst,
            multInRe  => multInRe,
            multInIm  => multInIm,
            coeffRe   => coeffRe,
            coeffIm   => coeffIm,
            multOutRe => multOutRe,
            multOutIm => multOutIm
            );

  FIFO_Inst : FIFO
    generic map ( 
            ROW => ROW,
            COL => COL,
            NOFW => NOFW
            )
    port map(  
            clk     => clk,
            rst     => rst,
            writeEn => writeEn,
            readEn  => readEn,
            fifoIn  => fifoIn,
            empty   => empty,
            full    => full,
            fifoOut => fifoOut
            );     
end Behavioral;
