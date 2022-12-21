library IEEE; 
use IEEE.std_logic_1164.all;
use work.registers.all;
use work.functions.all;

entity usmult_reg is
  generic ( N     : natural := 32 );
  port    ( clk,u : in  std_logic;
            a,b   : in  std_logic_vector(  N-1 downto 0);
            p     : out std_logic_vector(2*N-1 downto 0)
          );
end;

architecture rtl of usmult_reg is

  signal ai, bi : std_logic_vector(  N-1 downto 0) := (others => '0');
  signal pi     : std_logic_vector(2*N-1 downto 0) := (others => '0');
  signal ui     : std_logic;

begin
 
  reg(clk, a, ai);
  reg(clk, b, bi);
  dff(clk, u, ui);

  analyze_inst: entity work.usmult
                generic map (N)
                port    map (ai, bi, ui, pi);

  reg(clk, pi, p);

end;  