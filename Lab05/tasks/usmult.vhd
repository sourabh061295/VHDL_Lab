library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity usmult is 
  generic (N: natural := 4);
  port (
    a : in  std_logic_vector(  N-1 downto 0);
    b : in  std_logic_vector(  N-1 downto 0);
    u : in  std_logic;
    p : out std_logic_vector(2*N-1 downto 0)
  );
end;

architecture rtl of usmult is
  signal prod  : signed(2*N+1 downto 0);
  signal ai, bi: std_logic_vector(N downto 0);
begin 
  process(all)
  begin

    ai   <= (a(N-1) & a); -- internal a signal

    bi   <= (b(N-1) & b); -- internal b signal

    prod <= signed(ai) * signed(bi); -- internal product

    p    <= std_logic_vector(unsigned(a) * unsigned(b)) when (u = '1') else
            std_logic_vector(prod(2*N-1 downto 0)); -- output product
  end process; 

end;

-- N      :         8        16        32        64

--                       Area                     
-- usmult :     830.19   2744.59   9766.99  34522.28

--                    Fmax [MHz]                  
-- usmult :     862.07    483.09    320.51    205.76

--                    Power [mW]                  
-- usmult :      43.80    160.00    608.00   2300.00