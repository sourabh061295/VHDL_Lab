library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity add is 
  generic (N: integer := 4);  
  port( a, b : in  std_logic_vector(N-1 downto 0); 
        ci   : in  std_logic;
        s    : out std_logic_vector(N-1 downto 0); 
        co   : out std_logic);
end;

architecture withfunc of add is
  function add ( a, b : std_logic_vector; ci : std_logic) return std_logic_vector is 
  begin
    return std_logic_vector(('0' & unsigned(a)) + ('0' & unsigned(b)) + ci);
  end; 
  signal sum: std_logic_vector(N downto 0);  
begin

  sum <= add(a,b,ci);
  s   <= sum(N-1 downto 0);
  co  <= sum(N);

  end;   
