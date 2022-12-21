library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;
use work.casts.all;
use ieee.std_logic_unsigned.all;

entity csaarraymult is  -- carry-save adder array multiplier
  generic (N: natural := 32);
  port (
    a : in  std_logic_vector(  N-1 downto 0);                    -- multiplier a
    b : in  std_logic_vector(  N-1 downto 0);                    -- muliplicand b
    p : out std_logic_vector(2*N-1 downto 0)                     -- product
  );
end;

architecture rtl of csaarraymult is 

  procedure csa (a, b, ci : in std_logic_vector; co, s: out std_logic_vector) is          -- full adder
    constant n : natural := a'length;
  begin  
    co := (a and b) or (a and ci) or (b and ci);
    s  := a xor b xor ci;
  end; 

  procedure cra (a,b : in std_logic_vector; ci : in std_logic; s: out std_logic_vector) is -- carry-ripple adder
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
    variable pp        : arr_of_slv (N-1 downto 0)(N-1 downto 0);   -- partial products
    variable s, co     : arr_of_slv (N-1 downto 2)(N-1 downto 0);   -- sums and carry-outs per row
    variable ai, bi, ci: std_logic_vector         (N-1 downto 0);   -- internal a, b, carrys
    variable sum       : std_logic_vector         (N   downto 0);   -- internal sum
  begin
    
    for i in 0 to N-1 loop                        
      pp(i) := a and (N-1 downto 0 => b(i));      -- generate partial products
    end loop;

    ai   := '0' & pp(0)(N-1 downto 1);            -- 1th operand of csa, use of partial product 0
    bi   :=  pp(1);                               -- 2nd operand of csa, use of partial product 1
    ci   :=  pp(2)(N-2 downto 0) & '0';           -- 3rd operand of csa, use of partial product 2
 
    csa(ai, bi, ci, co(2), s(2));                 -- first row of carry-save adder

    p(0) <= a(0) and b(0);                        -- product bit 0
    p(1) <= s(2)(0);                              -- product bit 1

    for j in 3 to N-1 loop                        -- partial product reduction array
      ai := pp(j-1)(N-1) & s(j-1)(N-1 downto 1);  -- 1st operand 
      bi := pp(j)(N-2  downto 0) & '0';           -- 2nd operand
      ci := co(j-1);                              -- 3rd operand
      csa(ai, bi, ci, co(j), s(j));               -- carry save adder 
      p(j-1) <= s(j)(0);                          -- product bit
    end loop;  

    ai   := pp(N-1)(N-1) & s(N-1)(N-1 downto 1);  -- 1st operand
    bi   := co(N-1);                              -- 2nd operand 
    cra(ai, bi, '0', sum);                        -- last row: cpa adder (carry-ripple adder)
    p(2*N-1 downto N-1) <= sum;                   -- upper product bits

  end process;  

end;

-- N            :         8        16        32        64

--                          Area                        
-- craarraymult :     701.44   2910.04  11290.37  47816.16
-- csaarraymult :     530.14   2010.43   7524.34  30008.79
--    arraymult :     485.98   1832.21   8847.96  36020.66

--                       Fmax [MHz]                     
-- craarraymult :     552.49    245.10    118.76      0.00
-- csaarraymult :     800.00    359.71    178.25      0.00
--    arraymult :     666.67    297.62    112.87      0.00

--                       Power [mW]                     
-- craarraymult :      38.30    184.00    766.00   3470.00
-- csaarraymult :      24.50    111.00    462.00   2040.00
--    arraymult :      21.00     98.10    566.00   2570.00