library ieee;
use ieee.std_logic_1164.all;

entity csua is   -- conditional-sum adder
  generic(n : natural := 32);
  port(a, b : in  std_logic_vector(n-1 downto 0);
       ci   : in  std_logic;
       sum  : out std_logic_vector(n-1 downto 0);
       co   : out std_logic);
end;

architecture structural of csua is

  signal s0, s1, su, sl: std_logic_vector(n/2-1 downto 0); -- sum signals
  signal co0, co1, co2 : std_logic;                        -- carry out signals

begin
  
  if0 :
  if n = 1 generate
    fa0 : entity work.fulladder 
          port map(-- TODO
  end generate; 
   
  if1 :
  if n > 1 generate

    cs0 : entity work.csua generic map(-- TODO
            port map  (-- TODO
    cs1 : entity work.csua generic map(-- TODO
            port map  (-- TODO
    cs2 : entity work.csua generic map(-- TODO
            port map  (-- TODO
         
    su  <= -- TODO

    co  <= -- TODO

    sum <= -- TODO    

  end generate; 
end;

