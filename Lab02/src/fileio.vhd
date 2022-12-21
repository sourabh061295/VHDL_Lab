Library IEEE;
use IEEE.std_logic_1164.ALL; 
use std.textio.all;            

entity fileio is
end;

architecture test of fileio is
  signal clk, a,b,cin, cout, s: std_logic := '0';
begin

  fa_inst: entity work.fulladder port map (a,b,cin, s, cout);

  clk <= not clk after 1 ns;                   
  
  process is
    file tv              : text;
    variable L           : line;
    variable in_vec      : std_logic_vector(2 downto 0);
    variable dummy       : character;
    variable out_expected: std_logic_vector(1 downto 0);
    variable vectornum   : integer := 0;
    variable errors      : integer := 0;

  begin
    file_open(tv, "example.tv", READ_MODE); 
    while not endfile(tv) loop
      wait until rising_edge(clk);      -- change vectors on rising edge 
      readline(tv, L);                  -- read the next line of testvectors 
      read(L, in_vec);                  -- assign the input vector
      read(L, dummy);                   -- skip over underscore
      read(L, out_expected);            -- assign the output vector
      (a,b,cin)  <= in_vec(2 downto 0); -- split the input vector into 1-bit signals
      wait until falling_edge(clk);     -- check results on falling edge
      if (s,cout) /= out_expected then  -- Match Output vector the expected vector? 
        report "Error: (s,cout) = " & std_logic'image(s) & std_logic'image(cout) & " but expected " 
                                    & std_logic'image(out_expected(1)) 
                                    & std_logic'image(out_expected(0)); 
        errors := errors + 1; 
      end if; 
      vectornum := vectornum + 1; 
    end loop; 
    
    if (errors = 0) then                -- summarize results at end of simulation 
      report "NO ERRORS -- " & integer'image(vectornum) & " tests completed successfully."; -- severity note; 
    else 
      report integer'image(vectornum) & " tests completed, errors = " 
           & integer'image(errors) severity failure; 
    end if; 
    file_close(tv);
    wait;
  end process; 
end; 