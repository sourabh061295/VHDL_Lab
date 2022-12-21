library IEEE; 
use IEEE.std_logic_1164.all;
use work.registers.all;
use work.functions.all;

entity mult_reg is
  generic ( N     : natural := 32;
            M     : natural := 32);
  port    ( clk   : in  std_logic;
            a,b   : in  std_logic_vector(  N-1 downto 0);
            p     : out std_logic_vector(2*N-1 downto 0)
          );
end;

architecture rtl of mult_reg is

  signal ai, bi : std_logic_vector(  N-1 downto 0) := (others => '0');
  signal pi     : std_logic_vector(2*N-1 downto 0) := (others => '0');

begin
 
  reg(clk, a, ai);
  reg(clk, b, bi);

  analyze_inst: entity work.arraymult
                generic map (N)
                port    map (ai, bi, pi);

  reg(clk, pi, p);

end;  