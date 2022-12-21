library ieee;
use ieee.std_logic_1164.all;

entity clpga is  -- carry-lookahead adder
  generic (N: natural := 8);
  port (
    a,b : in  std_logic_vector(N-1 downto 0);
    ci  : in  std_logic;
    s   : out std_logic_vector(N-1 downto 0);
    co  : out std_logic;
    Pb, Gb: out std_logic
  );
end;

architecture rtl of clpga is

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
    ------- Looping through the bits to calculate the carry of the subsequent bit
    for i in 1 to N-1 loop
      Pr(i)  <= p(i) and Pr(i-1);
      Ge(i)  <= g(i) or (p(i) and Ge(i-1));
      c(i+1) <= Ge(i) or (Pr(i) and c(0));
    end loop; 
    ------- Computation of sum and carry-out:
    s  <= p xor c(N-1 downto 0);
    co <= c(N);
    ------- Evaluating the generate ans propagate signals
    Pb <= Pr(N-1);
    Gb <= Ge(N-1);
  end process;  

end architecture;