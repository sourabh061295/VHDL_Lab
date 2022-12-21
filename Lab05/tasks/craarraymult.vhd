library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;
use work.casts.all;
use ieee.std_logic_unsigned.all;

entity craarraymult is  -- carry-ripple adder array multiplier
  generic (N: natural := 32);
  port (
    a : in  std_logic_vector(  N-1 downto 0);                    -- multiplier a
    b : in  std_logic_vector(  N-1 downto 0);                    -- muliplicand b
    p : out std_logic_vector(2*N-1 downto 0)                     -- product
  );
end;

architecture rtl of craarraymult is 

  procedure cra (a,b : in std_logic_vector; ci : in std_logic; s: out std_logic_vector) is  -- carry-ripple adder
    constant n : natural := a'length;
    variable c : std_logic_vector(n downto 0);
  begin  
    c(0) := ci;
    for j in 0 to n-1 loop
      c(j+1) := (a(j) and b(j)) or ((a(j) or b(j)) and c(j));
    end loop;
    s   := c(n) & (a xor b xor c(n-1 downto 0));
  end; 

begin  

  process(all)
    variable pp        : arr_of_slv (N-1 downto 0)(N-1 downto 0); 
    variable sum       : arr_of_slv (N-1 downto 1)(N   downto 0);
    variable c, ai, bi : std_logic_vector         (N-1 downto 0);
  begin

    for i in 0 to N-1 loop  
      pp(i) := a and (N-1 downto 0 => b(i));           -- generate all partial products
    end loop;
    ai     := '0' & pp(0)(N-1 downto 1);              -- 1st operand
    bi     := pp(1);                                  -- 2nd operand
    cra(ai, bi,'0',sum(1));                           -- first row of carry-ripple adder

    p(0)   <= a(0) and b(0);                          -- product bit 0
    p(1)   <= sum(1)(0);                              -- product bit 1

    for j in 2 to N-1 loop                            -- partial product reduction
      ai   :=  sum(j-1)(N downto 1);                  -- 1st operand
      bi   :=  pp(j);                                 -- 2nd operand
      cra(ai, bi,'0',sum(j));                         -- sum up the partial products with use of carry-ripple adder
      p(j) <= sum(j)(0);                              -- product bit j
    end loop;  

    p(2*N-1 downto N-1) <= sum(N-1);                  -- upper product bits

  end process;  

end;