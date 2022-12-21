library IEEE; 
use IEEE.std_logic_1164.all;

entity mux2n is
  generic ( N: integer := 8 );
  port    ( d0, d1: in  std_logic_vector(N-1 downto 0); 
            s     : in  std_logic; 
            y     : out std_logic_vector(N-1 downto 0)
          );
end;

architecture synth of mux2n is
begin 

  y <= d1 when s='1' else d0;

end;