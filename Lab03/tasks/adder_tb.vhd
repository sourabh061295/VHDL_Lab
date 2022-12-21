library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.casts.all;
-- use work.functions.all;

entity adder_tb is
  generic( N : natural := 8);
end;

architecture test of adder_tb is
  signal a, b, 
         sum_cria, sum_cla, sum_add,  -- sum signals for carry-ripple, carry-lookahead, plus adder
         sum_cska,                    --                 carry-skip adder
         sum_bcla,                    --                 blockwise carry-lookahead adder
         sum_csea,                    --                 carry-select adder
         sum_csua,                    --                 conditional-sum adder
         sum_skla,                    --                 sklansky adder
         sum_ksa                      --                 kogge-stone adder
                  : std_logic_vector(N-1 downto 0) := (others => '0');
  signal ci,    
         co_cria, co_cla, co_add,     -- sum signals for carry-ripple, carry-lookahead, plus adder
         co_cska,                     --                 carry-skip adder
         co_bcla,                     --                 blockwise carry-lookahead adder
         co_csea,                     --                 carry-select adder
         co_csua,                     --                 conditional-sum adder
         co_skla,                     --                 sklansky adder
         co_ksa                       --                 kogge-stone adder
                  : std_logic;
begin

  stimuli: process
  begin
    for i in 0 to 2**a'length-1 loop  
      a <= to_slv(i, a'length);     
      for j in 0 to 2**b'length-1 loop 
        b <= to_slv(j, b'length); 
        for k in 0 to 1 loop
          ci <= to_unsigned(k,1)(0);         
          wait for 10 ns;
          assert (sum_cria = sum_cla) and (co_cria = co_cla) and 
                 (sum_cria = sum_add)  and (co_cria = co_add)  and
                 (sum_cria = sum_bcla) and (co_cria = co_bcla) --and
          --        (sum_cria = sum_csea) and (co_cria = co_csea) and
          --        (sum_cria = sum_skla) and (co_cria = co_skla) and
          --        (sum_cria = sum_csua) and (co_cria = co_csua) and
          --        (sum_cria = sum_cska) and (co_cria = co_cska)
                 report to_string(a) & " +  " & to_String(b) & " + " & std_logic'image(ci) & " = " & 
                  "cria (" &  to_string(co_cria) & "," & to_string(sum_cria) & ") | " &
                  "add  (" &  to_string(co_add)  & "," & to_string(sum_add)  & ") " &
                  "cla (" &  to_string(co_cla) & "," & to_string(sum_cla) & ") | " &
                  -- "cska (" &  to_string(co_cska) & "," & to_string(sum_cska) & ") | " &
                  "bcla (" &  to_string(co_bcla) & "," & to_string(sum_bcla) & ") | ";
                  -- "csea (" &  to_string(co_csea) & "," & to_string(sum_csea) & ") | " &
                  -- "skla (" &  to_string(co_skla) & "," & to_string(sum_skla) & ") | " &
                  -- "csua (" &  to_string(co_csua) & "," & to_string(sum_csua) & ") | " &
                  
        end loop;
      end loop; 
    end loop;      
    wait;
  end process; 

  cria_inst:  entity work.cria
                generic map (N => N)
                port    map (a, b, ci, sum_cria, co_cria);  
  add_inst:   entity work.add
                generic map (N => N)
                port    map (a, b, ci, sum_add, co_add);  
  cla_inst:  entity work.cla
                generic map (N => N)
                port    map (a, b, ci, sum_cla, co_cla);                
  -- cska_inst:  entity work.cska
  --               generic map (N => N)
  --               port    map (a, b, ci, sum_cska, co_cska); 
  bcla_inst:  entity work.bcla
                generic map (N => N)
                port    map (a, b, ci, sum_bcla, co_bcla); 
  -- csea_inst:  entity work.csea
  --               generic map (N => N)
  --               port    map (a, b, ci, sum_csea, co_csea);  
  -- skla_inst:  entity work.skla
  --               generic map (N => N)
  --               port    map (a, b, ci, sum_skla, co_skla); 
  -- csua_inst:  entity work.csua
  --               generic map (N => N)
  --               port    map (a, b, ci, sum_csua, co_csua);              
  -- ksa_inst:  entity work.ksa
  --               generic map (N => N)
  --               port    map (a, b, ci, sum_ksa, co_ksa);                  
 
end;  