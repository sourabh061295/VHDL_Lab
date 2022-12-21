library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
--use work.lab.all;

entity circuit is
  port (
    clk, reset : in  std_logic;
    o          : out std_logic_vector(7 downto 0)
    );
end;

architecture rtl of circuit is
  signal x : unsigned(7 downto 0);
begin

  x <= (others=>'0') when reset = '1' else
       x + 1         when rising_edge(clk);
    
  o <= (x(7) & 
       (x(7) xor x(6)) & 
       (x(6) xor x(5)) & 
       (x(5) xor x(4)) & 
       (x(4) xor x(3)) & 
       (x(3) xor x(2)) & 
       (x(2) xor x(1)) & 
       (x(1) xor x(0)) ); 
end;