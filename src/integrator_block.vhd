LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


-- blocco integrator. Realizzato come indicato nelle
-- specifiche allegate, presenta un vettore di 
-- carryout utilizzato per verificare il corretto
-- funzionamento (infatti se i blocchi sono dimensionati
-- correttamente, non devono esserci segnali di carry out)

ENTITY integrator_block IS
  generic (N: integer:=2 );
  port(
    input      : in std_logic_vector(N-1 downto 0);
    carry_in   : in std_logic;
    clock     : in std_logic;
    reset     : in std_logic;
    carry_out : out std_logic;
    output     : out std_logic_vector(N-1 downto 0)
  );
END integrator_block;

architecture BEHAVIOURAL of integrator_block is
  
component dff_n
  generic (N: integer);
    port(
        d : in std_logic_vector(N-1 downto 0);
        clk : in std_logic;
        reset: in std_logic;
        q : out std_logic_vector(N-1 downto 0)
      );
  end component;
  
component generic_adder
  generic (N:integer);
     port( a          : in  std_logic_VECTOR (N-1 downto 0);
         b          : in  std_logic_VECTOR (N-1 downto 0);
         carry_in   : in  std_logic;
         s          : out std_logic_VECTOR (N-1 downto 0);
         carry_out  : out std_logic
         );
end component;
    


signal addendo : std_logic_vector(N-1 downto 0);
signal output2 : std_logic_vector(N-1 downto 0);

begin
  


  DDF: dff_n
  generic map (N)
  port map(output2,clock,reset,addendo);
    
    
  ADD: generic_adder
  generic map (N)
  port map(input,addendo,carry_in,output2,carry_out);
    output <= output2;


  
end BEHAVIOURAL;
