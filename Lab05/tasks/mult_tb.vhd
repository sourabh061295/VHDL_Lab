library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.casts.all;
use work.functions.all;

entity mult_tb is
  generic( N : natural := 4;
           M : natural := 4); 
end;

architecture test of mult_tb is
  signal a, b      : std_logic_vector(  N-1 downto 0) := (others => '0');
  signal p, p1, p2 : std_logic_vector(2*N-1 downto 0);
begin

  stimuli: process
  begin
    report "unsigned multiplication";
    for i in 3 to 2**a'length-1 loop  
      a <= to_slv(i, a'length);     
      for j in 1 to 2**b'length-1 loop 
        b <= to_slv(j, b'length);          
        wait for 10 ns;
        assert (p = p1) and (p = p2)
            report "(+)-array:" & str(a) & " * " & str(b) & " = " & strs(p)  & "= " & strs(to_int(p)); 
        assert p = p1       
            report "craarray:" & str(a) & " * " & str(b) & " = " & strs(p1)  & "= " & strs(to_int(p1));   
        assert p = p2       
            report "csaarray:" & str(a) & " * " & str(b) & " = " & strs(p2)  & "= " & strs(to_int(p2));      
      end loop; 
    end loop;     

    wait;
  end process; 
  
  mult:  entity work.arraymult
               generic map (N => N)
               port    map (a, b, p); 

  mult1: entity work.craarraymult
               generic map (N => N)
               port    map (a, b, p1);      
               
  mult2: entity work.csaarraymult
               generic map (N => N)
               port    map (a, b, p2);              
 
end;  