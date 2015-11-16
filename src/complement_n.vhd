library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

-- questa entità effettua il complemento a 2
-- del dato in ingresso

entity complement is
  generic (N:integer  );
  port (
    input : in std_logic_vector(N-1 downto 0);
    output : out std_logic_vector(N-1 downto 0)
  );   
end complement; 

architecture BEHAVIORAL of complement is 
 
  
begin
  process(input)
    variable uno : std_logic_vector(N-1 downto 0);
    begin
  for i in 1 to N-1 loop
    uno(i) := '0';
  end loop;
  uno(0) := '1';
  output <= (NOT input) + uno;
end process;
  
  
  
  
end BEHAVIORAL;

