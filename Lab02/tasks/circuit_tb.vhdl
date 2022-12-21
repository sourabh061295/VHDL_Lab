library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.casts.all;

entity circuit_tb is
  -- Generic declaration of N 
  generic (N: integer := 8);
end;

architecture test of circuit_tb is              
  signal clk, reset, enable : std_logic := '0';
  signal o, o1, o2, o3      : std_logic_vector(N-1 downto 0);
  
begin

  -- circ1: entity work.circuit(rtl)             port map (clk, reset, enable, o);
  -- Instantiation for gray code generator with functions 
  circ2: entity work.circuit(withfunc)       generic map(N => N)     port map (clk, reset, enable, o1);            
  -- Instantiation for gray code generator with process 
  circ3: entity work.circuit(withprocess)    generic map(N => N)     port map (clk, reset, enable, o2);
  -- Instantiation for gray code generator with generator 
  circ4: entity work.circuit(withgenerate)   generic map(N => N)     port map (clk, reset, enable, o3);                                    



  clk    <= not clk after 5 ns;

  reset  <= '1', '0' after 20 ns; 

  enable <= '1' after 30 ns;
  
  process
  begin
    wait on o1, o2, o3;
    assert o1 = o2
      report to_string(o) & " " & to_string(o1) & " " & to_string(o2) &  " " & to_string(o3);
    wait for 10 ns;
  end process;

end;
