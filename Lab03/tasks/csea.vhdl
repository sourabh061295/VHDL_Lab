library IEEE;
use IEEE.std_logic_1164.all;
use work.types.all;

entity csea is -- blockwise carry-select adder
  generic ( N     : natural := 32;
            blocks: natural := 4);  
  port    ( a, b  : in  std_logic_vector(N-1 downto 0); 
            ci    : in  std_logic;
            s     : out std_logic_vector(N-1 downto 0); 
            co    : out std_logic);
end;

architecture structural of csea is
  constant bits     : natural := N/blocks;
  signal ai,bi      : arr_of_slv      (blocks-1 downto 0)(bits-1 downto 0); -- blockwise ,b signals
  signal c          : std_logic_vector(blocks   downto 0);                  -- carry vector
  signal c0, c1     : std_logic_vector(blocks-1 downto 0);                  -- carry signals 
  signal s0, s1     : std_logic_vector(N-1      downto 0);                  -- sum signal 
begin

  c(0)  <= -- TODO
  ai(0) <= -- TODO
  bi(0) <= -- TODO

    adder:  entity work.cla 
            generic map(bits)
            port    map(-- TODO

  bl: for i in 1 to blocks-1 generate
        ai(i) <= -- TODO
        bi(i) <= -- TODO
        adder0: entity work.cla 
                generic map(bits)
                port    map(-- TODO
        adder1: entity work.cla 
                generic map(bits)
                port    map(-- TODO     
        c(i+1) <= -- TODO
        s(-- TODO) <=  -- TODO   
  end generate;  
  
  co <= -- TODO

end;  