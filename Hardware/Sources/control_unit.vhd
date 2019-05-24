library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity control_unit is
    --generic ( STATE : integer := 4 );
    Port ( 
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
end control_unit;

architecture Behavioral of control_unit is

signal clkCounterReg, clkCounterNext    : unsigned (14 downto 0);
signal counter1024reg, counter1024next  : unsigned (10 downto 0);
signal counter512reg, counter512next    : unsigned (9 downto 0);
signal counter256reg, counter256next    : unsigned (8 downto 0);
signal counter128reg, counter128next    : unsigned (7 downto 0);
signal counter64reg, counter64next      : unsigned (6 downto 0);
signal counter32reg, counter32next      : unsigned (5 downto 0);
signal counter16reg, counter16next      : unsigned (4 downto 0);
signal counter8reg, counter8next        : unsigned (3 downto 0);
signal counter4reg, counter4next        : unsigned (2 downto 0);
signal counter2reg, counter2next        : unsigned (1 downto 0);
signal T1reg, T2reg, T3reg, T4reg, T5reg, T6reg, T7reg, T8reg, T9reg, T10reg, T11reg : std_logic;
signal T1next, T2next, T3next, T4next, T5next, T6next, T7next, T8next, T9next, T10next, T11next : std_logic;
signal S1reg, S2reg, S3reg, S4reg, S5reg, S6reg, S7reg, S8reg, S9reg, S10reg, S11reg : std_logic;
signal S1next, S2next, S3next, S4next, S5next, S6next, S7next, S8next, S9next, S10next, S11next : std_logic;

--signal startSt2 : std_logic;
--signal startSt3 : std_logic;
--signal startSt4 : std_logic;
--signal startSt5 : std_logic;
--signal startSt6 : std_logic;
--signal startSt7 : std_logic;
--signal startSt8 : std_logic;
--signal startSt9 : std_logic;
--signal startSt10 : std_logic;

begin

    process (clk, rst)
    begin
        if(rst = '1') then
          clkCounterReg   <= (others =>'0');
          counter1024reg  <= (others => '0');  
          counter512reg   <= (others => '0');
          counter256reg   <= (others => '0');
          counter128reg   <= (others => '0');
          counter64reg    <= (others => '0');
          counter32reg    <= (others => '0');
          counter16reg    <= (others => '0');
          counter8reg     <= (others => '0');
          counter4reg     <= (others => '0');
          counter2reg     <= (others => '0');
          T1reg           <=  '1';
          T2reg           <=  '1';
          T3reg           <=  '1';
          T4reg           <=  '1';
          T5reg           <=  '1';
          T6reg           <=  '1';
          T7reg           <=  '1';
          T8reg           <=  '1';
          T9reg           <=  '1';
          T10reg          <=  '1';
          T11reg          <=  '0';
          S1reg           <=  '0';
          S2reg           <=  '0';
          S3reg           <=  '0';
          S4reg           <=  '0';
          S5reg           <=  '0';
          S6reg           <=  '0';
          S7reg           <=  '0';
          S8reg           <=  '0';
          S9reg           <=  '0';
          S10reg          <=  '0';
          S11reg          <=  '1';
        elsif(clk'event and clk = '1') then
          clkCounterReg   <= clkCounterNext;
          counter1024reg  <= counter1024next;  
          counter512reg   <= counter512next;
          counter256reg   <= counter256next;
          counter128reg   <= counter128next;
          counter64reg    <= counter64next;
          counter32reg    <= counter32next;
          counter16reg    <= counter16next;
          counter8reg     <= counter8next;
          counter4reg     <= counter4next;
          counter2reg     <= counter2next;
          T1reg           <=  T1next;
          T2reg           <=  T2next;
          T3reg           <=  T3next;
          T4reg           <=  T4next;
          T5reg           <=  T5next;
          T6reg           <=  T6next;
          T7reg           <=  T7next;
          T8reg           <=  T8next;
          T9reg           <=  T9next;
          T10reg          <=  T10next;
          T11reg          <=  T11next;
          S1reg           <=  S1next;
          S2reg           <=  S2next;
          S3reg           <=  S3next;
          S4reg           <=  S4next;
          S5reg           <=  S5next;
          S6reg           <=  S6next;
          S7reg           <=  S7next;
          S8reg           <=  S8next;
          S9reg           <=  S9next;
          S10reg          <=  S10next;
          S11reg          <=  S11next;
        end if;
    end process;
 
--    start_stage_2 : process (clk, rst, startSt2, T2next, S2next)
--    begin
--        if(rst = '1') then
--           T2reg           <=  '1';
--           S2reg           <=  '0';
--        elsif(startSt2 = '0') then
--           T2reg           <=  '1';
--           S2reg           <=  '0';        
--        elsif(clk'event and clk = '1') then
--           T2reg           <=  T2next;
--           S2reg           <=  S2next;
--        end if;
--    end process;
    
--        start_stage_3 : process (clk, rst, startSt3, T3next, S3next)
--    begin
--        if(rst = '1') then
--           T3reg           <=  '1';
--           S3reg           <=  '0';
--        elsif(startSt2 = '0') then
--           T3reg           <=  '1';
--           S3reg           <=  '0';        
--        elsif(clk'event and clk = '1') then
--           T3reg           <=  T3next;
--           S3reg           <=  S3next;
--        end if;
--    end process;
    
--    startSt2 <= '1' when unsigned(clkCounterReg) >= 1028 else '0';
--    startSt3 <= '1' when unsigned(clkCounterReg) >= 1540 else '0';
--    startSt4 <= '1' when unsigned(clkCounterReg) >= 1800 else '0';
--    startSt5 <= '1' when unsigned(clkCounterReg) >= 1992 else '0';
--    startSt6 <= '1' when unsigned(clkCounterReg) >= 2024 else '0';
--    startSt7 <= '1' when unsigned(clkCounterReg) >= 2040 else '0';
--    startSt8 <= '1' when unsigned(clkCounterReg) >= 2048 else '0';
--    startSt9 <= '1' when unsigned(clkCounterReg) >= 2052 else '0';
--    startSt10 <= '1'when unsigned(clkCounterReg) >= 2052 else '0';
    
    clk_counter_next : process(rst,clkCounterReg) --readEn
    begin
        --if (rst = '0') and (readEn = '0') then
        if (rst = '0') and (clkCounterReg < 2078) then
            clkCounterNext <= clkCounterReg + 1;
        else
            clkCounterNext <= clkCounterReg;
        end if;
    end process;
    clkCounter <= clkCounterReg;
    

    process(T1reg, T2reg, T3reg, T4reg, T5reg, T6reg, T7reg, T8reg, T9reg, T10reg, T11reg, 
            S1reg, S2reg, S3reg, S4reg, S5reg, S6reg, S7reg, S8reg, S9reg, S10reg, S11reg,
            counter1024reg, counter512reg, counter256reg, counter128reg, counter64reg, 
            counter32reg, counter16reg, counter8reg, counter4reg, counter2reg, rst, clkCounterReg)
    begin 
    --default values
        T1next  <=  T1reg;
        T2next  <=  T2reg;
        T3next  <=  T3reg;
        T4next  <=  T4reg;
        T5next  <=  T5reg;
        T6next  <=  T6reg;
        T7next  <=  T7reg;
        T8next  <=  T8reg;
        T9next  <=  T9reg;
        T10next <=  T10reg;
        S1next  <=  S1reg;
        S2next  <=  S2reg;
        S3next  <=  S3reg;
        S4next  <=  S4reg;
        S5next  <=  S5reg;
        S6next  <=  S6reg;
        S7next  <=  S7reg;
        S8next  <=  S8reg;
        S9next  <=  S9reg;
        S10next <=  S10reg;
        counter1024next <= counter1024reg;
        counter512next  <= counter512reg;
        counter256next  <= counter256reg;
        counter128next  <= counter128reg;
        counter64next   <= counter64reg;
        counter32next   <= counter32reg;
        counter16next   <= counter16reg;
        counter8next    <= counter8reg;
        counter4next    <= counter4reg;
        counter2next    <= counter2reg;
                
        if ( rst = '0') then 
            
            if(counter1024reg < 1024) then 
                counter1024next <= counter1024reg +1;
            else 
                counter1024next <= "00000000001";--(others => '0');
                T1next  <=  not(T1reg);
                S1next  <=  not(S1reg);
            end if;
            
            if (unsigned(clkCounterReg) >= 1028) then 
                if(counter512reg < 511) then 
                    counter512next <= counter512reg +1;
                else 
                    counter512next <= (others => '0');
                    T2next  <=  not(T2reg);
                    S2next  <=  not(S2reg);
                end if;
            end if;
            
            if (unsigned(clkCounterReg) >= 1543) then
                if(counter256reg < 255) then 
                    counter256next <= counter256reg +1;
                else 
                    counter256next <= (others => '0');
                    T3next  <=  not(T3reg);
                    S3next  <=  not(S3reg);
                end if;
            end if;
            
            if (unsigned(clkCounterReg) >= 1802) then
                if(counter128reg < 127) then 
                    counter128next <= counter128reg +1;
                else 
                    counter128next <= (others => '0');
                    T4next  <=  not(T4reg);
                    S4next  <=  not(S4reg);
                end if;
            end if;
            
            if (unsigned(clkCounterReg) >= 1933) then
                if(counter64reg < 63) then 
                    counter64next <= counter64reg +1;
                else 
                    counter64next <= (others => '0');
                    T5next  <=  not(T5reg);
                    S5next  <=  not(S5reg);
                end if;
           end if;
            
           if (unsigned(clkCounterReg) >= 2000) then
                if(counter32reg < 31) then 
                    counter32next <= counter32reg +1;
                else 
                    counter32next <= (others => '0');
                    T6next  <=  not(T6reg);
                    S6next  <=  not(S6reg);
                end if;
           end if;
           
           if (unsigned(clkCounterReg) >= 2035) then     
                if(counter16reg < 15) then 
                    counter16next <= counter16reg +1;
                else 
                    counter16next <= (others => '0');
                    T7next  <=  not(T7reg);
                    S7next  <=  not(S7reg);
                end if;
          end if;
                
          if (unsigned(clkCounterReg) >= 2054) then      
                if(counter8reg < 7) then 
                    counter8next <= counter8reg +1;
                else 
                    counter8next <= (others => '0');
                    T8next  <=  not(T8reg);
                    S8next  <=  not(S8reg);
                end if;
         end if;
         
         if (unsigned(clkCounterReg) >= 2065) then       
                if(counter4reg < 3) then 
                    counter4next <= counter4reg +1;
                else 
                    counter4next <= (others => '0');
                    T9next  <=  not(T9reg);
                    S9next  <=  not(S9reg);
                end if;
         end if;
                                
         if (unsigned(clkCounterReg) >= 2072) then       
                if(counter2reg < 1) then 
                    counter2next <= counter2reg +1;
                else 
                    counter2next <= (others => '0');
                    T10next  <=  not(T10reg);
                    S10next  <=  not(S10reg);
                end if;
         end if;
                                        
     end if; 
         
         S11next <=  not(S11reg); -- Can start at CC: 2077 where S11 must be = '0'
         T11next <=  not(T11reg); -- Can start at CC: 2077 where T11 must be = '1'
         -- First output from stage 11 at CC: 2078, with S11 = '1' and T11 = '0'
    end process;
    --
    T1  <= T1reg;  S1  <= S1reg;
    T2  <= T2reg;  S2  <= S2reg;
    T3  <= T3reg;  S3  <= S3reg;
    T4  <= T4reg;  S4  <= S4reg;
    T5  <= T5reg;  S5  <= S5reg;
    T6  <= T6reg;  S6  <= S6reg;
    T7  <= T7reg;  S7  <= S7reg;
    T8  <= T8reg;  S8  <= S8reg;
    T9  <= T9reg;  S9  <= S9reg;
    T10 <= T10reg; S10 <= S10reg;
    T11 <= T11reg; S11 <= S11reg;
   

end Behavioral;
