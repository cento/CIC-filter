library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

-- il modulo shifter è stato realizzato
-- allo scopo di estendere il segnale in ingresso
-- ad ogni stadio, in modo da non dover
-- recuperarei i carry_out in uscita.

entity shifter_n is
generic (M:integer ; N:integer );
  port (
    input : in std_logic_vector(M-1 downto 0);
    output : out std_logic_vector(N-1 downto 0)
  );   
end shifter_n; 

architecture BEHAVIORAL of shifter_n is
begin
  process(input)
    begin
  for  i in 0 to M-1 loop
  output(i) <= input(i);
  end loop;
  for i in M to N-1 loop
  if input(M-1) = '0' then  
  output(i) <= '0';
  else
    if input(M-1) = '1' then
   output(i) <= '1';
   else 
   output(i) <= input(M-1);
   end if;
 end if;
  end loop; 
  end process;
end BEHAVIORAL;

