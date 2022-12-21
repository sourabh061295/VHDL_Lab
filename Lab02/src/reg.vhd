library IEEE; 
use IEEE.std_logic_1164.all;

entity reg is 
  port  ( clk: in  std_logic;
          d  : in  std_logic_vector(3 downto 0);
          q  : out std_logic_vector(3 downto 0)
        );
end;

architecture withprocess of reg is
begin

  process(clk) begin
    if rising_edge(clk) then
      q <= d;
    end if;
  end process;

end;

architecture withconc of reg is
  begin
  
    q <= d when rising_edge(clk);
  
end;

architecture withprocedure of reg is
  
  procedure d_ff (signal clk  : in  std_logic;
                  signal d    : in  std_logic_vector;                  
                  signal q    : out std_logic_vector ) is
  begin    
    if clk = '1' and clk'event then      
      q <= d;
    end if;
  end;
  
begin
   
  d_ff(clk, d, q);
      
end architecture;