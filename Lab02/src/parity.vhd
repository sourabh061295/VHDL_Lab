library IEEE;
use IEEE.std_logic_1164.all;

entity parity is
port( i_data   : in  std_logic_vector(7 downto 0);
      o_parity : out std_logic);
end;

architecture withfor of parity is
begin

  process (i_data)
    variable vparity : std_logic;
  begin
      
      vparity   := '0';
      for k in 0 to i_data'length-1 loop
        vparity := vparity xor i_data(k);
      end loop;
    
      o_parity <= vparity;

  end process;

end;

architecture with2008 of parity is
begin

  o_parity <= xor i_data;
  
end;  

architecture withfor1 of parity is
begin
  
  process (i_data)
    variable vparity : std_logic_vector(i_data'length downto 0);
  begin
      
      vparity   := '0';
      for k in 0 to i_data'length-1 loop
        vparity(k+1) := vparity(k) xor i_data(k);
      end loop;
    
      o_parity <= vparity(i_data'length);

  end process;

end;  