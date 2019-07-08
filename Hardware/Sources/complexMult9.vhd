library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity complexMult9 is
  generic (w1  : integer;
            w2 : integer);
  port (
    clk         : in  std_logic;
    rst         : in  std_logic;
    counter4Bit : in  std_logic_vector (3 downto 0);
    multInRe    : in  std_logic_vector((w1-1) downto 0);
    multInIm    : in  std_logic_vector((w1-1) downto 0);
    multOutRe   : out std_logic_vector((w2-1) downto 0);
    multOutIm   : out std_logic_vector((w2-1) downto 0));
end complexMult9;

architecture Behavioral of complexMult9 is

--Input registers for critical path
  signal multInReNext, multInImNext : signed((w1-1) downto 0);
  signal multInReReg , multInImReg  : signed((w1-1) downto 0);

-- For testing
  signal test1, test2, test3, test4 : std_logic_vector(15 downto 0);
  signal test_re_in, test_im_in     : signed(15 downto 0);

  -- Signal Real coefficient - Real input
  -- Level 1
  signal add11ReReg, add11ReNext     : signed(20 downto 0);
  signal add12ReReg, add12ReNext     : signed(23 downto 0);
  signal add13ReReg, add13ReNext     : signed(24 downto 0);
  -- Level 2
  signal add21ReReg, add21ReNext     : signed(24 downto 0);
  signal add22ReReg, add22ReNext     : signed(24 downto 0);
  -- Signal Real coefficient - Imaginary input
  -- Level 1
  signal add11CRIMReg, add11CRIMNext : signed(20 downto 0);
  signal add12CRIMReg, add12CRIMNext : signed(23 downto 0);
  signal add13CRIMReg, add13CRIMNext : signed(24 downto 0);
  -- Level 2
  signal add21CRIMReg, add21CRIMNext : signed(24 downto 0);
  signal add22CRIMReg, add22CRIMNext : signed(24 downto 0);

  signal multCRRe45Reg, multCRRe45Next : signed((25) downto 0);
  signal multCRIm45Reg, multCRIm45Next : signed((25) downto 0);
  signal multCIIm45Reg, multCIIm45Next : signed((25) downto 0);
  signal multCIRe45Reg, multCIRe45Next : signed((25) downto 0);

  -- Level 3
  signal complexReoutReg, complexReoutNext       : signed((25) downto 0);
  signal complexImoutReg, complexImoutNext       : signed((25) downto 0);
  signal complexReoutReg135, complexReoutNext135 : signed((25) downto 0);
  signal complexImoutReg135, complexImoutNext135 : signed((25) downto 0);

  signal delay1ReReg, delay2ReReg, delay3ReReg, delay4ReReg     : signed(15 downto 0);
  signal delay1ReNext, delay2ReNext, delay3ReNext, delay4ReNext : signed(15 downto 0);
  signal delay1ImReg, delay2ImReg, delay3ImReg, delay4ImReg     : signed(15 downto 0);
  signal delay1ImNext, delay2ImNext, delay3ImNext, delay4ImNext : signed(15 downto 0);

