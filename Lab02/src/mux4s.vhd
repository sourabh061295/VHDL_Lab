library IEEE; 
use IEEE.std_logic_1164.all;
use work.all;

entity mux4s is
  port(d0, d1, d2, d3: in  std_logic_vector(3 downto 0);
       s             : in  std_logic_vector(1 downto 0);
       y             : out std_logic_vector(3 downto 0)
      );
end;

architecture position of mux4s is

  signal low, high: std_logic_vector(3 downto 0);

begin

  lowmux  : entity work.mux2 
            port map(d0, d1, s(0), low );
  highmux : entity work.mux2 
            port map(d2, d3, s(0), high);
  finalmux: entity work.mux2 
            port map(low, high, s(1), y);

end;

architecture name of mux4s is

  signal low, high: std_logic_vector(3 downto 0);

begin

  lowmux  : entity work.mux2 
            port map( y  => low, d0 => d0 , d1 => d1, s  => s(0));
                    
  highmux : entity work.mux2 
            port map( d0 => d2, d1 => d3, s => s(0), y => high);

  finalmux: entity work.mux2  
            port map( low, high, s(1), y );

end;
