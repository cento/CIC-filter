library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- test effettuato con segnali controllati, e sul filtro
-- realizzato con semplificazione MSB
-- (pessimi risultati)


ENTITY cic_easy_tb IS
END cic_easy_tb;

ARCHITECTURE cic_test OF cic_easy_tb IS
  component cic_easy
    generic (N: integer:=16);
  port(
    ingresso  : in std_logic_vector(N-1 downto 0);
    clock_slow     : in std_logic;
    clock_fast     : in std_logic;
    reset       : in std_logic; 
    uscita     : out std_logic_vector(N-1 downto 0)  
  );
END component;

  CONSTANT N       :  INTEGER  := 16;       -- Bus Width
   CONSTANT MckPer  :  TIME     := 400 ns;  -- Master Clk period
   CONSTANT SlvPer  : TIME    :=  100 ns;
   CONSTANT TestLen :  INTEGER  := 70;      -- No. of Count (MckPer/2) for test
   

   signal clock1 : std_logic := '0';
   signal clock2 : std_logic := '0';
   signal reset : std_logic := '0';
   
   signal input : std_logic_vector(N-1 downto 0):= "0000000000000000" ;
   signal output : std_logic_vector(N-1 downto 0);
   
   SIGNAL clk_cycle : INTEGER ;
   SIGNAL Testing: Boolean := True;
   
   BEGIN
  
  I: cic_easy
  PORT MAP(input,clock1,clock2,reset,output);
     clock1 <= NOT clock1 AFTER MckPer/2 WHEN Testing ELSE '0';
     clock2 <= NOT clock2 AFTER SlvPer/2 WHEN Testing ELSE '0';
    
    Test_Proc: PROCESS(clock1)
      VARIABLE count: INTEGER:= 0;
   BEGIN
     clk_cycle <= (count+1)/2;

     CASE count IS
 
       WHEN 1 => input <= "0000000000000000" ; reset <= '1';

         WHEN  3  => input <= "0000000000000001";
         WHEN  5  => input <= "0000000000000010";
         WHEN  7  => input <= "0000000000000101";
         WHEN  9  => input <= "0000000000001010";
         WHEN  11  => input <=  "0000000000000101";
         WHEN  13  => input <= "0000000000001010";
         WHEN  15  => input <= "0000000000001011";
         WHEN  17  => input <= "0000000000001111";
         WHEN  19  => input <= "0000000000001000";
         WHEN  21  => input <=  "0000000000000011";
         WHEN  23  => input <=  "0000000000011110";
         WHEN  25  => input <=  "0000000000000001";  
           
         WHEN  27  => input <= "1111111111111101";
         WHEN  29 => input <= "1111111111101100";
         WHEN  31  => input <= "1111111111111001";
         WHEN  33  => input <= "0000000000001010";
         WHEN  35  => input <=  "1111111111111111";
         WHEN  37  => input <= "1111111111111011";
         WHEN  39  => input <= "1111111111110001";
         WHEN  41  => input <= "1111111111010011";
         WHEN  43  => input <= "1111111111100010";
         WHEN  45  => input <=  "1111111111100011";
         WHEN  47  => input <=  "0000000000000010";
         WHEN  49  => input <=  "0000000000000001";
         
          
         WHEN  51  => input <=  "0000000000000000"; 


          WHEN (TestLen - 1) =>   Testing <= False;
          WHEN OTHERS => NULL;
     END CASE;

     count:= count + 1;
   END PROCESS Test_Proc;
     
   END cic_test;

