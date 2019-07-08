library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity alu_mem is
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
end alu_mem;

architecture Behavioral of alu_mem is

  component stage1
    generic(
      constant w2   : natural;  -- wordlength output
      constant COL  : natural;  -- wordlength input current stage = wordlength output previous stage
      constant ROW  : natural;  -- number of words
      constant NOFW : natural); -- 2^NOFW = Number of words in registerfile

    port (
      rst            : in  std_logic;
      clk            : in  std_logic;
      T1             : in  std_logic;
      S1             : in  std_logic;
      clkCounter     : in  unsigned (14 downto 0);
      stage1InputRe  : in  std_logic_vector(COL-1 downto 0);
      stage1InputIm  : in  std_logic_vector(COL-1 downto 0);
      stage1OutputRe : out std_logic_vector(w2-1 downto 0);
      stage1OutputIm : out std_logic_vector(w2-1 downto 0)
      );
  end component;

  component stage2
    generic(
      constant w2   : natural;  -- wordlength output
      constant COL  : natural;  -- wordlength input current stage = wordlength output previous stage
      constant ROW  : natural;  -- number of words
      constant NOFW : natural); -- 2^NOFW = Number of words in registerfile
    port (
      rst           : in  std_logic;
      clk           : in  std_logic;
      T             : in  std_logic;
      S             : in  std_logic;
      clkCounter    : in  unsigned (14 downto 0);
      stageInputRe  : in  std_logic_vector(COL-1 downto 0);
      stageInputIm  : in  std_logic_vector(COL-1 downto 0);
      stageOutputRe : out std_logic_vector(w2-1 downto 0);
      stageOutputIm : out std_logic_vector(w2-1 downto 0)
      );
  end component;

  component stage3
    generic(
      constant w2   : natural;  -- wordlength output
      constant COL  : natural;  -- wordlength input current stage = wordlength output previous stage
      constant ROW  : natural;  -- number of words
      constant NOFW : natural); -- 2^NOFW = Number of words in registerfile
    port (
      rst           : in  std_logic;
      clk           : in  std_logic;
      T             : in  std_logic;
      S             : in  std_logic;
      clkCounter    : in  unsigned (14 downto 0);
      stageInputRe  : in  std_logic_vector(COL-1 downto 0);
      stageInputIm  : in  std_logic_vector(COL-1 downto 0);
      stageOutputRe : out std_logic_vector(w2-1 downto 0);
      stageOutputIm : out std_logic_vector(w2-1 downto 0)
      );
  end component;

  component stage4
    generic(
      constant w2   : natural;  -- wordlength output
      constant COL  : natural;  -- wordlength input current stage = wordlength output previous stage
      constant ROW  : natural;  -- number of words
      constant NOFW : natural); -- 2^NOFW = Number of words in registerfile
    port (
      rst           : in  std_logic;
      clk           : in  std_logic;
      T             : in  std_logic;
      S             : in  std_logic;
      clkCounter    : in  unsigned (14 downto 0);
      stageInputRe  : in  std_logic_vector(COL-1 downto 0);
      stageInputIm  : in  std_logic_vector(COL-1 downto 0);
      stageOutputRe : out std_logic_vector(w2-1 downto 0);
      stageOutputIm : out std_logic_vector(w2-1 downto 0)
      );
  end component;

  component stage5
    generic(
      constant w2   : natural;  -- wordlength output
      constant COL  : natural;  -- wordlength input current stage = wordlength output previous stage
      constant ROW  : natural;  -- number of words
      constant NOFW : natural); -- 2^NOFW = Number of words in registerfile
    port (
      rst           : in  std_logic;
      clk           : in  std_logic;
      T             : in  std_logic;
      S             : in  std_logic;
      clkCounter    : in  unsigned (14 downto 0);
      stageInputRe  : in  std_logic_vector(COL-1 downto 0);
      stageInputIm  : in  std_logic_vector(COL-1 downto 0);
      stageOutputRe : out std_logic_vector(w2-1 downto 0);
      stageOutputIm : out std_logic_vector(w2-1 downto 0)
      );
  end component;

  component stage6
    generic(
      constant w2   : natural;  -- wordlength output
      constant COL  : natural;  -- wordlength input current stage = wordlength output previous stage
      constant ROW  : natural;  -- number of words
      constant NOFW : natural); -- 2^NOFW = Number of words in registerfile
    port (
      rst           : in  std_logic;
      clk           : in  std_logic;
      T             : in  std_logic;
      S             : in  std_logic;
      clkCounter    : in  unsigned (14 downto 0);
      stageInputRe  : in  std_logic_vector(COL-1 downto 0);
      stageInputIm  : in  std_logic_vector(COL-1 downto 0);
      stageOutputRe : out std_logic_vector(w2-1 downto 0);
      stageOutputIm : out std_logic_vector(w2-1 downto 0)
      );
  end component;

  component stage7
    generic(
      constant w2   : natural;  -- wordlength output
      constant COL  : natural;  -- wordlength input current stage = wordlength output previous stage
      constant ROW  : natural;  -- number of words
      constant NOFW : natural); -- 2^NOFW = Number of words in registerfile
    port (
      rst           : in  std_logic;
      clk           : in  std_logic;
      T             : in  std_logic;
      S             : in  std_logic;
      clkCounter    : in  unsigned (14 downto 0);
      stageInputRe  : in  std_logic_vector(COL-1 downto 0);
      stageInputIm  : in  std_logic_vector(COL-1 downto 0);
      stageOutputRe : out std_logic_vector(w2-1 downto 0);
      stageOutputIm : out std_logic_vector(w2-1 downto 0)
      );
  end component;

  component stage8
    generic(
      constant w2   : natural;  -- wordlength output
      constant COL  : natural;  -- wordlength input current stage = wordlength output previous stage
      constant ROW  : natural;  -- number of words
      constant NOFW : natural); -- 2^NOFW = Number of words in registerfile
    port (
      rst           : in  std_logic;
      clk           : in  std_logic;
      T             : in  std_logic;
      S             : in  std_logic;
      clkCounter    : in  unsigned (14 downto 0);
      stageInputRe  : in  std_logic_vector(COL-1 downto 0);
      stageInputIm  : in  std_logic_vector(COL-1 downto 0);
      stageOutputRe : out std_logic_vector(w2-1 downto 0);
      stageOutputIm : out std_logic_vector(w2-1 downto 0)
      );
  end component;

  component stage9
    generic(
      constant w2   : natural;  -- wordlength output
      constant COL  : natural;  -- wordlength input current stage = wordlength output previous stage
      constant ROW  : natural;  -- number of words
      constant NOFW : natural); -- 2^NOFW = Number of words in registerfile
    port (
      rst           : in  std_logic;
      clk           : in  std_logic;
      T             : in  std_logic;
      S             : in  std_logic;
      clkCounter    : in  unsigned (14 downto 0);
      stageInputRe  : in  std_logic_vector(COL-1 downto 0);
      stageInputIm  : in  std_logic_vector(COL-1 downto 0);
      stageOutputRe : out std_logic_vector(w2-1 downto 0);
      stageOutputIm : out std_logic_vector(w2-1 downto 0)
      );
  end component;

  component stage10
    generic(
      constant w2   : natural;  -- wordlength output
      constant COL  : natural;  -- wordlength input current stage = wordlength output previous stage
      constant ROW  : natural;  -- number of words
      constant NOFW : natural); -- 2^NOFW = Number of words in registerfile
    port (
      rst           : in  std_logic;
      clk           : in  std_logic;
      T             : in  std_logic;
      S             : in  std_logic;
      clkCounter    : in  unsigned (14 downto 0);
      stageInputRe  : in  std_logic_vector(COL-1 downto 0);
      stageInputIm  : in  std_logic_vector(COL-1 downto 0);
      stageOutputRe : out std_logic_vector(w2-1 downto 0);
      stageOutputIm : out std_logic_vector(w2-1 downto 0)
      );
  end component;

  component stage11
    generic(
      constant w2   : natural;  -- wordlength output
      constant COL  : natural;  -- wordlength input current stage = wordlength output previous stage
      constant ROW  : natural;  -- number of words
      constant NOFW : natural); -- 2^NOFW = Number of words in registerfile
    port (
      rst           : in  std_logic;
      clk           : in  std_logic;
      T             : in  std_logic;
      S             : in  std_logic;
      stageInputRe  : in  std_logic_vector(COL-1 downto 0);
      stageInputIm  : in  std_logic_vector(COL-1 downto 0);
      stageOutputRe : out std_logic_vector(w2-1 downto 0);
      stageOutputIm : out std_logic_vector(w2-1 downto 0)
      );
  end component;

  signal stage1InputRe, stage1InputIm   : std_logic_vector(11 downto 0);
  signal stage2InputRe, stage2InputIm   : std_logic_vector(11 downto 0);
  signal stage3InputRe, stage3InputIm   : std_logic_vector(12 downto 0);
  signal stage4InputRe, stage4InputIm   : std_logic_vector(13 downto 0);
  signal stage5InputRe, stage5InputIm   : std_logic_vector(13 downto 0);
  signal stage6InputRe, stage6InputIm   : std_logic_vector(14 downto 0);
  signal stage7InputRe, stage7InputIm   : std_logic_vector(14 downto 0);
  signal stage8InputRe, stage8InputIm   : std_logic_vector(15 downto 0);
  signal stage9InputRe, stage9InputIm   : std_logic_vector(15 downto 0);
  signal stage10InputRe, stage10InputIm : std_logic_vector(15 downto 0);
  signal stage11InputRe, stage11InputIm : std_logic_vector(15 downto 0);

  signal stageOutputRe, stageOutputIm : std_logic_vector(11 downto 0);

