library IEEE; 
use IEEE.std_logic_1164.all;
use work.registers.all;
use work.functions.all;

entity shifter_reg is
  generic ( N     : natural := 32);
  port    ( clk   : in  std_logic;
            a     : in  std_logic_vector(N-1 downto 0);
            func  : in  std_logic_vector(  2 downto 0);
            shamt : in  std_logic_vector(log2(N)-1 downto 0); 
            y     : out std_logic_vector(N-1 downto 0)
          );
end;

architecture rtl of shifter_reg is

  signal ai, yi  : std_logic_vector(      N-1 downto 0) := (others => '0'); 
  signal funci   : std_logic_vector(        2 downto 0) := (others => '0');
  signal shamti  : std_logic_vector(log2(N)-1 downto 0) := (others => '0');

begin
 
  reg(clk, a, ai);
  reg(clk, func, funci);
  reg(clk, shamt, shamti);

  analyze_inst: entity work.logbarrel
               generic map (N => N)
               port    map (ai, funci, shamti, yi);

  reg(clk, yi, y);

end;  