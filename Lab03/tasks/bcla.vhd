
library IEEE;
use IEEE.std_logic_1164.all;
use work.types.all;

entity bcla is -- blockwise carry-lookahead adder
  generic ( N     : natural := 32;
            blocks: natural := 4);  
  port    ( a, b  : in  std_logic_vector(N-1 downto 0); 
            ci    : in  std_logic;
            s     : out std_logic_vector(N-1 downto 0); 
            co    : out std_logic);
end;

architecture structural of bcla is
  ------ Declarations
  constant bits     : natural := N/blocks;  -- number of bits per block
  signal ai,bi      : arr_of_slv      (blocks-1 downto 0)(bits-1 downto 0); -- internal blockwise a, b signal
  signal c          : std_logic_vector(blocks   downto 0);                  -- carry signal vector
  signal p, g       : std_logic_vector(blocks-1 downto 0);                  -- propagate, generate signal vector
begin

  ----- Initial assginment of carry
  c(0) <= ci;

  bl: for i in 0 to blocks-1 generate
    -------- Pick a block of bits to be forwarded to the carry look ahead adder
    ai(i)   <= a((i+1)*bits-1 downto (i*bits));
    bi(i)   <= b((i+1)*bits-1 downto (i*bits));
    ------- Call the entity via instantiating
    adder_inst: entity work.clpga 
                generic map(bits)
                port    map(ai(i), bi(i), c(i), s((i+1)*bits-1 downto (i*bits)), c(i+1), p(i), g(i));
    ------- Generate the carry for the next bit
    c(i+1)  <= g(i) or (p(i) and c(i));
  end generate;  
  
  ------- Final carry is stored in the last element of the block
  co   <= c(blocks); 

end;  