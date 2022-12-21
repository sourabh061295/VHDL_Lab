library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.casts.all;
use work.functions.all;

entity shifter_tb is
  generic( N    : natural := 32;
           ainit: natural := 16#72345678#);
end;

architecture test of shifter_tb is
  signal a, y1, y2 : std_logic_vector(N-1 downto 0):= to_slv(ainit,N); 
  signal func      : std_logic_vector(  2 downto 0);
  signal shamt     : std_logic_vector(log2(N)-1 downto 0);
begin

  stimuli: process
  begin
   -- for i in 0 to 2**a'length-1 loop  
    --  a <= to_slv(i, a'length);     
      for j in 0 to 4 loop --2**func'length-1 loop 
        func <= to_slv(j, func'length);
        for k in 0 to 2**shamt'length-1 loop
          shamt <= to_slv(k, shamt'length);         
          wait for 10 ns;
          case func is
            when "000"  =>  assert (y1 = y2)
                            report strs(y1) & strs(y2)  &  " = " & 
                                   str(a)  & " >> "  & strs(to_int(shamt))  & str(func)  ;
            when "001"  =>  assert (y1 = y2)
                            report strs(y1) &  str(y2)  &  " = " & 
                                   str(a)  & " << "  & strs(to_int(shamt))  & str(func)  ;
            when "010"  =>  assert (y1 = y2)
                            report strs(y1) &  str(y2)  &  " = " & 
                                   str(a)  & " *> "  & strs(to_int(shamt))  & str(func)  ;  
            when "011"  =>  assert (y1 = y2)
                            report strs(y1) &  str(y2)  &  " = " & 
                                   str(a)  & " <* "  & strs(to_int(shamt))  & str(func)  ;  
            when others =>  assert (y1 = y2)
                            report strs(y1) &   str(y2)  &  " = " & 
                                   str(a)  & " >>> " & strs(to_int(shamt))  & str(func)  ;                          
          end case;
        end loop;
      end loop; 
    --end loop;      
    wait;
  end process; 

  shifter1_inst: entity work.shifter
               generic map (N => N)
               port    map (a, func, shamt, y1); 
  shifter2_inst: entity work.logbarrel
               generic map (N => N)
               port    map (a, func, shamt, y2);                      
                            
end;  