library IEEE; 
use IEEE.std_logic_1164.all;

entity moore is
  port( clk, rst, a: in  std_logic;
        y          : out std_logic
      );
end;

architecture withproc of moore is
  
  type statetype is (S0, S1, S2);
  signal state, nextstate: statetype;

begin

  -- state memory: 
  state <= S0        when rst = '1' else
           nextstate when rising_edge(clk);

  transition_logic: process(a, state) 
  begin
    case state is
      
      when S0     => if a='1' then nextstate <= S0; 
                     else          nextstate <= S1; end if;
      when S1     => if a='1' then nextstate <= S2; 
                     else          nextstate <= S1; end if;
      when S2     => if a='1' then nextstate <= S0; 
                     else          nextstate <= S1; end if;
    end case;
  end process;

  y <= '1' when state = S2 else
       '0';

end;

architecture withwhen of moore is

  type statetype is (S0, S1, S2);
  
  signal state, nextstate: statetype := S0;

begin

  -- state memory
  state <= S0        when rst = '1' else  
           nextstate when rising_edge(clk);
  -- transition logic
  nextstate <= S0 when a='1' and (state=S0 or state=S2) else
               S1 when a='0'                            else
               S2 when a='1' and state=S1               else
               S0;
  -- output logic                    
  y <= '1' when state = S2 else             
       '0';
end;
