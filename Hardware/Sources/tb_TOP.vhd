LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
use ieee.std_logic_textio.all;
use std.textio.all; 
 
ENTITY tb_TOP IS
END tb_TOP;
 
ARCHITECTURE behavior OF tb_TOP IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         modeSelectFftIfft : in STD_LOGIC;
         --coefficients : IN  std_logic_vector(11 downto 0);
         externalInputRe  : in std_logic_vector(11 downto 0);
         externalInputIm  : in std_logic_vector(11 downto 0);
         validOutput	  : out STD_LOGIC;
         externalOutputRe : out std_logic_vector(11 downto 0);
         externalOutputIm : out std_logic_vector(11 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal modeSelectFftIfft: std_logic := '0';
   --signal coefficients : std_logic_vector(11 downto 0) := (others => '0');
   signal externalInputRe : std_logic_vector(11 downto 0) := (others => '0');
   signal externalInputIm : std_logic_vector(11 downto 0) := (others => '0');
   
 	--Outputs
   signal validOutput      : std_logic := '0';
   signal externalOutputRe : std_logic_vector(11 downto 0);
   signal externalOutputIm : std_logic_vector(11 downto 0);

    --file definitions
    file file_INPUT_X_Re : text;
    file file_INPUT_X_Im : text;
    
   -- Clock period definitions
   constant clk_period : time := 10 ns;
   
   signal clk_counter : integer;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
          rst => rst,
          clk => clk,
          modeSelectFftIfft => modeSelectFftIfft,
          --coefficients      => coefficients,
          externalInputRe   => externalInputRe,
          externalInputIm   => externalInputIm,
          validOutput	    => validOutput,
          externalOutputRe  => externalOutputRe,
          externalOutputIm  => externalOutputIm
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   -- Test counter
   tb_counter : process(rst,clk)
    variable counter : integer;
   begin
        if (rst = '1') then
            counter := 0;
        elsif rising_edge(clk) then
            counter := counter + 1;
        end if;
        clk_counter <= counter;
   end process;
   

   -- Stimulus process
   stim_proc: process
   
   variable file_row_Re       : line;
   variable file_row_Im       : line;
   variable input_x_byte_Re   : std_logic_vector(11 downto 0);
   variable input_x_byte_Im   : std_logic_vector(11 downto 0);
   
   begin		
      -- hold reset state for 100 ns.
      rst <= '1';
      wait for 100 ns;	
      rst <= '0';
      --wait for clk_period*10;

      -- insert stimulus here 
      -- open file for reading C:\Users\ilayd\Documents\ders\etin35\FFT\inputs
      file_open(file_INPUT_X_Re, "C:/Users/ilayd/Documents/ders/etin35/FFT/inputs/fft_inputs_binary_real.txt", read_mode);
      file_open(file_INPUT_X_Im, "C:/Users/ilayd/Documents/ders/etin35/FFT/inputs/fft_inputs_binary_imaginary.txt", read_mode);
  
            
      loop
          
        wait for clk_period/2;
        -- reading row/line from file   
          readline(file_INPUT_X_Re, file_row_Re);
          readline(file_INPUT_X_Im, file_row_Im);
        -- reading 12 bits from line
          read(file_row_Re, input_x_byte_Re);
          read(file_row_Im, input_x_byte_Im);
        -- asserting input_x to input_X 
          externalInputRe <= input_x_byte_Re;
          externalInputIm <= input_x_byte_Im;
          
        wait for clk_period/2;
        
      end loop;
  
      -- closing file
      file_close(file_INPUT_X_Re);
      file_close(file_INPUT_X_Im);
      
      wait;
          
   end process;

END;
