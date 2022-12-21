library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gcd_fsm is
  generic (N: natural := 32);                   
  port (clk, rst: in  std_logic;
        start   : in  std_logic;
        a, b    : in  unsigned(N-1 downto 0);
        busy    : out std_logic;   
        o       : out unsigned(N-1 downto 0));  
end;

architecture rtl of gcd_fsm is
  -- User defined enum types -> State of the state machine
  type statetype is (INIT, COMPARE, EQUAL, UNEQUAL);  
  signal state: statetype;
  signal x, y : unsigned(N-1 downto 0) := (others=> '0');

begin

  transition_logic: process(clk) 
  begin
    if rst = '1' then
      -- Reset the internal inout signals x and y
      x <= (others => '0');
      y <= (others => '0'); 
      -- Reset the state machine current state
      state <= INIT;  
    elsif rising_edge(clk) then 
      case state is
        -- Initialization state
        -- Check if the start input is high
        when INIT => if start = '1' then
                      -- Set the internal inputs x and y to the entity inputs a and b
                      x <= a;
                      y <= b;
                      -- Move the current state to the next state
                      state <= COMPARE;
                      -- Set busy to '1' since the gcd calculation is on going
                      busy  <= '1';
                    end if;
        -- Comparison state to check if the GCD base condition has been satisfied
        when COMPARE => if x /= y then
                        -- Go to UNEQUAL branch of the case
                        state <= UNEQUAL;
                      else
                        -- Go to EQUAL branch of the case
                        state <= EQUAL;
                      end if;
        -- If both operands x and y are equal, means that the solution has been obtained
        -- Set the output signal o to the obtained result in x
        when EQUAL => o <= x;
                      -- Turn off the busy bit since result is obtained
                      busy <= '0';
        -- If both operands are unequal, then iterate and subtract one operand from the other
        when UNEQUAL => if (x < y) then
                          -- Since y is greater than x
                          y <= y - x;
                        else 
                          -- Since x is greater than y
                          x <= x - y;
                        end if;
                        -- Use the newly updated operands to compare in the next clock cycle
                        state <= COMPARE;
      end case;
    end if;  
  end process;
end;


-- Report.txt contents

-- SLACK: 8.34   slack (MET)
-- CHIP AREA: Chip area for module '\gcd_fsm': 1319.892000

-- TOTAL POWER DISSIPATION: 

-- Group                  Internal  Switching    Leakage      Total
-- Power      Power      Power      Power
-- ----------------------------------------------------------------
-- Sequential             4.42e-05   4.77e-06   6.88e-06   5.58e-05  50.2%
-- Combinational          1.82e-05   1.78e-05   1.93e-05   5.53e-05  49.8%
-- Macro                  0.00e+00   0.00e+00   0.00e+00   0.00e+00   0.0%
-- Pad                    0.00e+00   0.00e+00   0.00e+00   0.00e+00   0.0%
-- ----------------------------------------------------------------
-- Total                  6.24e-05   2.25e-05   2.61e-05   1.11e-04 100.0%
--                           56.2%      20.3%      23.5%

