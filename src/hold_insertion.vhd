LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

-- questo blocco replica il segnale in ingresso
-- sui 3 colpi di clock successivi.
-- Questa entità è utilizzata nella versione
-- ottimizzata del filtro

ENTITY hold_insertion IS
  generic (N: integer := 4);
  port(
    ingresso       : in std_logic_vector(N-1 downto 0);
    clock     : in std_logic;
    reset     : in std_logic;
    uscita     : out std_logic_vector(N-1 downto 0)  
  );
END hold_insertion;

architecture BEHAVIOURAL of hold_insertion is
  
-- inizializzazioen del vettore
signal tmp : std_logic_vector(N-1 downto 0) := (others =>'0');
  
	
	begin

-- sul fronte di salita del clock
-- si decide se replicare il segnale di ingresso
-- sull uscita o mandare in output la replica
-- dell ultimo segnale ricevuto
process(clock)
  variable counter : INTEGER := 1;
begin

if rising_edge(clock) then
  if (counter=0) and reset='1' then 
  uscita <= ingresso;
  tmp <= ingresso;
  
  counter:=counter+1;
  else
   uscita <= tmp;
  counter := counter+1 ;
   if ((counter mod 4) = 0 )  then
   counter:=0;
  end if;
end if;
end if;
end process;

	    
end BEHAVIOURAL;

