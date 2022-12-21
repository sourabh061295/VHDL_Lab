library IEEE; 
use IEEE.std_logic_1164.all;

entity mealy is
  port( clk, rst, a: in  std_logic;
        y          : out std_logic
      );
end;

architecture synth of mealy is

  type statetype is (S0, S1);
  signal state, nextstate: statetype;

begin
  -- state_register: 
  state <= S0        when rst = '1' else
           nextstate when rising_edge(clk);

  transition_logic: process(a, state) 
  begin
    case state is
      when S0    => if a='1' then nextstate <= S0; 
                    else          nextstate <= S1;  end if;
      when S1    => if a='1' then nextstate <= S0;  
                    else          nextstate <= S1;  end if;
    end case;
  end process;

  y <= '1' when (a = '1' and state = S1) else 
       '0'; 

end;