library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- testo effettuato sul filtro CIC non semplificato
-- e come input un segnale generato da un generatore
-- pseudocasuale

ENTITY cic_normal_random_tb IS
END cic_normal_random_tb;

ARCHITECTURE cic_test OF cic_normal_random_tb IS
  component cic_normal
    generic (N: integer:=16);
  port(
    ingresso  : in std_logic_vector(N-1 downto 0);
    clock_slow     : in std_logic;
    clock_fast     : in std_logic;
    reset       : in std_logic;
    uscita     : out std_logic_vector(N-1 downto 0)  
  );
END component;

component random is
    generic ( width : integer :=  16 ); 
port (
      clk : in std_logic;
      random_num : out std_logic_vector (width-1 downto 0)   --output vector            
    );
end component;

  CONSTANT N       :  INTEGER  := 16;       -- Bus Width
   CONSTANT MckPer  :  TIME     := 400 ns;  -- Master Clk period
   CONSTANT SlvPer  : TIME    :=  100 ns;
   CONSTANT TestLen :  INTEGER  := 700;      -- No. of Count (MckPer/2) for test
   

   signal clock1 : std_logic := '0';
   signal clock2 : std_logic := '0';
   signal reset : std_logic := '0';
   
   signal rinput : std_logic_vector(N-1 downto 0) ;
   signal output : std_logic_vector(N-1 downto 0);
   
   SIGNAL clk_cycle : INTEGER ;
   SIGNAL Testing: Boolean := True;
   
   BEGIN
  
  R: random
  port map(clock1,rinput);
  
  I: cic_normal
  PORT MAP(rinput,clock1,clock2,reset,output);
     clock1 <= NOT clock1 AFTER MckPer/2 WHEN Testing ELSE '0';
     clock2 <= NOT clock2 AFTER SlvPer/2 WHEN Testing ELSE '0';
    
    Test_Proc: PROCESS(clock1)
      VARIABLE count: INTEGER:= 0;
   BEGIN
     clk_cycle <= (count+1)/2;

     CASE count IS
 
       WHEN 1 =>  reset <= '1';

          WHEN (TestLen - 1) =>   Testing <= False;
          WHEN OTHERS => NULL;
     END CASE;

     count:= count + 1;
   END PROCESS Test_Proc;
     
   END cic_test;

