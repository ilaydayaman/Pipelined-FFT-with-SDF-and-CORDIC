library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity top is
  port (rst                : in  std_logic;
         clk               : in  std_logic;
         modeSelectFftIfft : in  std_logic;
         externalInputRe   : in  std_logic_vector(11 downto 0);
         externalInputIm   : in  std_logic_vector(11 downto 0);
         validOutput       : out std_logic;
         externalOutputRe  : out std_logic_vector(11 downto 0);
         externalOutputIm  : out std_logic_vector(11 downto 0));
end top;

architecture Behavioral of top is

  component Control_Unit is
    port (
      clk        : in  std_logic;
      rst        : in  std_logic;
      T1         : out std_logic;
      T2         : out std_logic;
      T3         : out std_logic;
      T4         : out std_logic;
      T5         : out std_logic;
      T6         : out std_logic;
      T7         : out std_logic;
      T8         : out std_logic;
      T9         : out std_logic;
      T10        : out std_logic;
      T11        : out std_logic;
      S1         : out std_logic;
      S2         : out std_logic;
      S3         : out std_logic;
      S4         : out std_logic;
      S5         : out std_logic;
      S6         : out std_logic;
      S7         : out std_logic;
      S8         : out std_logic;
      S9         : out std_logic;
      S10        : out std_logic;
      S11        : out std_logic;
      clkCounter : out unsigned (14 downto 0)
      );
  end component;

  component alu_mem is
    port (
      rst               : in  std_logic;
      clk               : in  std_logic;
      T1                : in  std_logic;
      T2                : in  std_logic;
      T3                : in  std_logic;
      T4                : in  std_logic;
      T5                : in  std_logic;
      T6                : in  std_logic;
      T7                : in  std_logic;
      T8                : in  std_logic;
      T9                : in  std_logic;
      T10               : in  std_logic;
      T11               : in  std_logic;
      S1                : in  std_logic;
      S2                : in  std_logic;
      S3                : in  std_logic;
      S4                : in  std_logic;
      S5                : in  std_logic;
      S6                : in  std_logic;
      S7                : in  std_logic;
      S8                : in  std_logic;
      S9                : in  std_logic;
      S10               : in  std_logic;
      S11               : in  std_logic;
      modeSelectFftIfft : in  std_logic;
      clkCounter        : in  unsigned (14 downto 0);
      externalInputRe   : in  std_logic_vector(11 downto 0);
      externalInputIm   : in  std_logic_vector(11 downto 0);
      externalOutputRe  : out std_logic_vector(11 downto 0);
      externalOutputIm  : out std_logic_vector(11 downto 0)
      );
  end component;

  component CPAD_S_74x50u_IN            --input PAD
    port (
      COREIO : out std_logic;
      PADIO  : in  std_logic);
  end component;

  component CPAD_S_74x50u_OUT           --output PAD
    port (
      COREIO : in  std_logic;
      PADIO  : out std_logic);
  end component;

-- signal declerations
  signal T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11 : std_logic;
  signal S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11 : std_logic;
  signal clkCounter                                   : unsigned (14 downto 0);
  signal rsti                                         : std_logic;
  signal clki                                         : std_logic;
  signal modeSelectFftIffti                           : std_logic;
  signal externalInputRei                             : std_logic_vector(11 downto 0);
  signal externalInputImi                             : std_logic_vector(11 downto 0);
  signal validOutputi                                 : std_logic;
  signal externalOutputRei                            : std_logic_vector(11 downto 0);
  signal externalOutputImi                            : std_logic_vector(11 downto 0);


begin


  clkpad : CPAD_S_74x50u_IN
    port map (
      COREIO => clki,
      PADIO  => clk);

  rstpad : CPAD_S_74x50u_IN
    port map (
      COREIO => rsti,
      PADIO  => rst);

  modeSelectFftIfftPad : CPAD_S_74x50u_IN
    port map (
      COREIO => modeSelectFftIffti,
      PADIO  => modeSelectFftIfft);

  externalInputRePads : for i in 0 to 11 generate
    externalInputRePad : CPAD_S_74x50u_IN
      port map (
        COREIO => externalInputRei(i),
        PADIO  => externalInputRe(i)); 
  end generate externalInputRePads;

  externalInputImPads : for i in 0 to 11 generate
    externalInputImPad : CPAD_S_74x50u_IN
      port map (
        COREIO => externalInputImi(i),
        PADIO  => externalInputIm(i)); 
  end generate externalInputImPads;

  externalOutputRePads : for i in 0 to 11 generate
    externalOutputRePad : CPAD_S_74x50u_OUT
      port map (
        PADIO  => externalOutputRe(i),
        COREIO => externalOutputRei(i)); 
  end generate externalOutputRePads;

  externalOutputImPads : for i in 0 to 11 generate
    externalOutputImPad : CPAD_S_74x50u_OUT
      port map (
        PADIO  => externalOutputIm(i),
        COREIO => externalOutputImi(i)); 
  end generate externalOutputImPads;

  validOutputPad : CPAD_S_74x50u_OUT
    port map (
      PADIO  => validOutput,
      COREIO => validOutputi);

  ControlUnitInst : Control_Unit
    port map(
      clk        => clki,
      rst        => rsti,
      T1         => T1,
      T2         => T2,
      T3         => T3,
      T4         => T4,
      T5         => T5,
      T6         => T6,
      T7         => T7,
      T8         => T8,
      T9         => T9,
      T10        => T10,
      T11        => T11,
      S1         => S1,
      S2         => S2,
      S3         => S3,
      S4         => S4,
      S5         => S5,
      S6         => S6,
      S7         => S7,
      S8         => S8,
      S9         => S9,
      S10        => S10,
      S11        => S11,
      clkCounter => clkCounter
      );

  ALU_MEM_UnitInst : alu_mem
    port map(
      clk               => clki,
      rst               => rsti,
      T1                => T1,
      T2                => T2,
      T3                => T3,
      T4                => T4,
      T5                => T5,
      T6                => T6,
      T7                => T7,
      T8                => T8,
      T9                => T9,
      T10               => T10,
      T11               => T11,
      S1                => S1,
      S2                => S2,
      S3                => S3,
      S4                => S4,
      S5                => S5,
      S6                => S6,
      S7                => S7,
      S8                => S8,
      S9                => S9,
      S10               => S10,
      S11               => S11,
      clkCounter        => clkCounter,
      modeSelectFftIfft => modeSelectFftIffti,
      externalInputRe   => externalInputRei,
      externalInputIm   => externalInputImi,
      externalOutputRe  => externalOutputRei,
      externalOutputIm  => externalOutputImi
      );

  validOutputi <= '1' when (clkCounter = 2079) else '0';

end Behavioral;
