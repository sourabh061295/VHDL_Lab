library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult is  -- unsigned multiplier
  generic (N: natural := 4);
  port (
    a : in  std_logic_vector(  N-1 downto 0):="0011";
    b : in  std_logic_vector(  N-1 downto 0):="0110";
    p : out std_logic_vector(2*N-1 downto 0)
  );
end;

architecture rtl of mult is
begin

    p <= std_logic_vector(unsigned(a) * unsigned(b)); 

end;

