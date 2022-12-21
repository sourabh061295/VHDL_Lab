library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity count_ones is
  port (v    : in  std_logic_vector (7 downto 0);         
        count: out unsigned (2 downto 0));
end;

architecture withnext of count_ones is
begin
  process (v)
    variable result: unsigned (2 downto 0);
  begin      
    result := (others => '0');
    for i in v'range loop
      next when v(i) = '0';         
      result := result + 1;
    end loop;      
    count <= result;
  end process;
end;

architecture withif of count_ones is
begin
  process (v)
    variable result: unsigned (2 downto 0);
  begin      
    result := (others => '0');
    for i in v'range loop
      if v(i) = '1' then         
        result := result + 1;
      end if;  
    end loop;      
    count <= result;
  end process;
end;