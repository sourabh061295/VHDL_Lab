entity gcd_tb is 
end;

architecture with_process of gcd_tb is
  signal a: integer := 3528;
  signal b: integer := 5040;
  signal o: integer;
begin

  gcd_inst: entity work.gcd(with_process) port map (a,b,o);
  
  process begin
    wait on o;
    report "gcd(" & integer'image(a) & "," 
                  & integer'image(b) & ") = " & integer'image(o);
  end process;  
end;

architecture with_process1 of gcd_tb is
  signal a: integer := 3528;
  signal b: integer := 5040;
  signal o: integer;
begin

  a <= 7364 after 20 ns, 234234 after 30 ns;

  gcd_inst: entity work.gcd(with_process) port map (a,b,o);
  
  process begin
    wait on o;
    report "gcd(" & integer'image(a) & "," 
                  & integer'image(b) & ") = " & integer'image(o);
  end process;  
end;

  
-- architecture with_procedure of gcd_tb is
  
--   procedure gcd(xi, yi: in integer; outp: out integer) is
--     variable x,y : integer;
--   begin
--     x := xi;
--     y := yi;
--     while (x /= y) loop
--       if (x < y)
--         then y := y - x;
--         else x := x - y;
--       end if;
--     end loop;
--     outp := x;
--   end procedure;
      
--   begin
    
--     process
--       variable a    : integer := 3528;
--       variable b    : integer := 5040;
--       variable outp : integer;
--     begin
--       gcd(a, b, outp);
--       report "gcd(" & integer'image(a) & "," 
--                     & integer'image(b) & ") = " & integer'image(outp);
--       wait;              
--     end process;
    
--   end;
