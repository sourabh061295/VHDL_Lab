library ieee;
use ieee.std_logic_1164.all;

entity cla is  -- carry-lookahead adder
  generic (N: natural := 32);
  port (
    a,b : in  std_logic_vector(N-1 downto 0);
    ci  : in  std_logic;
    s   : out std_logic_vector(N-1 downto 0);
    co  : out std_logic
  );
end;

architecture rtl of cla is

  signal  p, g, Pr, Ge : std_logic_vector(N-1 downto 0); -- bitwise and groupwise propagate and generate signal vector
  signal  c            : std_logic_vector(N   downto 0); -- carry signall vector

begin

  process(all)
  begin
    ------- Computation of g and p (bitwise):
    p <= a xor b;
    g <= a and b;
    ------- Computation of Ge and Pr group carry logic:
    Pr(0) <= p(0);
    Ge(0) <= g(0);
    c(0)  <= ci;
    c(1)  <= g(0) or (p(0) and c(0));
    for i in 1 to N-1 loop
      Pr(i)  <= p(i) and Pr(i-1);
      Ge(i)  <= g(i) or (p(i) and Ge(i-1));
      c(i+1) <= Ge(i) or (Pr(i) and c(0));
    end loop; 
    ------- Computation of sum and carry-out:
    s  <= p xor c(N-1 downto 0);
    co <= c(N);
  end process;  

end architecture;