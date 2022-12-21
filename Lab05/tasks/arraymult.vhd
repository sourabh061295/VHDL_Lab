library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;
use work.casts.all;
use ieee.std_logic_unsigned.all;

entity arraymult is  -- unsigned array multiplier
  generic (N: natural := 32);
  port (
    a, b : in  std_logic_vector(  N-1 downto 0);                                     -- multiplier a, muliplicand b
    p    : out std_logic_vector(2*N-1 downto 0)                                      -- product
  );
end;

architecture rtl of arraymult is
begin

  process(all)
    variable pp    : arr_of_slv (N-1 downto 0)(N downto 0);  
    variable ai, bi: std_logic_vector(N downto 0); 
  begin

    pp(0)   := '0' & (a and (N-1 downto 0 => b(0)));                                 -- partial product 0  (first row)             
    p(0)    <= pp(0)(0);                                                             -- product bit 0

    for i in 1 to N-1 loop
      ai    := '0' & pp(i-1)(N downto 1);                                            -- 1th operand
      bi    := '0' & (a and (N-1 downto 0 => b(i)));                                 -- 2nd operand
      pp(i) := std_logic_vector(unsigned(ai) + unsigned(bi));                        -- sum all partial products               
      p(i)  <= pp(i)(0);                                                             -- product bit i
    end loop;

    p(2*N-1 downto N) <= pp(N-1)(N downto 1);                                        -- upper product bits            

  end process;  

end;



