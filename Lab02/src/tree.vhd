library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity tree is
  generic (N     : integer := 32);
  port    (inputs: in  std_logic_vector(N-1 downto 0); 
           output: out std_logic);
end;

architecture recursive of tree is

  signal lower, upper : std_logic;

begin

  BaseCase:       if N = 1 generate
    PassThrough: output <= inputs(0); 
  end generate;

  RecursionCase:  if N > 1 generate
    
    LowerSubTree: entity work.tree 
                      generic map (N/2) 
                      port    map (inputs(N/2-1 downto 0), lower);
    UpperSubTree: entity work.tree 
                      generic map (N/2)
                      port    map (inputs(N-1 downto N/2), upper);
    ApplyBinOperator: output <=  upper xor lower;
  end generate;

end;


