library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity regae is 
  port ( clk, rst, ena: in  std_logic;
         d            : in  std_logic_vector(3 downto 0);
         q            : out std_logic_vector(3 downto 0)
  );
end;

architecture withproc of regae is
begin

  process(clk, rst) begin
    if rst='1' then 
       q <= "0000";
    elsif rising_edge(clk) then
      if ena = '1' then
        q <= d;
      end if;  
    end if;
  end process;

end;

architecture withconc of regae is
  begin
  
    q <= "0000" when rst = '1' else
         d      when rising_edge(clk) and ena = '1';
  
end;

architecture withprocedure of regae is
  
  procedure d_ffae (signal clk, rst, ena : in  std_logic;
                    signal d             : in  std_logic_vector;                  
                    signal q             : out std_logic_vector ) is
  begin    
    if rst = '1' then
      q <= (others => '0');
    elsif clk = '1' and clk'event and ena = '1' then     
      --if ena = '1' then 
        q <= d;
      --end if;  
    end if;
  end;
  
begin
   
  d_ffae(clk, d, q);
   
end;