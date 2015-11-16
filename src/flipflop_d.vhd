LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

-- generico registro flip flop
-- utilizzato per il delay negli stadi
-- comb ed integrator

ENTITY dff_n is
  generic (N:integer );
    port (
      d : in std_logic_vector(N-1 downto 0);
      clk : in std_logic;
      reset: in std_logic;
      q : out std_logic_vector(N-1 downto 0)
    );
END dff_n;

architecture BEHAVIOURAL of dff_n is
BEGIN
  DEF:Process(clk)
  begin
    if(clk = '1' and clk'EVENT) then
    for i in 0 to N-1 loop
    q(i)<=d(i) and reset;
  end loop;
  end if;
  end process DEF;  
END BEHAVIOURAL;