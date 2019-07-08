library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity stage11 is
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
end stage11;

architecture Behavioral of stage11 is

  component myButterfly
    generic(
      w1 : integer
      );
    port(
      n1     : in  std_logic_vector((w1-1) downto 0);
      n2     : in  std_logic_vector((w1-1) downto 0);
      sumOut : out std_logic_vector((w1-1) downto 0);
      subOut : out std_logic_vector((w1-1) downto 0)
      );
  end component;

  signal sumOutRe, subOutRe, sumOutIm, subOutIm : std_logic_vector(COL-1 downto 0);
  signal fifoInReReg, fifoInImReg               : std_logic_vector(COL-1 downto 0);
  signal fifoInReNext, fifoInImNext             : std_logic_vector(COL-1 downto 0);

begin

  process(clk, rst)
  begin
    if(rst = '1') then
      fifoInReReg <= (others => '0');
      fifoInImReg <= (others => '0');
    elsif(clk'event and clk = '1') then
      fifoInReReg <= fifoInReNext;
      fifoInImReg <= fifoInImNext;
    end if;
  end process;

  process(T, stageinputRe, stageinputIm, subOutRe, subOutIm)
  begin
    if (T = '1') then
      fifoInReNext <= stageinputRe;
      fifoInImNext <= stageinputIm;
    else
      fifoInReNext <= subOutRe;
      fifoInImNext <= subOutIm;
    end if;
  end process;

  myButterfly11_Re_Inst : myButterfly
    generic map (
      w1 => COL
      )
    port map(
      n1     => fifoInReReg,
      n2     => stageInputRe,
      sumOut => sumOutRe,
      subOut => subOutRe
      );

  myButterfly11_Im_Inst : myButterfly
    generic map (
      w1 => COL
      )
    port map(
      n1     => fifoInImReg,
      n2     => stageInputIm,
      sumOut => sumOutIm,
      subOut => subOutIm
      );

-- First output from stage 11 at CC: 2079, with S11 = '1' and T11 = '0'
  process(S, fifoInReReg, fifoInImReg, sumOutRe, sumOutIm)
  begin
    if (S = '0') then
      stageOutputRe <= fifoInReReg(15) & fifoInReReg(11 downto 1);
      stageOutputIm <= fifoInImReg(15) & fifoInImReg(11 downto 1);
    else
      stageOutputRe <= sumOutRe(15) & sumOutRe(11 downto 1);
      stageOutputIm <= sumOutIm(15) & sumOutIm(11 downto 1);
    end if;
  end process;

end Behavioral;
