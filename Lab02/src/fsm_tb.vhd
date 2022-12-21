library IEEE; 
use IEEE.std_logic_1164.all;

entity fsm_tb is 
end;

architecture test of fsm_tb is   

  signal clk, rst, a, ymoore, ymealy : std_logic := '0';
  
begin

  -- generate a clock
  clk <= not clk after 5 ns;
  -- generate a reset
  rst <= '1' after 0 ns, '0' after 20 ns;
  -- generate inputs
  a   <=  '1' after 27 ns, '0' after 36 ns, '1' after 64 ns, '0' after 80 ns, '1' after 90 ns; 

  moorefsm: entity work.moore(withproc)
            port map (clk, rst, a, ymoore);       
           
  mealyfsm: entity work.mealy
            port map (clk, rst, a, ymealy);  

end; 