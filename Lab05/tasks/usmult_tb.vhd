library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.casts.all;
use work.functions.all;

entity usmult_tb is
  generic( N : natural := 4 ); 
end;

architecture test of usmult_tb is
  signal a, b  : std_logic_vector(  N-1 downto 0) := (others => '0');
  signal p, p1 : std_logic_vector(2*N-1 downto 0);
  signal u     : std_logic := '0';
begin

  stimuli: process
  begin
    report "signed multiplication";
    u <= '0';  
    for i in 3 to 2**a'length-1 loop  
      a <= to_slv(i, a'length);     
      for j in 1 to 2**b'length-1 loop 
        b <= to_slv(j, b'length);          
        wait for 10 ns;
        assert p = p1 
          report str(a) & " ( " & strs(to_sint(a)) & " ) " & " *" & strs(b) & " ( " & str(to_sint(b)) & " ) " & " = " & strs(p)  & "= " & strs(to_sint(p)) & " != " & strs(p1) & "( " & strs(to_sint(p1)) & ")"; 
        -- assert p = p1    
        --    report str(a) & " * " & str(b) & " = " & strs(p1)  & "= " & strs(to_sint(p1));     
      end loop; 
    end loop;      
    report "unsigned multiplication";
    u <= '1';
    for i in 3 to 2**a'length-1 loop  
      a <= to_slv(i, a'length);     
      for j in 1 to 2**b'length-1 loop 
        b <= to_slv(j, b'length);          
        wait for 10 ns;
        assert p = p1
            report str(a) & " ( " & strs(to_int(a)) & " ) " & " *" & strs(b) & " ( " & str(to_int(b)) & " ) " & " = " & strs(p)  & "= " & strs(to_int(p)) & " != " & strs(p1) & "( " & strs(to_int(p1)) & ")"; 
        -- assert p = p1    
        --    report str(a) & " * " & str(b) & " = " & strs(p1)  & "= " & strs(to_int(p1));
 
      end loop; 
    end loop; 
    
    -- if you want to test only with a single pair of numbers: 
    -- comment both for loops above and uncomment the following lines
    -- a <= "00000011"; 
    -- b <= "10000000";
    -- wait for 10 ns;
    -- report str(a) & " * " & str(b) & " = " & strs(p)  & "= " & strs(to_int(p));

    wait;
  end process; 
  
  -- (*)-operator
  mult: entity work.usmult                 
              generic map (N => N)
              port    map (a, b, u, p);     
   
  -- modified booth-wooley array
  mult2: entity work.usmbwarraymult        
              generic map (N => N)
              port    map (a, b, u, p1);    
 
end;  