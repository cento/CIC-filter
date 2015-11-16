LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

-- Questa entità effettua la zero-insertion
-- richiesta nelle specifiche: inserisce zeri 
-- negli R-1 segnali in ingresso a frequenza <clock>

ENTITY zero_insertion IS
  generic (N: integer);
  port(
    ingresso       : in std_logic_vector(N-1 downto 0);
    clock     : in std_logic;
    reset     : in std_logic;
    uscita     : out std_logic_vector(N-1 downto 0)  
  );
END zero_insertion;

architecture BEHAVIOURAL of zero_insertion is

  
	
	begin


-- effettua l inserimento in ogni ciclo,
-- tranne il primo di gruppi di 4, nel quale
-- in uscita viene fornito l ingresso
process(clock)
  variable counter : INTEGER := 1;
begin

if rising_edge(clock) then
  if (counter=0) and reset='1' then 
  uscita <= ingresso;
  counter:=counter+1;
  else
   for i in N-1 downto 0 LOOP
   uscita(i) <=  '0';
  end LOOP;
  counter := counter+1 ;
   if ((counter mod 4) = 0 )  then
   counter:=0;
  end if;
end if;
end if;
end process;

	    
end BEHAVIOURAL;