begin

  multInReNext <= signed(multInRe);
  multInImNext <= signed(multInIm);

  register_logic_dedicatedMult : process(clk, rst)
  begin
    if(rst = '1') then
      multInReReg        <= (others => '0');
      multInImReg        <= (others => '0');
      add11ReReg         <= (others => '0');
      add12ReReg         <= (others => '0');
      add13ReReg         <= (others => '0');
      add21ReReg         <= (others => '0');
      add22ReReg         <= (others => '0');
      multCRRe45Reg      <= (others => '0');
      multCRIm45Reg      <= (others => '0');
      multCIRe45Reg      <= (others => '0');
      multCIIm45Reg      <= (others => '0');
      delay1ReReg        <= (others => '0');
      delay2ReReg        <= (others => '0');
      delay3ReReg        <= (others => '0');
      delay4ReReg        <= (others => '0');
      delay1ImReg        <= (others => '0');
      delay2ImReg        <= (others => '0');
      delay3ImReg        <= (others => '0');
      delay4ImReg        <= (others => '0');
      add11CRIMReg       <= (others => '0');
      add12CRIMReg       <= (others => '0');
      add13CRIMReg       <= (others => '0');
      add21CRIMReg       <= (others => '0');
      add22CRIMReg       <= (others => '0');
      complexReoutReg    <= (others => '0');
      complexImoutReg    <= (others => '0');
      complexReoutReg135 <= (others => '0');
      complexImoutReg135 <= (others => '0');
    elsif(clk'event and clk = '1') then
      multInReReg        <= multInReNext;
      multInImReg        <= multInImNext;
      add11ReReg         <= add11ReNext;
      add12ReReg         <= add12ReNext;
      add13ReReg         <= add13ReNext;
      add21ReReg         <= add21ReNext;
      add22ReReg         <= add22ReNext;
      multCRRe45Reg      <= multCRRe45Next;
      multCRIm45Reg      <= multCRIm45Next;
      multCIRe45Reg      <= multCIRe45Next;
      multCIIm45Reg      <= multCIIm45Next;
      delay1ReReg        <= delay1ReNext;
      delay2ReReg        <= delay2ReNext;
      delay3ReReg        <= delay3ReNext;
      delay4ReReg        <= delay4ReNext;
      delay1ImReg        <= delay1ImNext;
      delay2ImReg        <= delay2ImNext;
      delay3ImReg        <= delay3ImNext;
      delay4ImReg        <= delay4ImNext;
      add11CRIMReg       <= add11CRIMNext;
      add12CRIMReg       <= add12CRIMNext;
      add13CRIMReg       <= add13CRIMNext;
      add21CRIMReg       <= add21CRIMNext;
      add22CRIMReg       <= add22CRIMNext;
      complexReoutReg    <= complexReoutNext;
      complexImoutReg    <= complexImoutNext;
      complexReoutReg135 <= complexReoutNext135;
      complexImoutReg135 <= complexImoutNext135;
    end if;
  end process;

  dedicated_Mult_L1 : process(multInReReg, multInImReg)

    variable CRshifted2Re : signed(17 downto 0);
    variable CRshifted4Re : signed(19 downto 0);
    variable CRshifted6Re : signed(21 downto 0);
    variable CRshifted7Re : signed(22 downto 0);
    variable CRshifted9Re : signed(24 downto 0);
    variable CRshifted2Im : signed(17 downto 0);
    variable CRshifted4Im : signed(19 downto 0);
    variable CRshifted6Im : signed(21 downto 0);
    variable CRshifted7Im : signed(22 downto 0);
    variable CRshifted9Im : signed(24 downto 0);

  begin

    CRshifted2Re := multInReReg & "00";
    CRshifted4Re := multInReReg & "0000";
    CRshifted6Re := multInReReg & "000000";
    CRshifted7Re := multInReReg & "0000000";
    CRshifted9Re := multInReReg & "000000000";

    CRshifted2Im := multInImReg & "00";
    CRshifted4Im := multInImReg & "0000";
    CRshifted6Im := multInImReg & "000000";
    CRshifted7Im := multInImReg & "0000000";
    CRshifted9Im := multInImReg & "000000000";

    -- Coefficient Real, Real input
    if (multInReReg(15) = '0') then
      add11ReNext <= ("000" & CRshifted2Re) + ('0' & CRshifted4Re);
      add12ReNext <= ("00" & CRshifted6Re) + ('0' & CRshifted7Re);
    else
      add11ReNext <= ("111" & CRshifted2Re) + ('1' & CRshifted4Re);
      add12ReNext <= ("11" & CRshifted6Re) + ('1' & CRshifted7Re);
    end if;
    add13ReNext <= CRshifted9Re;

    -- Coefficient Real, Imaginary input
    if (multInImReg(15) = '0') then
      add11CRIMNext <= ("000" & CRshifted2Im) + ('0' & CRshifted4Im);
      add12CRIMNext <= ("00" & CRshifted6Im) + ('0' & CRshifted7Im);
    else
      add11CRIMNext <= ("111" & CRshifted2Im) + ('1' & CRshifted4Im);
      add12CRIMNext <= ("11" & CRshifted6Im) + ('1' & CRshifted7Im);
    end if;
    add13CRIMNext <= CRshifted9Im;
    
  end process;

  dedicated_Mult_L2_CR : process(add11ReReg, add12ReReg, add13ReReg, add11CRIMReg, add12CRIMReg, add13CRIMReg)
  begin
    if (add11ReReg(20) = '0') then
      add21ReNext <= ("0000" & add11ReReg) + ('0' & add12ReReg);
    else
      add21ReNext <= ("1111" & add11ReReg) + ('1' & add12ReReg);
    end if;
    add22ReNext <= add13ReReg;

    if (add11CRIMReg(20) = '0') then
      add21CRIMNext <= ("0000" & add11CRIMReg) + ('0' & add12CRIMReg);
    else
      add21CRIMNext <= ("1111" & add11CRIMReg) + ('1' & add12CRIMReg);
    end if;
    add22CRIMNext <= add13CRIMReg;
  end process;

  -- Pass through buffers
  delay1ReNext <= signed(multInReReg);
  delay2ReNext <= delay1ReReg;
  delay3ReNext <= delay2ReReg;
  delay4ReNext <= delay3ReReg;

  delay1ImNext <= signed(multInImReg);
  delay2ImNext <= delay1ImReg;
  delay3ImNext <= delay2ImReg;
  delay4ImNext <= delay3ImReg;

  multCRRe45Next <= ('0' & add21ReReg) + ('0' & add22ReReg)     when (add21ReReg(24) = '0')   else ('1' & add21ReReg) + ('1' & add22ReReg);
  multCRIm45Next <= ('0' & add21CRImReg) + ('0' & add22CRImReg) when (add21CRImReg(24) = '0') else ('1' & add21CRImReg) + ('1' & add22CRImReg);
  multCIIm45Next <= not(multCRIm45Next)+1;
  multCIRe45Next <= not(multCRRe45Next)+1;

  complexReoutNext    <= (multCRRe45Reg - multCIIm45Reg);
  complexImoutNext    <= (multCRIm45Reg + multCIRe45Reg);
  complexReoutNext135 <= (multCIRe45Reg - multCIIm45Reg);
  complexImoutNext135 <= (multCIIm45Reg + multCIRe45Reg);

  test1 <= std_logic_vector(complexReoutReg(25 downto 10));
  test2 <= std_logic_vector(complexReoutReg135(25 downto 10));

  test3 <= std_logic_vector(complexImoutReg(25 downto 10));
  test4 <= std_logic_vector(complexImoutReg135(25 downto 10));

  with counter4Bit select
    multOutRe <= "0000000000000000" when "0000",  --0
    test2                           when "1000",  --8 ,          -135degree
    std_logic_vector(delay4ImReg)   when "0111",  --7            -90 degree  (b-ja)
    test1                           when "0110",  --6 ,          -45 degree
    std_logic_vector(delay4ReReg)   when others;  --1,2,3,4,5    (           (a+jb)

  with counter4Bit select
    multOutIm <= "0000000000000000"      when "0000",  --0
    test4                                when "1000",  --8            -135degree
    std_logic_vector(not(delay4ReReg)+1) when "0111",  --7            -90 degree  (b-ja)
    test3                                when "0110",  --6            -45 degree  
    std_logic_vector(delay4ImReg)        when others;  --1,2,3,4,5                (a+jb)

end Behavioral;
