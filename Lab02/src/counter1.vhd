library IEEE; 
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.casts.all;

entity counter1 is
  generic( N: integer := 8 );
  port( clk, rst: in  std_logic; 
        q       : out std_logic_vector(N-1 downto 0)
      );
end;

architecture withsig of counter1 is

  signal t: unsigned(N-1 downto 0);

begin
   
  process(clk, rst) begin
    if rst = '1' then
      t <= (others => '0'); 
    elsif rising_edge(clk) then
      t <= 1 + t;
    end if;
  end process;

  q <= to_slv(t);
  
end;  

architecture withvar of counter1 is

begin
   
  process(clk, rst) 

    variable t: unsigned(N-1 downto 0);

  begin
    if rst = '1' then
      t := (others => '0'); 
    elsif rising_edge(clk) then
      t := 1 + t;
    end if;

    q <= to_slv(t);

  end process;

end;  

architecture withwhen of counter1 is
  signal t : std_logic_vector(N-1 downto 0);
begin
  
  t  <= (others => '0')         when rst = '1' else
        to_slv(1 + unsigned(q)) when rising_edge(clk);

  q <= t;      
  
end;