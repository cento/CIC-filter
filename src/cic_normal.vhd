LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

-- implementazione del CIC con organizzazione classica
-- ovvero comb - zeroinsertion - integrator

-- ho inserito due clock per evitare l inserimento di un
-- oscillatore interno. Essendo uno strumento di 
-- interpolazione, la frequenza di uscita sarà maggiore
-- di quella di ingresso,

ENTITY cic_normal IS
  generic (N: integer :=16);
  port(
    ingresso  : in std_logic_vector(N-1 downto 0);
    clock_slow     : in std_logic;
    clock_fast     : in std_logic;
    reset       : in std_logic; 
    uscita     : out std_logic_vector(N-1 downto 0)
  );
END cic_normal;

architecture BEHAVIOURAL of cic_normal is
  
  component integrator_block
  generic (N:integer );
  port(
    input      : in std_logic_vector(N-1 downto 0);
    carry_in   : in std_logic;
    clock     : in std_logic;
    reset     : in std_logic;
    carry_out : out std_logic;
    output     : out std_logic_vector(N-1 downto 0)
  );
end component;

component comb_block_c
  generic (N:integer );
  port(
    input      : in std_logic_vector(N-1 downto 0);
    carry_in   : in std_logic;
    clock     : in std_logic;
    reset     : in std_logic;
    carry_out : out std_logic;
    output     : out std_logic_vector(N-1 downto 0)
  );
end component;

component shifter_n 
generic (M:integer ; N:integer);
  port (
    input : in std_logic_vector(M-1 downto 0);
    output : out std_logic_vector(N-1 downto 0)
  );   
end component; 
 

component zero_insertion 
  generic (N: integer);
  port(
    ingresso       : in std_logic_vector(N-1 downto 0);
    clock     : in std_logic;
    reset     : in std_logic;
    uscita     : out std_logic_vector(N-1 downto 0)  
  );
END component;


-- la costante M è calcolata secondo una precisa formula,
-- descritta nella relazione. La formula prevede
-- il calcolo della dimensione massima di ogni stadio,
-- compreso l ultimo (M)
constant M : integer := N+6;

-- Ho usato un array di carry out per facilitare
-- il debug. Infatti se il filtro funziona, non avremo
-- mai carry out, e questo è verificabile 
-- ispezioanndo l array
type myarray is array(7 downto 0) of std_logic;
signal carry : myarray ;


-- sono stati usati numerosi segnali separati
-- per interconnettere i vari step
-- Questo permette anche un facile debug, infatti
-- il segnale9 è quello che esce dall ultimo stadio
-- integrator e a M bit, cosi da verificarne la
-- forma d onda con la versione arrotondata al
-- bit MSB o LSB
signal ingressoe : std_logic_vector(N downto 0) ;
signal segnale1 : std_logic_vector(N downto 0) ;
signal segnale2 : std_logic_vector(N+1 downto 0) ;
signal segnale3 : std_logic_vector(N+2 downto 0) ;
signal segnale4 : std_logic_vector(N+3 downto 0) ;
signal segnale5 : std_logic_vector(N+3 downto 0) ;
signal segnale6 : std_logic_vector(N+3 downto 0) ;
signal segnale7 : std_logic_vector(N+3 downto 0) ;
signal segnale8 : std_logic_vector(N+4 downto 0) ;
signal segnale9 : std_logic_vector(N+5 downto 0) ;

signal segnale1e : std_logic_vector(N+1 downto 0) ;
signal segnale2e : std_logic_vector(N+2 downto 0) ;
signal segnale3e : std_logic_vector(N+3 downto 0) ;
signal segnale4e : std_logic_vector(N+4 downto 0) ;
signal segnale5e : std_logic_vector(N+4 downto 0) ;
signal segnale6e : std_logic_vector(N+4 downto 0) ;
signal segnale7e : std_logic_vector(N+4 downto 0) ;
signal segnale8e : std_logic_vector(N+5 downto 0) ;
  
signal check : std_logic := '0';
  
begin
          
  
  SH1: shifter_n
  generic map( N,N+1)
  port map(ingresso,ingressoe); 
  
  COMB0: comb_block_c
  generic map(N+1)
  port map(ingressoe,'0',clock_slow,reset,carry(0),segnale1);
 
  SH2: shifter_n
  generic map(N+1,N+2)
  port map(segnale1,segnale1e);    
    
  COMB1: comb_block_c
  generic map(N+2)
  port map(segnale1e,'0',clock_slow,reset,carry(1),segnale2);
  
  SH3: shifter_n
  generic map(N+2,N+3)
  port map(segnale2,segnale2e);  
    
  COMB2: comb_block_c
  generic map(N+3)
  port map(segnale2e,'0',clock_slow,reset,carry(2),segnale3);
    
  SH4: shifter_n
  generic map(N+3,N+4)
  port map(segnale3,segnale3e); 
    
  COMB3: comb_block_c
  generic map(N+4)
  port map(segnale3e,'0',clock_slow,reset,carry(3),segnale4);
    
  ZIN: zero_insertion
  generic map(N+4)
  port map(segnale4,clock_fast,reset,segnale5);
    
  INT1: integrator_block
  generic map(N+4)
  port map(segnale5,'0',clock_fast,reset,carry(4),segnale6);
    
  INT2: integrator_block
  generic map(N+4)
  port map(segnale6,'0',clock_fast,reset,carry(5),segnale7);
    
  SH5: shifter_n
  generic map(N+4,N+5)
  port map(segnale7,segnale7e); 
  
  INT3: integrator_block
  generic map(N+5)
  port map(segnale7e,'0',clock_fast,reset,carry(6),segnale8);
    
  SH6: shifter_n
  generic map(N+5,N+6)
  port map(segnale8,segnale8e); 

  INT4: integrator_block
  generic map(N+6)
  port map(segnale8e,'0',clock_fast,reset,carry(7),segnale9);
    
-- sull ultimo segnale avviene la semplificazione 
-- sul MSB, ovvero si tagliano i picchi:
-- se il valore di uscita è piu grande del massimo
-- rappresentabile, in uscita va il massimo rappresentabile
-- altrimenti se supera il limite inferiore, in uscita
-- avremo il valore minimo possibile su N bit
  process(segnale9)
    begin
      TRUNK: for i in 0 to N-1 loop
        uscita(i) <= segnale9(i);
      end loop;

    
    if segnale9(M-1) = '0' then
      DIO1: for i in M-2 downto N-1 loop
        if segnale9(i) /= '0' then
          uscita <= "0111111111111111";
          exit;
        end if;
      end loop;
    end if;
    if segnale9(M-1) = '1' then
      DIO2: for i in M-2 downto N-1 loop
        if segnale9(i) /= '1' then
          uscita <= "1000000000000000";
          exit;
        end if;
      end loop;
    end if;
   

 end process;

    
end BEHAVIOURAL;
