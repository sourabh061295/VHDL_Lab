library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity gates_tb1 is 
end;

architecture asserttest of gates_tb1 is              
  signal a, b       : std_logic;
  signal y1, y2, y3 : std_logic_vector(6 downto 0);
  
begin

  gates_inst1: entity work.gates(slice)     port map (a, b, y1);
  gates_inst2: entity work.gates(concate)   port map (a, b, y2);

  process
  begin
    
    for i in 0 to 1 loop
      if i=0 then a <= '0';
             else a <= '1';
      end if;       
      for j in 0 to 1 loop
        if j=0 then b <= '0';
               else b <= '1';
        end if;       
        wait for 10 ns;
        assert y1 = y2
          report "The modules do not match at (a,b)=(" 
                 & std_logic'image(a) & "," 
                 & std_logic'image(b) & "):"
                 & integer'image(to_integer(unsigned(y1))) & " /= " 
                 & integer'image(to_integer(unsigned(y2))); 
      end loop;  
    end loop;  
    wait;
  end process;

end;