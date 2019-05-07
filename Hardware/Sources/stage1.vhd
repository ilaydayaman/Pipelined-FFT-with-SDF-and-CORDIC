library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity stage1 is
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
end stage1;

architecture Behavioral of stage1 is
 
  --FIFO definitions
  constant w2   : natural := 13; -- wordlength output
  constant ROW  : natural := 1024; -- number of words
  constant COL  : natural := 12;  -- wordlength
  constant NOFW : natural := 10;  -- 2^NOFW = Number of words in registerfile
  
  constant addressMax : natural := 256;  --number of address in Register file 
  
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

component complexMult
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

  component registerfilecoe
    generic(
          constant ROW : natural; -- number of words
          --constant COL : natural; -- wordlength
          constant NOFW : natural); -- 2^NOFW = Number of words in registerfile
    port (
          readAdd : in std_logic_vector(9 downto 0);
          dataOut1 : out std_logic_vector(11 downto 0);
          dataOut2 : out std_logic_vector(11 downto 0));
  end component;


--signal n1, n2 : std_logic_vector( 11 downto 0);
signal sumOutRe, subOutRe, sumOutIm, subOutIm :  std_logic_vector( 11 downto 0);
signal multInRe, multInIm : std_logic_vector( 11 downto 0);
signal coeffRe, coeffIm : std_logic_vector( 11 downto 0);
--signal multOutRe, multOutIm : std_logic_vector( 12 downto 0);

signal writeEn : std_logic;
signal readEn  : std_logic;
signal fifoInRe, fifoInIm  : std_logic_vector(COL-1 downto 0);
signal empty   : std_logic;
signal full    : std_logic;
signal fifoOutRe, fifoOutIm : std_logic_vector(COL-1 downto 0);

  --Control mechanism for Register File
type FSM_State is (coeff1, coeff2, coeff3, coeff4, coeff5);
  
signal stateReg, stateNext : FSM_State; 
signal addressReg, addressNext : unsigned(9 downto 0);
signal regFileCoeffIm, regFileCoeffRe : std_logic_vector(11 downto 0);

begin

process(clk, rst)
  begin
    if(rst = '1') then
        stateReg   <= coeff1;
        addressReg <= (others => '0');
        writeEn <= '0';
        readEn  <= '0';
    elsif(clk'event and clk = '1') then 
        stateReg   <= stateNext;
        addressReg <= addressNext;
        writeEn <= '1';        
        readEn  <= '1';
    end if;
end process;

process(T1, stage1inputRe, stage1inputIm, subOutRe, subOutIm)
begin 
    if (T1 = '1') then
        fifoInRe <= stage1inputRe;
        fifoInIm <= stage1inputIm;
    else 
        fifoInRe <= subOutRe;    
        fifoInIm <= subOutIm;  
    end if; 
end process;

myButterfly_Re_Inst : myButterfly
    generic map (
            w1 => COL
            )
    port map(
            n1 => fifoOutRe,
            n2 => stage1InputRe,
            sumOut => sumOutRe,
            subOut => subOutRe
            );
            
myButterfly_Im_Inst : myButterfly
    generic map (
            w1 => COL
            )
    port map(
            n1 => fifoOutIm,
            n2 => stage1InputIm,
            sumOut => sumOutIm,
            subOut => subOutIm
            );

  FIFO_Re_Inst : FIFO
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
            empty   => empty,
            full    => full,
            fifoOut => fifoOutRe
            );
            
  FIFO_Im_Inst : FIFO
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
            empty   => empty,
            full    => full,
            fifoOut => fifoOutIm
            ); 

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
process(stateReg, addressReg, T1)
  begin
    -- default
    stateNext <= stateReg;
    case (stateReg) is
      when coeff1 =>
        if (T1 = '0') then
          stateNext <= coeff2;
        end if;
      when coeff2 =>
        if (addressReg = 256) then
          stateNext <= coeff3;
        end if;
      when coeff3 =>                         --load data 
        if (addressReg = 0) then
                stateNext <= coeff4;
              end if;
      when coeff4 =>                         --multiply
        if (addressReg = 256) then
                stateNext <= coeff5;
              end if;
      when coeff5 =>                         --accumulate 
        if (addressReg = 0) then
            stateNext <= coeff1;
          end if;
     end case;
  end process;    
  
-- combinational logic
process(stateReg, regFileCoeffRe, regFileCoeffIm, addressReg)
  begin
    -- default
    coeffRe     <= "000000000000";
    coeffIm     <= "000000000000";
    addressNext <= addressReg; 
    
    case (stateReg) is
      when coeff1 =>
        coeffRe <= "000000000001";
        coeffIm <= "000000000001";
        addressNext <= addressReg;
      when coeff2 =>
        coeffRe <= regFileCoeffRe;
        coeffIm <= regFileCoeffIm;
        addressNext <= addressReg + 1;
      when coeff3 =>                       
        coeffRe <= std_logic_vector(unsigned(not(regFileCoeffIm)) + "000000000001");
        coeffIm <= std_logic_vector(unsigned(not(regFileCoeffRe)) + "000000000001");
        addressNext <= addressReg - 1;
      when coeff4 =>                        
        coeffRe <= regFileCoeffIm;
        coeffIm <= std_logic_vector(unsigned(not(regFileCoeffRe)) + "000000000001");
        addressNext <= addressReg + 1;
      when coeff5 =>                        
        coeffRe <= regFileCoeffRe;
        coeffIm <= std_logic_vector(unsigned(not(regFileCoeffIm)) + "000000000001");
        addressNext <= addressReg - 1;
     end case;
  end process;   
                             
complexMult_Inst : complexMult
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
            multOutRe => stage1OutputRe,
            multOutIm => stage1OutputIm
            );      

 Coeregister : registerfilecoe
   generic map (
           ROW => ROW,
           --COL => COL,
           NOFW => NOFW
           )
   port map(
           readAdd => std_logic_vector(addressReg),
           dataOut1 => regFileCoeffRe,
           dataOut2 => regFileCoeffIm
           );

end Behavioral;
