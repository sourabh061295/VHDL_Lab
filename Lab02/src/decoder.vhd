library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity decoder is
  port ( data : in  std_logic_vector(3 downto 0);
         segm : out std_logic_vector(6 downto 0)
       );
end;

architecture withcase of decoder is
begin

  process(data) begin
    case data is           -- abcdefg                               
      when X"0"   => segm <= "1111110"; --    a
      when X"1"   => segm <= "0110000"; --  ----
      when X"2"   => segm <= "1101101"; -- |    |
      when X"3"   => segm <= "1111001"; --f|    |b
      when X"4"   => segm <= "0110011"; -- |  g |
      when X"5"   => segm <= "1011011"; --  ----
      when X"6"   => segm <= "1011111"; -- |    |
      when X"7"   => segm <= "1110000"; --e|    |c
      when X"8"   => segm <= "1111111"; -- |    |
      when X"9"   => segm <= "1110011"; --  ----
      when others => segm <= "0000000"; --    d
    end case;
  end process;

end;

architecture withif of decoder is
begin
  
  process(data) begin            -- abcdefg
    if    data = X"0" then segm <= "1111110"; --    a
    elsif data = X"1" then segm <= "0110000"; --  ----
    elsif data = X"2" then segm <= "1101101"; -- |    |
    elsif data = X"3" then segm <= "1111001"; --f|    |b
    elsif data = X"4" then segm <= "0110011"; -- |  g |
    elsif data = X"5" then segm <= "1011011"; --  ----
    elsif data = X"6" then segm <= "1011111"; -- |    |
    elsif data = X"7" then segm <= "1110000"; --e|    |c
    elsif data = X"8" then segm <= "1111111"; -- |    |
    elsif data = X"9" then segm <= "1110011"; --  ----
    else                   segm <= "0000000"; --    d
    end if;
  end process;
  
end;