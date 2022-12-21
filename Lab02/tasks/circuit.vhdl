
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity circuit is
    generic (N : natural := 8);
    port (  clk    :in  std_logic;                       
            reset  :in  std_logic;                        
            enable :in  std_logic;                        
            o      :out std_logic_vector (N-1 downto 0)   
    );
end entity;

-- non generic version

-- architecture rtl of circuit is
--     signal count :unsigned (7 downto 0);
-- begin
--     process (clk, reset) begin
--         if (reset = '1') then
--             count <= (others=>'0');
--         elsif (rising_edge(clk)) then
--             if (enable = '1') then
--                 count <= count + 1;
--             end if;
--         end if;
--     end process;
--     o <= (count(7) & 
--             (count(7) xor count(6)) & 
--             (count(6) xor count(5)) & 
--             (count(5) xor count(4)) & 
--             (count(4) xor count(3)) & 
--             (count(3) xor count(2)) & 
--             (count(2) xor count(1)) & 
--             (count(1) xor count(0)) ); 
-- end architecture;

architecture withfunc of circuit is
    signal x : unsigned(N-1 downto 0);
  
    -- Function to implement a gray code counter
    function f (v: unsigned(N-1 downto 0)) return std_logic_vector is
      -- Temporary variable to hold the intermediate bit vector values
        variable t:std_logic_vector(N-1 downto 0);
        begin
          -- Maintain the MSB bit
          t(N-1) := v(N-1);
          -- Loop to xor the other bits in the bit vector
          for i in 0 to N-2 loop
            t(i) := v(i) xor v(i+1);
          end loop;
          -- Return the final result vector 't'
        return t;
    end function; 
  
  begin
  
    counter:
    x <= (others=>'0') when reset = '1' else
    x + 1              when rising_edge(clk) and enable = '1';
   
    o <= f(x);
  
  end;
  
  architecture withprocess of circuit is
    signal x : unsigned(N-1 downto 0);
  
  begin

    counter:
    x <= (others=>'0') when reset = '1' else
    x + 1              when rising_edge(clk) and enable = '1';
  
    process (x, clk, reset)
    -- Temporary variable to hold the intermediate bit vector values
    variable t:std_logic_vector(N-1 downto 0);
    begin
      -- Maintain the MSB bit
      t(N-1) := x(N-1);
      -- Loop to xor the other bits in the bit vector
      for i in 0 to N-2 loop
        t(i) := x(i) xor x(i+1);
      end loop;
      -- Assign the value to the output signal
      o <= t;
    end process;   
  end;
  
  architecture withgenerate of circuit is
    
    signal x : unsigned(N-1 downto 0);
  
  begin
  
    counter:
    x             <= (others=>'0') when reset = '1' else
    x + 1         when rising_edge(clk) and enable = '1';
  
    -- Maintain the MSB bit
    o(N-1) <= x(N-1);
    -- Loop to xor the other bits in the bit vector
    xor_gen: for i in 0 to N-2 generate
      o(i) <= x(i) xor x(i+1);
    end generate;
  
  end;
