library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity stage9 is
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
end stage9;

architecture Behavioral of stage9 is

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

  component complexMult9
    generic(
      w1 : integer;
      w2 : integer
      );
    port(
      clk         : in  std_logic;
      rst         : in  std_logic;
      counter4Bit : in  std_logic_vector (NOFW+1 downto 0);
      multInRe    : in  std_logic_vector((w1-1) downto 0);
      multInIm    : in  std_logic_vector((w1-1) downto 0);
      multOutRe   : out std_logic_vector((w2-1) downto 0);
      multOutIm   : out std_logic_vector((w2-1) downto 0)
      );
  end component;

  component FIFO
    generic (
      constant ROW  : natural;          -- number of words
      constant COL  : natural;          -- wordlength
      constant NOFW : natural   -- 2^NOFW = Number of words in registerfile
      );
    port (
      clk     : in  std_logic;
      rst     : in  std_logic;
      writeEn : in  std_logic;
      readEn  : in  std_logic;
      fifoIn  : in  std_logic_vector(COL-1 downto 0);
      fifoOut : out std_logic_vector(COL-1 downto 0)
      );
  end component;

  signal sumOutRe, subOutRe, sumOutIm, subOutIm : std_logic_vector(COL-1 downto 0);
  signal multInRe, multInIm                     : std_logic_vector(COL-1 downto 0);
  signal coeffRe, coeffIm                       : std_logic_vector(11 downto 0);

  signal writeEn              : std_logic;
  signal readEn               : std_logic;
  signal fifoInRe, fifoInIm   : std_logic_vector(COL-1 downto 0);
  signal fifoOutRe, fifoOutIm : std_logic_vector(COL-1 downto 0);

  signal counter4BitReg, counter4BitNext : unsigned (NOFW+1 downto 0);
  signal counter4Bit                     : std_logic_vector (NOFW+1 downto 0);

begin

  process(clk, rst)
  begin
    if(rst = '1') then
      counter4BitReg <= (others => '0');
    elsif(clk'event and clk = '1') then
      counter4BitReg <= counter4BitNext;
    end if;
  end process;

  process(T, stageinputRe, stageinputIm, subOutRe, subOutIm)
  begin
    if (T = '1') then
      fifoInRe <= stageinputRe;
      fifoInIm <= stageinputIm;
    else
      fifoInRe <= subOutRe;
      fifoInIm <= subOutIm;
    end if;
  end process;

  myButterfly9_Re_Inst : myButterfly
    generic map (
      w1 => COL
      )
    port map(
      n1     => fifoOutRe,
      n2     => stageInputRe,
      sumOut => sumOutRe,
      subOut => subOutRe
      );

  myButterfly9_Im_Inst : myButterfly
    generic map (
      w1 => COL
      )
    port map(
      n1     => fifoOutIm,
      n2     => stageInputIm,
      sumOut => sumOutIm,
      subOut => subOutIm
      );

  FIFO9_Re_Inst : FIFO
    generic map (
      ROW  => ROW,
      COL  => COL,
      NOFW => NOFW
      )
    port map(
      clk     => clk,
      rst     => rst,
      writeEn => writeEn,
      readEn  => readEn,
      fifoIn  => fifoInRe,
      fifoOut => fifoOutRe
      );

  FIFO9_Im_Inst : FIFO
    generic map (
      ROW  => ROW,
      COL  => COL,
      NOFW => NOFW
      )
    port map(
      clk     => clk,
      rst     => rst,
      writeEn => writeEn,
      readEn  => readEn,
      fifoIn  => fifoInIm,
      fifoOut => fifoOutIm
      );

  complexMult9_Inst : complexMult9
    generic map (
      w1 => COL,
      w2 => w2
      )
    port map(
      clk         => clk,
      rst         => rst,
      counter4Bit => counter4Bit,
      multInRe    => multInRe,
      multInIm    => multInIm,
      multOutRe   => stageOutputRe,
      multOutIm   => stageOutputIm
      );

  readEn  <= '1' when (unsigned(clkCounter) >= 2069) else '0';
  writeEn <= '1' when unsigned(clkCounter) >= 2065   else '0';

  process(S, fifoOutRe, fifoOutIm, sumOutRe, sumOutIm)
  begin
    if (S = '0') then
      multInRe <= fifoOutRe;
      multInIm <= fifoOutIm;
    else
      multInRe <= sumOutRe;
      multInIm <= sumOutIm;
    end if;
  end process;

  counter_4bit : process(rst, counter4BitReg, clkCounter)
  begin
    if (counter4BitReg = 8) then
      counter4BitNext <= "0001";
    elsif (rst = '0') and (clkCounter > 2072) then  -- old value 2068
      counter4BitNext <= counter4BitReg + 1;
    else
      counter4BitNext <= counter4BitReg;
    end if;
  end process;
  counter4Bit <= std_logic_vector(counter4BitReg);

end Behavioral;
