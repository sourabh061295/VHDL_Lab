library IEEE; 
use IEEE.std_logic_1164.all;
use work.all;

entity fulladder_tb is
end;

architecture test of fulladder_tb is
  signal a, b, cin, s1, s2, s3, cout1, cout2, cout3: std_logic;
begin

  stimuli: process
  begin
    report "   a   b  cin ||  (s1  co1)   (s2  co2)   (s3  co3)   ";
    report "--------------++--------------------------------------";
    for i in 0 to 1 loop
      if i=0 then a <= '0';
             else a <= '1';
      end if;       
      for j in 0 to 1 loop
        if j=0 then b <= '0';
               else b <= '1';
        end if;   
        for k in 0 to 1 loop
          if k=0 then cin <= '0';
                 else cin <= '1';  
          end if;         
          wait for 10 ns;
          assert ((s1 = s2) and (s1 = s3) and (cout1 = cout2) and (cout1 = cout3))
          report std_logic'image(a) & " " & std_logic'image(b)  & " "  & std_logic'image(cin)   &  " ||  "
                                    & "(" & std_logic'image(s1) & " "  & std_logic'image(cout1) &  ")   "
                                    & "(" & std_logic'image(s2) & " "  & std_logic'image(cout2) &  ")   "
                                    & "(" & std_logic'image(s3) & " "  & std_logic'image(cout3) &  ")   ";
        end loop;
      end loop;
    end loop;      
    wait;
  end process; 

  fa1: entity work.fulladder(withmux)      port map (a, b, cin, s1, cout1);
  fa2: entity work.fulladder(withsignals)  port map (a, b, cin, s2, cout2);
  fa3: entity work.fulladder(withfunction) port map (a, b, cin, s3, cout3);
 
end;  