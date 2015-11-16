library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- questa entity è utilizzata nei testbench
-- per generare valori casuali di dimensione <width>
-- Questi valori vendon dati in pasto al filto CIC
-- per verificarne le prestazioni


entity random is
    generic ( width : integer :=  16 ); 
port (
      clk : in std_logic;
      random_num : out std_logic_vector (width-1 downto 0)             
    );
end random;

architecture Behavioral of random is
begin
  
  -- l algoritmo è utilizzato in numerosi generatori 
  -- pseudocasuali esistenti
  process(clk)
    variable rand_temp : std_logic_vector(width-1 downto 0):=(width-1 => '1',others => '0');
    variable temp : std_logic := '0';
  
  begin
    if(rising_edge(clk)) then
      temp := rand_temp(width-1) xor rand_temp(width-2);
      rand_temp(width-1 downto 1) := rand_temp(width-2 downto 0);
      rand_temp(0) := temp;
  end if;


  random_num <= rand_temp;
end process;

end Behavioral;