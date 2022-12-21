library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;
use work.casts.all;
use ieee.std_logic_unsigned.all;

entity usmbwarraymult is  -- unsigned / signed modified baugh wooley array
  generic (N: natural := 4);
  port (
    a, b : in  std_logic_vector(  N-1 downto 0);                    -- multiplier a, muliplicand b
    u    : in  std_logic;                                           -- unsigned = '1' / signed = '0'
    p    : out std_logic_vector(2*N-1 downto 0)                     -- product
  );
end;

architecture rtl of usmbwarraymult is  -- modified baugh wooley array multiplier
begin

  process(all)
    variable pp : arr_of_slv (N-1 downto 0)(N downto 0); 
    variable s  : std_logic; 
  begin
    
    -- indicates signed operation, has historical reason 
    s       := not u;  
    -- calculate partial product 0                                                     
    pp(0)   := s & ((a(N-1) and b(0)) xor s) & (a(N-2 downto 0) and ((N-2 downto 0 => b(0)))); 
    -- product bit 0             
    p(0)    <= pp(0)(0); 
    -- calculate 1st partial product 1 and add the partial product to it                                                   
    pp(1)   := ('0' & pp(0)(N downto 1)) + (((a(N-1) and b(1)) xor s) & (a(N-2 downto 0) and ((N-2 downto 0 => b(1)))));  
    -- product bit 1    
    p(1)    <= pp(1)(0);                                                    

    -- array of adders 
    for i in 2 to N-2 loop                                                  
       -- calculate i-th partial product and add the i-th partial product to it
      pp(i) := ('0' & pp(i-1)(N downto 1)) + (((a(N-1) and b(i)) xor s) & (a(N-2 downto 0) and ((N-2 downto 0 => b(i)))));
      -- i-th product bit
      p(i)  <= pp(i)(0);                                                    
    end loop;

    -- calculate (N-1)-th partial product and add the (N-2)-th partial product to it
    pp(N-1) := (('0' & (pp(N-2)(N downto 1)) + ((s & (a(N-1) and b(N-1))) & (( (N-2 downto 0 => s) xor ((a(N-2 downto 0) and ((N-2 downto 0 => b(N-1))))))))));           
    -- upper product bits  
    p(2*N-1 downto N-1) <= pp(N-1);                

  end process;  

end;

