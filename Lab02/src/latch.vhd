library IEEE; 
use IEEE.std_logic_1164.all;

entity latch is
  port ( clk: in  std_logic;
         d  : in  std_logic_vector(3 downto 0);
         q  : out std_logic_vector(3 downto 0)
       );
end;

architecture withproc of latch is
begin

  process(clk, d) begin
    if clk = '1' then
      q <= d;
    end if;
  end process;

end;

architecture withwhen of latch is
  begin

  q <= d when clk = '1';

end;