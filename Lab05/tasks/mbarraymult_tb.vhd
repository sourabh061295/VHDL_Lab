library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.casts.all;
use work.functions.all;

entity mbmult_tb is
  generic( N : natural := 8); 
end;

architecture test of mbmult_tb is
  signal a, b      : std_logic_vector(  N-1 downto 0) := (others => '0');
  signal p, p1, p2 : std_logic_vector(2*N-1 downto 0);
  signal u         : std_logic := '0';
begin

  stimuli: process
  begin
    report "signed multiplication";
    u <= '0';  -- unsigned
    for i in 3 to 2**a'length-1 loop  
      a <= to_slv(i, a'length);     
      for j in 1 to 2**b'length-1 loop 
        b <= to_slv(j, b'length);          
        wait for 10 ns;
          assert (p = p1) --and (p = p2)
            report "(+)-array:" & str(a) & " * " & str(b) & " = " & strs(p)  & "= " & strs(to_sint(p)); 
          assert p = p1       
            report "mbcraarray:" & str(a) & " * " & str(b) & " = " & strs(p1)  & "= " & strs(to_sint(p1)); 
      end loop; 
    end loop;  
    wait;
  end process; 

  mult:  entity work.usmult
               generic map (N => N)
               port    map (a, b, u, p);             

  mult1: entity work.mbarraymult
               generic map (N => N)
               port    map (a, b, p1);          
 
end;  