library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.casts.all;

entity gcd_fsm_tb is
  generic( N: natural := 16); 
end;

architecture rtl of gcd_fsm_tb is
  signal a: unsigned(N-1 downto 0) := 16D"3528"; 
  signal b: unsigned(N-1 downto 0) := 16D"23865"; 
  signal o: unsigned(N-1 downto 0) := (others => '0');
  signal clk, rst, start, busy: std_logic := '0';
begin

  -- generate a clock
  clk <= not clk after 5 ns;
 
  -- generate a reset
  rst <= '1' after 0 ns, '0' after 20 ns;
 
  -- generate inputs
  start <= '0' after 0 ns, '1' after 50 ns;

  -- GCD entity with 'rtl' architecture instantiation
  gcd_inst: entity work.gcd_fsm(rtl) generic map(N=>N) port map (clk, rst, start, a, b, busy, o);
  
  process begin
    wait on busy;
    report "gcd(" & to_string(to_int(a)) & "," 
                  & to_string(to_int(b)) & ") = " & to_string(to_int(o));
  end process;  
end;

