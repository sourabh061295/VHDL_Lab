library IEEE; 
use IEEE.std_logic_1164.all;

entity regar is 
  port ( clk, rst: in  std_logic;
         d       : in  std_logic_vector(3 downto 0);
         q       : out std_logic_vector(3 downto 0)
  );
end;

architecture withproc of regar is
begin

  process(clk, rst) begin
    if rst='1' then 
       q <= "0000";
    elsif rising_edge(clk) then
      q <= d;
    end if;
  end process;

end;

architecture withconc of regar is
  begin
  
    q <= "0000" when rst = '1' else
         d      when rising_edge(clk);
  
end;

architecture withprocedure of regsr is
  
  procedure d_ffar (signal clk, rst : in  std_logic;
                    signal d        : in  std_logic_vector;                  
                    signal q        : out std_logic_vector ) is
  begin    
    if rst = '1' then
      q <= (others => '0');
    elsif clk = '1' and clk'event then      
      q <= d;
    end if;
  end;
  
begin
   
  d_ffar(clk, d, q);
   
end;