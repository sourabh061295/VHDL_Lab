library IEEE; 
use IEEE.std_logic_1164.all;

entity nandn is
  generic ( N: integer := 5 );
  port ( a: in  std_logic_vector(N-1 downto 0);
         y: out std_logic
       );
end;

architecture chain of nandn is

  signal x: std_logic_vector(N-1 downto 0);

begin

  x(0) <= a(0);
  gen: for i in N-1 downto 1 generate
         x(i) <=  a(i) nand x(i-1);
  end generate;
 
  y <= x(N-1);

end;

