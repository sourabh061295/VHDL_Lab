library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.casts.all;

entity counter is
  generic( N: integer := 8 );
  port( clk, rst: in     std_logic; 
        q       : buffer std_logic_vector(N-1 downto 0)
      );
end;

architecture withproc of counter is
begin
  
  process(clk, rst) begin
    if rst = '1' then
      q <= (others => '0');
    elsif rising_edge(clk) then
      q <= to_slv(1 + unsigned(q));
    end if;
  end process;

end;  

architecture withwhen of counter is
begin

  q  <= (others => '0')         when rst = '1' else
        to_slv(1 + unsigned(q)) when rising_edge(clk);

end;



