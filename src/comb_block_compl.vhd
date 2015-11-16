LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

-- blocco comb, realizzato tramite un registro
-- che fornisce l input del sommatore a frequenza
-- data dal clock.
-- Il dato viene memorizzato nel registro in 
-- complemento a 2, cosi che il sommatore funzioni
-- come sottrattore

ENTITY comb_block_c IS
  generic (N: integer );
  port(
    input      : in std_logic_vector(N-1 downto 0);
    carry_in   : in std_logic;
    clock     : in std_logic;
    reset     : in std_logic;
    carry_out : out std_logic;
    output     : out std_logic_vector(N-1 downto 0)
  );
END comb_block_c;

architecture BEHAVIOURAL of comb_block_c is
  
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
    
component complement 
  generic (N:integer);
   port (
    input : in std_logic_vector(N-1 downto 0);
    output : out std_logic_vector(N-1 downto 0)
  ); 
end component;

signal addendo : std_logic_vector(N-1 downto 0);
signal input_complement : std_logic_vector(N-1 downto 0);

begin

  DDF: dff_n
  generic map (N)
  port map(input_complement,clock,reset,addendo);
    
  COM: complement
  generic map(N)
  port map(input,input_complement);
    
  ADD: generic_adder
  generic map (N)
  port map(input,addendo,carry_in,output,carry_out);


  
end BEHAVIOURAL;