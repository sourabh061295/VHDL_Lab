library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.casts.all;

entity ram_tb is 
end;

architecture test of ram_tb is   

  signal clk, we      : std_logic := '0';
  signal re           : std_logic := '1';
  signal waddr, raddr : std_logic_vector( 3 downto 0) := "0000";
  signal din, dout    : std_logic_vector(15 downto 0) := x"0000";
  
begin

  -- generate a clock
  clk <= not clk after 5 ns;

  waddr <= "0100";
  raddr <= to_slv(unsigned(raddr) + 1) after 20 ns;
  we    <= '1' after 20 ns, '0' after 31 ns;
  --din   <= x"0000" after 18 ns;

  ram: entity work.raminit port map (clk, clk, we, re, raddr, waddr, din, dout); 

end; 