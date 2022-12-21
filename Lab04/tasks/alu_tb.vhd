library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.casts.all;
use work.functions.all;
use work.records.all;

entity alu_tb is
  generic( N : natural := 4);
end;

architecture test of alu_tb is
  signal a, b, result : std_logic_vector(      N-1 downto 0) := (others => '0');
  signal ctrl         : std_logic_vector(        1 downto 0) := (others => '0');
  signal shamt        : std_logic_vector(log2(N)-1 downto 0) := (others => '0');
  signal ci           : std_logic := '0';
  signal flags        : flagType;
begin

  stimuli: process
  begin
   for i in 0 to 2**a'length-1 loop  
     a <= to_slv(i, a'length);     
      for j in 0 to 2**b'length-1 loop 
        b <= to_slv(j, b'length);
        for k in 0 to 2**ctrl'length-1 loop
          ctrl <= to_slv(k, ctrl'length);         
          for l in 0 to 1 loop
            if l = 0 then ci <= '0'; else ci <= '1'; end if;
            wait for 10 ns;
            case ctrl is
              when "00"  =>     report  str(a) &  " + " & str(b) & " + " & str(ci) & " = " & str(result) & " | " &
                                        str(flags.Z) & str(flags.N) & str(flags.V) & str(flags.C) &  " (ZNVC) " &  " | " &
                                        str(flags.lt) & str(flags.le) & str(flags.gt) & str(flags.ge) &  " (LtLeGtGe) "; 
              when "01"  =>     report  str(a) &  " - " & str(b) & " - " & str(ci) & " = " & str(result) & " | " &
                                        str(flags.Z) & str(flags.N) & str(flags.V) & str(flags.C) &  " (ZNVC) " &  " | " &
                                        str(flags.lt) & str(flags.le) & str(flags.gt) & str(flags.ge) &  " (LtLeGtGe) "; 
              when "10"  =>   if l=0 then  
                                report  str(a) &  " ^ " & str(b) & "     = " & str(result) & " | " &
                                        str(flags.Z) & str(flags.N) & str(flags.V) & str(flags.C) &  " (ZNVC) " &  " | " &
                                        str(flags.lt) & str(flags.le) & str(flags.gt) & str(flags.ge) &  " (LtLeGtGe) ";  
                              end if;          
              when others =>  if l=0 then
                                report  str(a) &  " v " & str(b) & "     = " & str(result) & " | " &
                                        str(flags.Z) & str(flags.N) & str(flags.V) & str(flags.C) &  " (ZNVC) " &  " | " &
                                        str(flags.lt) & str(flags.le) & str(flags.gt) & str(flags.ge) &  " (LtLeGtGe) "; 
                              end if;                    
            end case;
          end loop;
        end loop;
      end loop; 
    end loop;      
    wait;
  end process; 

  alu_inst: entity work.alu
               generic map (N => N)
               port    map (a, b, ci, ctrl, result, flags);     
                            
end;  