library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity stage2 is
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
end stage2;

architecture Behavioral of stage2 is
  
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

component complexMult2
    generic(
            w1 : integer;
            w2 : integer
            );
    port(
          clk       : in  std_logic;
          rst       : in  std_logic; 
          multInRe  : in std_logic_vector( (w1-1) downto 0);
          multInIm  : in std_logic_vector( (w1-1) downto 0);
          coeffRe   : in std_logic_vector( 11 downto 0);
          coeffIm   : in std_logic_vector( 11 downto 0);
          multOutRe : out std_logic_vector( (w2-1) downto 0);
          multOutIm : out std_logic_vector( (w2-1) downto 0)
        );
end component;

component FIFO
  generic (
        constant ROW  : natural; -- number of words
        constant COL  : natural;  -- wordlength
        constant NOFW : natural -- 2^NOFW = Number of words in registerfile
        );
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

  component registerfilecoe2
    generic(
          constant ROW : natural; -- number of words
          constant NOFW : natural); -- 2^NOFW = Number of words in registerfile
    port (
          readAdd : in std_logic_vector( NOFW-1 downto 0);
          dataOut1 : out std_logic_vector(11 downto 0);
          dataOut2 : out std_logic_vector(11 downto 0));
  end component;

signal sumOutRe, subOutRe, sumOutIm, subOutIm :  std_logic_vector( COL-1 downto 0);
signal multInRe, multInIm : std_logic_vector( COL-1 downto 0);
signal coeffRe, coeffIm : std_logic_vector( 11 downto 0);
signal multOutRe, multOutIm : std_logic_vector( (w2-1) downto 0);

signal writeEn : std_logic;
signal readEn  : std_logic;
signal fifoInRe, fifoInIm  : std_logic_vector(COL-1 downto 0);
signal emptyRe, emptyIm    : std_logic;
signal fullRe, fullIm      : std_logic;
signal fifoOutRe, fifoOutIm : std_logic_vector(COL-1 downto 0);

  --Control mechanism for Register File
type FSM_State is (coeffIdle, coeff1, coeff2, coeff3, coeff4, coeff5);

signal stateReg, stateNext : FSM_State;
signal addressReg, addressNext : unsigned( NOFW-1 downto 0);
signal regFileCoeffIm, regFileCoeffRe : std_logic_vector(11 downto 0);

signal counter2048Reg, counter2048Next : unsigned ( NOFW downto 0);

begin

process(clk, rst)
  begin
    if(rst = '1') then
        writeEn         <= '0';
        stateReg        <= coeffIdle;
        addressReg      <= (others => '0');
        counter2048reg  <= (others => '0');
    elsif(clk'event and clk = '1') then
        writeEn         <= '1';
        stateReg        <= stateNext;
        addressReg      <= addressNext;
        counter2048reg  <= counter2048next;
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

myButterfly2_Re_Inst : myButterfly
    generic map (
            w1 => COL
            )
    port map(
            n1 => fifoOutRe,
            n2 => stageInputRe,
            sumOut => sumOutRe,
            subOut => subOutRe
            );
            
myButterfly2_Im_Inst : myButterfly
    generic map (
            w1 => COL
            )
    port map(
            n1 => fifoOutIm,
            n2 => stageInputIm,
            sumOut => sumOutIm,
            subOut => subOutIm
            );

  FIFO2_Re_Inst : FIFO
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
            fifoIn  => fifoInRe,
            empty   => emptyRe,
            full    => fullRe,
            fifoOut => fifoOutRe
            );
            
  FIFO2_Im_Inst : FIFO
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
            fifoIn  => fifoInIm,
            empty   => emptyIm,
            full    => fullIm,
            fifoOut => fifoOutIm
            ); 

complexMult2_Inst : complexMult2
    generic map (
            w1 => COL,
            w2 => w2
            )
    port map(
            clk     => clk,
            rst     => rst,
            multInRe  => multInRe,
            multInIm  => multInIm,
            coeffRe   => coeffRe,
            coeffIm   => coeffIm,
            multOutRe => stageOutputRe,
            multOutIm => stageOutputIm
            );      

 Coeregister2 : registerfilecoe2
   generic map (
           ROW => ROW,
           NOFW => NOFW
           )
   port map(
           readAdd => std_logic_vector(addressReg),
           dataOut1 => regFileCoeffRe,
           dataOut2 => regFileCoeffIm
           );

--clk_counter_out
readEn <= '1' when clkCounter > "0010000000000" else '0'; --01111111111

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

  -- next state logic
process(stateReg, addressReg, T, clkCounter, counter2048reg)
  begin
    -- default
    stateNext <= stateReg;
    case (stateReg) is
      when coeffIdle =>
          if (clkCounter = "0010000000000") then 
            stateNext <= coeff1;
          end if;
      when coeff1 =>
        if (counter2048reg = 1023) then
          stateNext <= coeff2;
        end if;
      when coeff2 =>
        if (counter2048reg = 1278) then
          stateNext <= coeff3;
        end if;
      when coeff3 =>                         --load data 
        if (counter2048reg = 1533) then
            stateNext <= coeff4;
        end if;
      when coeff4 =>                         --multiply
        if (counter2048reg = 1788) then
            stateNext <= coeff5;
        end if;
      when coeff5 =>                         --accumulate 
        if (counter2048reg = 2043) then
            stateNext <= coeff1;
        end if;
     end case;
  end process;    
  
-- combinational logic
process(stateReg, regFileCoeffRe, regFileCoeffIm, addressReg, counter2048reg)
  begin
    -- default
    coeffRe     <= "000000000000";
    coeffIm     <= "000000000000";
    addressNext <= addressReg; 
    counter2048next  <= counter2048reg;
    case (stateReg) is
      when coeffIdle =>
      when coeff1 =>
        coeffRe <= "000000000001";
        coeffIm <= "000000000001";
        counter2048next  <= counter2048reg + 1;
      when coeff2 =>
        coeffRe <= regFileCoeffRe;
        coeffIm <= regFileCoeffIm;
        addressNext <= addressReg + 1;
        counter2048next  <= counter2048reg + 1;
      when coeff3 =>                       
        coeffRe <= std_logic_vector(unsigned(not(regFileCoeffIm)) + "000000000001");
        coeffIm <= std_logic_vector(unsigned(not(regFileCoeffRe)) + "000000000001");
        addressNext <= addressReg - 1;
        counter2048next  <= counter2048reg + 1;
      when coeff4 =>                        
        coeffRe <= regFileCoeffIm;
        coeffIm <= std_logic_vector(unsigned(not(regFileCoeffRe)) + "000000000001");
        addressNext <= addressReg + 1;
        counter2048next  <= counter2048reg + 1;
      when coeff5 =>                        
        coeffRe <= regFileCoeffRe;
        coeffIm <= std_logic_vector(unsigned(not(regFileCoeffIm)) + "000000000001");
        addressNext <= addressReg - 1;
        counter2048next  <= counter2048reg + 1;
     end case;
  end process;   

end Behavioral;
