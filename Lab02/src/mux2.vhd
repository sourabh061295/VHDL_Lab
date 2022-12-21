library IEEE; 
use IEEE.std_logic_1164.all;

entity mux2 is
  port( d0, d1: in  std_logic_vector(3 downto 0);
        s     : in  std_logic;
        y     : out std_logic_vector(3 downto 0)
      );
end;

architecture synth of mux2 is
begin

  y <= d1 when s='1' else 
       d0;

end;