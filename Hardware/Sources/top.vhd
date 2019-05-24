library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           modeSelectFftIfft : in STD_LOGIC;
           --coefficients      : in std_logic_vector(11 downto 0);
           externalInputRe   : in std_logic_vector(11 downto 0);
           externalInputIm   : in std_logic_vector(11 downto 0);
	       validOutput	     : out STD_LOGIC;
           externalOutputRe  : out std_logic_vector(11 downto 0);
           externalOutputIm  : out std_logic_vector(11 downto 0));
end top;

architecture Behavioral of top is

component Control_Unit is
    --generic ( STATE : integer := 4 );
    port (
        clk    : in STD_LOGIC;
        rst    : in STD_LOGIC; 
        --readEn : in STD_LOGIC; 
        T1     : out STD_LOGIC;
        T2     : out STD_LOGIC;
        T3     : out STD_LOGIC;
        T4     : out STD_LOGIC;
        T5     : out STD_LOGIC;
        T6     : out STD_LOGIC;
        T7     : out STD_LOGIC;
        T8     : out STD_LOGIC;
        T9     : out STD_LOGIC;
        T10    : out STD_LOGIC;
        T11    : out STD_LOGIC;
        S1     : out STD_LOGIC;
        S2     : out STD_LOGIC;
        S3     : out STD_LOGIC;
        S4     : out STD_LOGIC;
        S5     : out STD_LOGIC;
        S6     : out STD_LOGIC;
        S7     : out STD_LOGIC;
        S8     : out STD_LOGIC;
        S9     : out STD_LOGIC;
        S10    : out STD_LOGIC;
        S11    : out STD_LOGIC;
        clkCounter : out unsigned (14 downto 0)
      );
  end component;

component alu_mem is
    --generic ( STATE : integer := 4 );
    port (
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
      modeSelectFftIfft : in STD_LOGIC;
      clkCounter : in unsigned (14 downto 0);
      externalInputRe  : in std_logic_vector(11 downto 0);
      externalInputIm  : in std_logic_vector(11 downto 0);
      --readEn : out STD_LOGIC; 
      externalOutputRe : out std_logic_vector(11 downto 0);
      externalOutputIm : out std_logic_vector(11 downto 0)
      );
  end component;

-- signal declerations
signal T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11 : std_logic;
signal S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11 : std_logic;
signal clkCounter : unsigned (14 downto 0);
signal modeSelectFftIfftWire : std_logic;
--signal readEn : std_logic;

begin

modeSelectFftIfftWire <= '0';

ControlUnitInst : Control_Unit
    --generic map ( STATE => 4 )
    port map(  
      clk => clk,
      rst => rst,
      T1  => T1,
      T2  => T2,
      T3  => T3,
      T4  => T4,
      T5  => T5,
      T6  => T6,
      T7  => T7,
      T8  => T8,
      T9  => T9,
      T10 => T10,
      T11 => T11,
      S1  => S1,
      S2  => S2,
      S3  => S3,
      S4  => S4,
      S5  => S5,
      S6  => S6,
      S7  => S7,
      S8  => S8,
      S9  => S9,
      S10 => S10,
      S11 => S11,
      --readEn => readEn,
      clkCounter     => clkCounter
      );


ALU_MEM_UnitInst : alu_mem
    port map(
      clk            => clk,
      rst            => rst,
      T1             => T1,
      T2             => T2,
      T3             => T3,
      T4             => T4,
      T5             => T5,
      T6             => T6,
      T7             => T7,
      T8             => T8,
      T9             => T9,
      T10            => T10,
      T11            => T11,
      S1             => S1,
      S2             => S2,
      S3             => S3,
      S4             => S4,
      S5             => S5,
      S6             => S6,
      S7             => S7,
      S8             => S8,
      S9             => S9,
      S10            => S10,
      S11            => S11,
      clkCounter     => clkCounter,
      modeSelectFftIfft=> modeSelectFftIfftWire,
      externalInputRe  => externalInputRe,
      externalInputIm  => externalInputIm,      
      --readEn           => readEn,
      externalOutputRe => externalOutputRe,
      externalOutputIm => externalOutputIm
      );
      
    validOutput <= '1' when (clkCounter = 2078) else '0'; 

end Behavioral;
