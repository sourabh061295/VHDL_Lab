library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;
use work.functions.all;
use work.types.all;

entity skla is  -- sklansky prefix adder
   generic(N: integer := 32);
   port ( a	    : in	std_logic_vector(N-1 downto 0);
          b	    : in	std_logic_vector(N-1 downto 0);
          ci	  : in	std_logic;
          s     : out	std_logic_vector(N-1 downto 0);
	        co	  : out	std_logic
	      );
end;

architecture RTL of skla is
begin  

  process(all) 
    constant depth : natural := log2(N); 
    variable p     : arr_of_slv(depth downto 0)(N-1 downto 0); 
    variable g     : arr_of_slv(depth downto 0)(N-1 downto 0); 
  begin
  
    ------- Computation of g and p (bitwise):
    p(0) := a xor b;
    g(0) := a and b;

    -- handle the initial ci signal
    g(0)(0) := (a(0) and b(0)) or (p(0)(0) and ci); 

    ------- Computation of group g and p carry logic:
    row: for i in 1 to depth loop
      column: for j in 0 to N-1 loop
        --if a component is needed put it, else forward the p and g signals
        if (integer(floor(real(j)/real(2**(i-1)))) mod 2) = 1 then
          if j < 2**(i) then -- Grey cells
            g(i)(j) := (p(i-1)(j) and g(i-1)(j-j mod 2**(i-1)-1)) or g(i-1)(j);
            p(i)(j) := '0';  -- p does not need to be propagated
          else               -- Black cells 
            g(i)(j) := (p(i-1)(j) and g(i-1)(j-j mod 2**(i-1)-1)) or g(i-1)(j);
            p(i)(j) :=  p(i-1)(j) and p(i-1)(j-j mod 2**(i-1)-1);        
          end if;
        end if;
        --No operator, propagate the p and g signals to the next stage
        if (integer(floor(real(j)/real(2**(i-1)))) mod 2) /= 1 then
          p(i)(j) := p(i-1)(j);
          g(i)(j) := g(i-1)(j);
        end if;
      end loop column;
    end loop row;

    ------- Computation of sum and carry-out:
    s(0)   <= p(0)(0) xor ci;
    for i in 1 to N-1 loop
      s(i) <= g(depth)(i-1) xor p(0)(i);  
    end loop;
    co     <= g(depth)(N-1);
  end process;  
  
end;  


-- Pattern for black and grey cells
-- 01010101010101010101010101010101
-- 00110011001100110011001100110011
-- 00001111000011110000111100001111
-- 00000000111111110000000011111111