library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package types is
  constant width : integer := 32;
  subtype byte         is       natural range 7 downto 0;
  subtype logic        is       std_logic;
  subtype byteT        is       std_logic_vector(byte);
  subtype word         is       std_logic_vector(width-1 downto 0);
  subtype uword        is       unsigned(width-1 downto 0);
  subtype sword        is       signed  (width-1 downto 0);
  type arr_of_slv      is       array   (natural range <>) of std_logic_vector;
  type arr_of_unsigned is       array   (natural range <>) of unsigned;
  type matrix          is       array   (natural range <>, natural range <>) of std_logic;
end;

package body types is

end;

