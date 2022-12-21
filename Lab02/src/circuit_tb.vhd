library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.casts.all;

entity circuit_tb is 
end;

architecture test of circuit_tb is              
  signal clk, reset : std_logic := '0';
  signal o          : std_logic_vector(7 downto 0);
  
begin

  circuit_inst: entity work.circuit port map (clk, reset, o);

  clk   <= not clk after 5 ns;

  reset <= '1', '0' after 20 ns; 
  
  process
  begin
    wait on o;
    report to_string(o);
    wait for 10 ns;
  end process;

end;
