library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.casts.all;

entity add is 
  generic (N: integer := 8);  
  port( a, b : in  std_logic_vector(N-1 downto 0); 
        ci   : in  std_logic;
        s    : out std_logic_vector(N-1 downto 0); 
        co   : out std_logic
      );
end;

architecture withplus of add is
  signal sum: std_logic_vector(N downto 0);  
begin

  ------ Convert to integer and add, and convert the result back to std logic vector
  sum <= to_slv((to_int(a) + to_int(b) + to_int(ci)), N+1);
  s   <= sum(N-1 downto 0);
  co  <= sum(N);

end;  
