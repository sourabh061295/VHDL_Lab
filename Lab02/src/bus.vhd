library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity master is
  port ( enable    : in  std_logic;
         inp       : in  std_logic_vector(3 downto 0);
         outp      : out std_logic_vector(3 downto 0)
       );
end;

architecture synth of master is  
begin

  outp <= inp when enable = '1' else (others => 'Z');
    
end;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity soc is
  port (
    clk   : in std_logic;
    rst   : in std_logic;
    bussig: out std_logic_vector(3 downto 0)
  );
end;

architecture rtl of soc is

   signal ena: std_logic_vector(4 downto 0);

begin

  master1: entity work.master port map(ena(1), b"1001", bussig);
  master2: entity work.master port map(ena(2), b"1010", bussig);
  master3: entity work.master port map(ena(3), b"1011", bussig);
  master4: entity work.master port map(ena(4), b"1100", bussig);


  ena <= "00001"                  when rst = '1' else 
         ena(3 downto 0) & ena(4) when rising_edge(clk);

end;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity soc_tb is
end;

architecture test of soc_tb is

  signal clk, rst: std_logic := '0';
  signal bussig  : std_logic_vector(3 downto 0);

begin
  clock : process(clk)
  begin
    clk <= not clk after 5 ns;
  end process;

  rst <= '1' after 10 ns, '0' after 100 ns;

  soc_inst: entity work.soc(rtl)
  port map (
    clk => clk,
    rst => rst,
    bussig => bussig
  );
end;  