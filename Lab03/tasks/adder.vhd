library IEEE; 
use IEEE.std_logic_1164.all;
use work.registers.all;

entity adder is
  generic ( N             : natural := 32;
            Blocks        : natural :=  4);
  port    ( clk, rst, ci  : in  std_logic;
            a, b          : in  std_logic_vector(N-1 downto 0);
            sum           : out std_logic_vector(N-1 downto 0);
            co            : out std_logic);
end;

architecture rtl of adder is

  signal ai, bi   : std_logic_vector(N-1 downto 0) := (others => '0'); 
  signal cii, coi : std_logic := '0';
  signal sumi     : std_logic_vector(N   downto 0) := (others => '0');

begin
 
  reg(clk, a, ai);
  reg(clk, b, bi);
  dff(clk, ci, cii);

  adder_inst: entity work.csua
               generic map (N => N)
               port    map (ai, bi, cii, sumi(N-1 downto 0), sumi(N));

  reg(clk, sumi(N-1 downto 0), sum);
  dff(clk, sumi(N), co); 

end;  