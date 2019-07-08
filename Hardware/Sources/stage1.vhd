library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity stage1 is
  generic(
    constant w2   : natural;
    constant COL  : natural;
    constant ROW  : natural;            -- number of words
    constant NOFW : natural);  -- 2^NOFW = Number of words in registerfile
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
end stage1;

architecture Behavioral of stage1 is
  
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

  component complexMult1
    generic(
      w1 : integer;
      w2 : integer
      );
    port(
      clk       : in  std_logic;
      rst       : in  std_logic;
      multInRe  : in  std_logic_vector((w1-1) downto 0);
      multInIm  : in  std_logic_vector((w1-1) downto 0);
      coeffRe   : in  std_logic_vector(11 downto 0);
      coeffIm   : in  std_logic_vector(11 downto 0);
      multOutRe : out std_logic_vector((w2-1) downto 0);
      multOutIm : out std_logic_vector((w2-1) downto 0)
      );
  end component;

  component memory is
    generic (
      constant ROW  : natural;  -- := 8; -- number of words
      constant COL  : natural;  -- := 4;  -- wordlength
      constant NOFW : natural);-- := 3); -- 2^NOFW = Number of words in registerfile
    port (
      clk     : in  std_logic;
      rst     : in  std_logic;
      writeEn : in  std_logic;
      readEn  : in  std_logic;
      dataIn  : in  std_logic_vector(39 downto 0);
      dataOut : out std_logic_vector(39 downto 0));
  end component;

  component registerfilecoe
    generic(
      constant ROW  : natural;          -- number of words
      constant NOFW : natural);  -- 2^NOFW = Number of words in registerfile
    port (
      readAdd  : in  std_logic_vector((NOFW-1) downto 0);
      dataOut1 : out std_logic_vector(11 downto 0);
      dataOut2 : out std_logic_vector(11 downto 0));
  end component;

  signal sumOutRe, subOutRe, sumOutIm, subOutIm : std_logic_vector(COL-1 downto 0);
  signal multInRe, multInIm                     : std_logic_vector((COL-1) downto 0);
  signal multOutRe, multOutIm                   : std_logic_vector((COL-1) downto 0);
  signal coeffRe, coeffIm                       : std_logic_vector(11 downto 0);

  signal writeEn              : std_logic;
  signal readEn               : std_logic;
  signal fifoInRe, fifoInIm   : std_logic_vector(COL-1 downto 0);
  signal fifoOutRe, fifoOutIm : std_logic_vector(COL-1 downto 0);
  signal dataIn, dataOut      : std_logic_vector(39 downto 0);

  --Control mechanism for Register File
  type FSM_State is (coeffIdle, coeff1, coeff2, coeff3, coeff4, coeff5);

  signal stateReg, stateNext            : FSM_State;
  signal addressReg, addressNext        : unsigned((NOFW-1) downto 0);
  signal regFileCoeffIm, regFileCoeffRe : std_logic_vector(11 downto 0);

  signal counter2048Reg, counter2048Next : unsigned (NOFW downto 0);

