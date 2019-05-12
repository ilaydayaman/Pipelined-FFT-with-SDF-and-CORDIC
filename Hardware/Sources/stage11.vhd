library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity stage11 is
    generic(
        constant w2   : natural; -- wordlength output
        constant COL  : natural;  -- wordlength input current stage = wordlength output previous stage
        constant ROW  : natural; -- number of words
        constant NOFW : natural);  -- 2^NOFW = Number of words in registerfile
    Port (
         rst : in STD_LOGIC;
         clk : in STD_LOGIC;
         T  : in STD_LOGIC;
         S  : in STD_LOGIC;
         clkCounter : in unsigned (14 downto 0);
         stageInputRe : in std_logic_vector(COL-1 downto 0);
         stageInputIm : in std_logic_vector(COL-1 downto 0);
         stageOutputRe : out std_logic_vector(w2-1 downto 0);
         stageOutputIm : out std_logic_vector(w2-1 downto 0)
         );
end stage11;

architecture Behavioral of stage11 is

component myButterfly
    generic(
             w1 : integer
             );
    Port(
         n1 : in std_logic_vector( (w1-1) downto 0);
         n2 : in std_logic_vector( (w1-1) downto 0);
         sumOut : out std_logic_vector( (w1-1) downto 0);
         subOut : out std_logic_vector( (w1-1) downto 0)
         );
end component;

signal sumOutRe, subOutRe, sumOutIm, subOutIm :  std_logic_vector( COL-1 downto 0);
signal multInRe, multInIm : std_logic_vector( COL-1 downto 0);
signal coeffRe, coeffIm : std_logic_vector( 11 downto 0);
--signal multOutRe, multOutIm : std_logic_vector( (w2-1) downto 0);

signal writeEn : std_logic;
signal readEn  : std_logic;
signal fifoInRe, fifoInIm  : std_logic_vector(COL-1 downto 0);
signal empty   : std_logic;
signal full    : std_logic;
signal fifoOutRe, fifoOutIm : std_logic_vector(COL-1 downto 0);

  --Control mechanism for Register File
type FSM_State is (coeffIdle, coeff1, coeff2, coeff3, coeff4, coeff5);

signal stateReg, stateNext : FSM_State;
--signal addressReg, addressNext : unsigned( NOFW-1 downto 0);
signal regFileCoeffIm, regFileCoeffRe : std_logic_vector(11 downto 0);
signal fifoInReReg, fifoInImReg, fifoInReNext, fifoInImNext  : std_logic_vector(COL-1 downto 0);

--signal counter2Reg, counter2Next : unsigned ( NOFW downto 0);

begin

process(clk, rst)
  begin
    if(rst = '1') then
        stateReg        <= coeffIdle;
		fifoInReReg	<= (others => '0');
		fifoInImReg	<= (others => '0');
         --addressReg      <= (others => '0');
        --counter2reg  <= (others => '0');
    elsif(clk'event and clk = '1') then
        stateReg        <= stateNext;
		fifoInReReg	<= fifoInReNext;
		fifoInImReg	<= fifoInImNext;
        --addressReg      <= addressNext;
        --counter2reg  <= counter2next;
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
            n1 => fifoInReReg,
            n2 => stageInputRe,
            sumOut => sumOutRe,
            subOut => subOutRe
            );

myButterfly11_Im_Inst : myButterfly
    generic map (
            w1 => COL
            )
    port map(
            n1 => fifoInImReg,
            n2 => stageInputIm,
            sumOut => sumOutIm,
            subOut => subOutIm
            );

--clk_counter_out************************
readEn  <= '1' when (unsigned(clkCounter) > 1540) else '0'; --******************************************************** change the clock cycle to input of the stage
writeEn <= '1' when (unsigned(clkCounter) > 1028) else '0'; --*********************************************** 
                                                            --should add this signal and remove it from upper process with registers

process(S, fifoInReReg, fifoInImReg, sumOutRe, sumOutIm)
begin
    if (S = '0') then
       stageOutputRe <= fifoInReReg( 11 downto 0);
       stageOutputIm <= fifoInImReg( 11 downto 0);
    else
       stageOutputRe <= sumOutRe( 11 downto 0);
       stageOutputIm <= sumOutIm( 11 downto 0);
    end if;
end process;

end Behavioral;
