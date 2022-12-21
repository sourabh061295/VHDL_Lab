library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity regsr is
  port ( clk, rst: in  std_logic;
         d       : in  std_logic_vector(3 downto 0);
         q       : out std_logic_vector(3 downto 0)
       );
end;

architecture withproc of regsr is
begin

  process(clk) begin
    if rising_edge(clk) then
      if rst='1' then 
         q <= (others => '0'); --"0000";
      else 
         q <= d;
      end if;
   end if;
  end process;

end;

architecture withprocedure of regsr is
  
  procedure d_ffsr (signal clk, rst : in  std_logic;
                    signal d        : in  std_logic_vector;                  
                    signal q        : out std_logic_vector ) is

    variable t : std_logic_vector(q'length-1 downto 0);                  
  begin    
    if clk = '1' and clk'event then  
      if rst = '1' then
        for i in 0 to (d'length-1) loop
          t(i) := '0'; 
        end loop;  
      else     
        t := d xor t;
      end if;  
    end if;
    q <= t;
  end;
  
begin
   
  d_ffsr(clk, rst, d, q);
   
end;