begin

  fifoOutRe <= dataOut(39 downto 28);
  fifoOutIm <= dataOut(11 downto 0);

  process(clk, rst)
  begin
    if(rst = '1') then
      writeEn        <= '0';
      stateReg       <= coeffIdle;
      addressReg     <= (others => '0');
      counter2048reg <= (others => '0');
    elsif(clk'event and clk = '1') then
      writeEn        <= '1';
      stateReg       <= stateNext;
      addressReg     <= addressNext;
      counter2048reg <= counter2048next;
    end if;
  end process;

  process(T1, stage1inputRe, stage1inputIm, subOutRe, subOutIm)
  begin
    if (T1 = '1') then
      dataIn <= stage1inputRe & "0000000000000000" & stage1inputIm;
    else
      dataIn <= subOutRe & "0000000000000000" & subOutIm;
    end if;
  end process;

  myButterfly_Re_Inst : myButterfly
    generic map (
      w1 => COL
      )
    port map(
      n1     => fifoOutRe,
      n2     => stage1InputRe,
      sumOut => sumOutRe,
      subOut => subOutRe
      );

  myButterfly_Im_Inst : myButterfly
    generic map (
      w1 => COL
      )
    port map(
      n1     => fifoOutIm,
      n2     => stage1InputIm,
      sumOut => sumOutIm,
      subOut => subOutIm
      );  

  Memory_Inst : memory
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
      dataIn  => dataIn,
      dataOut => dataOut
      );   

  complexMult_Inst : complexMult1
    generic map (
      w1 => COL,
      w2 => w2
      )
    port map(
      clk       => clk,
      rst       => rst,
      multInRe  => multInRe,
      multInIm  => multInIm,
      coeffRe   => coeffRe,
      coeffIm   => coeffIm,
      multOutRe => stage1OutputRe,
      multOutIm => stage1OutputIm
      );               

  Coeregister : registerfilecoe
    generic map (
      ROW  => ROW,
      NOFW => NOFW
      )
    port map(
      readAdd  => std_logic_vector(addressReg),
      dataOut1 => regFileCoeffRe,
      dataOut2 => regFileCoeffIm
      );

  readEn <= '1' when unsigned(clkCounter) > 1023 else '0';

  process(S1, fifoOutRe, fifoOutIm, sumOutRe, sumOutIm)
  begin
    if (S1 = '0') then
      multInRe <= fifoOutRe;
      multInIm <= fifoOutIm;
    else
      multInRe <= sumOutRe;
      multInIm <= sumOutIm;
    end if;
  end process;

  -- next state logic
  process(stateReg, addressReg, T1, clkCounter, counter2048reg)
  begin
    -- default
    stateNext <= stateReg;
    case (stateReg) is
      when coeffIdle =>
        if (clkCounter = "000010000000000") then
          stateNext <= coeff1;
        end if;
      when coeff1 =>
        if (counter2048reg = 1023) then  --1023 before
          stateNext <= coeff2;
        end if;
      when coeff2 =>
        if (counter2048reg = 1279) then
          stateNext <= coeff3;
        end if;
      when coeff3 =>                     --load data 
        if (counter2048reg = 1535) then
          stateNext <= coeff4;
        end if;
      when coeff4 =>                     --multiply
        if (counter2048reg = 1791) then
          stateNext <= coeff5;
        end if;
      when coeff5 =>                     --accumulate 
        if (counter2048reg = 2047) then
          stateNext <= coeff1;
        end if;
    end case;
  end process;

-- combinational logic
  process(stateReg, regFileCoeffRe, regFileCoeffIm, addressReg, counter2048reg)
  begin
    -- default
    coeffRe         <= "000000000000";
    coeffIm         <= "000000000000";
    addressNext     <= addressReg;
    counter2048next <= counter2048reg;
    case (stateReg) is
      when coeffIdle =>
      when coeff1    =>
        coeffRe         <= "010000000000";
        coeffIm         <= "000000000000";
        counter2048next <= counter2048reg + 1;
      when coeff2 =>
        coeffRe         <= regFileCoeffRe;
        coeffIm         <= regFileCoeffIm;
        addressNext     <= addressReg + 1;
        counter2048next <= counter2048reg + 1;
      when coeff3 =>
        coeffRe         <= std_logic_vector(unsigned(not(regFileCoeffIm)) + "000000000001");
        coeffIm         <= std_logic_vector(unsigned(not(regFileCoeffRe)) + "000000000001");
        addressNext     <= addressReg - 1;
        counter2048next <= counter2048reg + 1;
      when coeff4 =>
        coeffRe         <= regFileCoeffIm;
        coeffIm         <= std_logic_vector(unsigned(not(regFileCoeffRe)) + "000000000001");
        addressNext     <= addressReg + 1;
        counter2048next <= counter2048reg + 1;
      when coeff5 =>
        coeffRe         <= std_logic_vector(unsigned(not(regFileCoeffRe)) + "000000000001");
        coeffIm         <= std_logic_vector(unsigned(regFileCoeffIm));
        addressNext     <= addressReg - 1;
        counter2048next <= counter2048reg + 1;
    end case;
  end process;
  
end Behavioral;
