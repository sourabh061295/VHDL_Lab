library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package types is
  subtype byte         is       natural range 7 downto 0;
  subtype logic        is       std_logic;
  subtype byteT        is       std_logic_vector(byte);
  type arr_of_slv      is       array (natural range <>) of std_logic_vector; 
end;

package body types is

end;