LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

-- sommatore generico a N bit,
-- dove N è deciso tramite variabile
-- globale


ENTITY generic_adder is

generic (N : INTEGER);
   port( a          : in  std_logic_VECTOR (N-1 downto 0);
         b          : in  std_logic_VECTOR (N-1 downto 0);
         carry_in   : in  std_logic;
         s          : out std_logic_VECTOR (N-1 downto 0);
         carry_out  : out std_logic);
END generic_adder;

architecture BEHAVIOURAL of generic_adder is


BEGIN
    SUM:process(a,b,carry_in)
      variable C:std_logic;
     begin
      C:=carry_in;
        FOR i IN 0 TO N-1 LOOP
         s(i)<= a(i) XOR b(i) XOR C;
         C:= (a(i) AND b(i)) OR (a(i) AND C) OR (b(i) AND C);
      END LOOP;
       carry_out <= C;
      END  process SUM;

END BEHAVIOURAL;

