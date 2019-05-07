library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_mem is
    --generic ( STATE : integer := 11 );
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
         --readAdd1 : std_logic_vector(9 downto 0);
         externalInputRe  : in std_logic_vector(11 downto 0);
         externalInputIm  : in std_logic_vector(11 downto 0);
         externalOutputRe : out std_logic_vector(11 downto 0);
         externalOutputIm : out std_logic_vector(11 downto 0)
         );
end alu_mem;

architecture Behavioral of alu_mem is

  component stage1
  Port (
       rst : in STD_LOGIC;
       clk : in STD_LOGIC;
       T1  : in STD_LOGIC;
       S1  : in STD_LOGIC;
       --readAdd : in std_logic_vector(9 downto 0);
       stage1InputRe : in std_logic_vector(11 downto 0);
       stage1InputIm : in std_logic_vector(11 downto 0);
       stage1OutputRe : out std_logic_vector(12 downto 0);
       stage1OutputIm : out std_logic_vector(12 downto 0)
       );
  end component;

  signal stage2InputRe,stage2InputIm : std_logic_vector(12 downto 0);
  signal stage3InputRe,stage3InputIm : std_logic_vector(11 downto 0);
  signal stage4InputRe,stage4InputIm : std_logic_vector(11 downto 0);
  signal stage5InputRe,stage5InputIm : std_logic_vector(11 downto 0);
  signal stage6InputRe,stage6InputIm : std_logic_vector(11 downto 0);
  signal stage7InputRe,stage7InputIm : std_logic_vector(11 downto 0);
  signal stage8InputRe,stage8InputIm : std_logic_vector(11 downto 0);
  signal stage9InputRe,stage9InputIm : std_logic_vector(11 downto 0);
  signal stage10InputRe,stage10InputIm : std_logic_vector(11 downto 0);

  signal readAdd1 : std_logic_vector(9 downto 0);
    
begin

stage_1 : stage1
    port map(
            rst => rst,
            clk => clk,
            T1 => T1,
            S1 => S1,
            --readAdd => readAdd1,
            stage1InputRe => externalInputRe,
            stage1InputIm => externalInputIm,
            stage1OutputRe => stage2InputRe,
            stage1OutputIm => stage2InputIm);


end Behavioral;