begin

  process (modeSelectFftIfft, externalInputIm, externalInputRe, stageOutputRe, stageOutputIm)
  begin
    if(modeSelectFftIfft = '0') then
      stage1InputRe    <= externalInputRe;
      stage1InputIm    <= externalInputIm;
      ExternalOutputRe <= stageOutputRe;
      ExternalOutputIm <= stageOutputIm;
    else
      stage1InputRe    <= externalInputIm;
      stage1InputIm    <= externalInputRe;
      ExternalOutputRe <= stageOutputIm;
      ExternalOutputIm <= stageOutputRe;
    end if;
  end process;


  stage_1 : stage1
    generic map (
      w2   => 12,  -- wordlength output
      COL  => 12,  -- wordlength input current stage = wordlength output previous stage
      ROW  => 1024,-- number of words
      NOFW => 10)
    port map(
      rst            => rst,
      clk            => clk,
      T1             => T1,
      S1             => S1,
      clkCounter     => clkCounter,
      stage1InputRe  => stage1InputRe,
      stage1InputIm  => stage1InputIm,
      stage1OutputRe => stage2InputRe,
      stage1OutputIm => stage2InputIm);

  stage_2 : stage2
    generic map (
      w2   => 13,  -- wordlength output
      COL  => 12,  -- wordlength input current stage = wordlength output previous stage
      ROW  => 512, -- number of words
      NOFW => 9)   -- 2^NOFW = Number of words in registerfile
    port map(
      rst           => rst,
      clk           => clk,
      T             => T2,
      S             => S2,
      clkCounter    => clkCounter,
      stageInputRe  => stage2InputRe,
      stageInputIm  => stage2InputIm,
      stageOutputRe => stage3InputRe,
      stageOutputIm => stage3InputIm);

  stage_3 : stage3
    generic map (
      w2   => 14,  -- wordlength output
      COL  => 13,  -- wordlength input current stage = wordlength output previous stage
      ROW  => 256, -- number of words
      NOFW => 8)   -- 2^NOFW = Number of words in registerfile
    port map(
      rst           => rst,
      clk           => clk,
      T             => T3,
      S             => S3,
      clkCounter    => clkCounter,
      stageInputRe  => stage3InputRe,
      stageInputIm  => stage3InputIm,
      stageOutputRe => stage4InputRe,
      stageOutputIm => stage4InputIm);

  stage_4 : stage4
    generic map (
      w2   => 14,  -- wordlength output
      COL  => 14,  -- wordlength input current stage = wordlength output previous stage
      ROW  => 128, -- number of words
      NOFW => 7)   -- 2^NOFW = Number of words in registerfile
    port map(
      rst           => rst,
      clk           => clk,
      T             => T4,
      S             => S4,
      clkCounter    => clkCounter,
      stageInputRe  => stage4InputRe,
      stageInputIm  => stage4InputIm,
      stageOutputRe => stage5InputRe,
      stageOutputIm => stage5InputIm);

  stage_5 : stage5
    generic map (
      w2   => 15,  -- wordlength output
      COL  => 14,  -- wordlength input current stage = wordlength output previous stage
      ROW  => 64,  -- number of words
      NOFW => 6)   -- 2^NOFW = Number of words in registerfile
    port map(
      rst           => rst,
      clk           => clk,
      T             => T5,
      S             => S5,
      clkCounter    => clkCounter,
      stageInputRe  => stage5InputRe,
      stageInputIm  => stage5InputIm,
      stageOutputRe => stage6InputRe,
      stageOutputIm => stage6InputIm);

  stage_6 : stage6
    generic map (
      w2   => 15,  -- wordlength output
      COL  => 15,  -- wordlength input current stage = wordlength output previous stage
      ROW  => 32,  -- number of words
      NOFW => 5)   -- 2^NOFW = Number of words in registerfile
    port map(
      rst           => rst,
      clk           => clk,
      T             => T6,
      S             => S6,
      clkCounter    => clkCounter,
      stageInputRe  => stage6InputRe,
      stageInputIm  => stage6InputIm,
      stageOutputRe => stage7InputRe,
      stageOutputIm => stage7InputIm);

  stage_7 : stage7
    generic map (
      w2   => 16,  -- wordlength output
      COL  => 15,  -- wordlength input current stage = wordlength output previous stage
      ROW  => 16,  -- number of words
      NOFW => 4)   -- 2^NOFW = Number of words in registerfile
    port map(
      rst           => rst,
      clk           => clk,
      T             => T7,
      S             => S7,
      clkCounter    => clkCounter,
      stageInputRe  => stage7InputRe,
      stageInputIm  => stage7InputIm,
      stageOutputRe => stage8InputRe,
      stageOutputIm => stage8InputIm);


  stage_8 : stage8
    generic map (
      w2   => 16,  -- wordlength output
      COL  => 16,  -- wordlength input current stage = wordlength output previous stage
      ROW  => 8,   -- number of words
      NOFW => 3)   -- 2^NOFW = Number of words in registerfile
    port map(
      rst           => rst,
      clk           => clk,
      T             => T8,
      S             => S8,
      clkCounter    => clkCounter,
      stageInputRe  => stage8InputRe,
      stageInputIm  => stage8InputIm,
      stageOutputRe => stage9InputRe,
      stageOutputIm => stage9InputIm);

  stage_9 : stage9
    generic map (
      w2   => 16,  -- wordlength output
      COL  => 16,  -- wordlength input current stage = wordlength output previous stage
      ROW  => 4,   -- number of words
      NOFW => 2)   -- 2^NOFW = Number of words in registerfile
    port map(
      rst           => rst,
      clk           => clk,
      T             => T9,
      S             => S9,
      clkCounter    => clkCounter,
      stageInputRe  => stage9InputRe,
      stageInputIm  => stage9InputIm,
      stageOutputRe => stage10InputRe,
      stageOutputIm => stage10InputIm);

  stage_10 : stage10
    generic map (
      w2   => 16,  -- wordlength output
      COL  => 16,  -- wordlength input current stage = wordlength output previous stage
      ROW  => 2,   -- number of words
      NOFW => 1)   -- 2^NOFW = Number of words in registerfile
    port map(
      rst           => rst,
      clk           => clk,
      T             => T10,
      S             => S10,
      clkCounter    => clkCounter,
      stageInputRe  => stage10InputRe,
      stageInputIm  => stage10InputIm,
      stageOutputRe => stage11InputRe,
      stageOutputIm => stage11InputIm);

  stage_11 : stage11
    generic map (
      w2   => 12,  -- wordlength output
      COL  => 16,  -- wordlength input current stage = wordlength output previous stage
      ROW  => 1,   -- number of words
      NOFW => 0)   -- 2^NOFW = Number of words in registerfile
    port map(
      rst           => rst,
      clk           => clk,
      T             => T11,
      S             => S11,
      stageInputRe  => stage11InputRe,
      stageInputIm  => stage11InputIm,
      stageOutputRe => stageOutputRe,
      stageOutputIm => stageOutputIm);

end Behavioral;
