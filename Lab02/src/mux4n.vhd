library IEEE; 
use IEEE.std_logic_1164.all;
use work.all;
use work.casts.all;
use work.functions.all;
use work.types.all;

entity mux4n is
  generic ( N: integer := 12 );
  port ( d0, d1, d2, d3: in  std_logic_vector(N-1 downto 0); 
         s             : in  std_logic_vector(  1 downto 0); 
         y             : out std_logic_vector(N-1 downto 0)
       );
end;

architecture struct of mux4n is

  signal low, high: std_logic_vector(N-1 downto 0);

begin

  lowmux  : entity work.mux2n 
            generic map(N => N) 
            port    map(d0, d1 , s(0), low);
  highmux : entity work.mux2n 
            generic map(N) 
            port    map(d2, d3, s(0), high);
  finalmux: entity work.mux2n 
            generic map(N) 
            port    map(low, high, s(1), y);

end;

architecture whensel of mux4n is
begin
  
  y <= d0 when s = "00" else
       d1 when s = "01" else
       d2 when s = "10" else
       d3;
  
end;

architecture withsel of mux4n is
begin

       with s select 
  y <= d0 when "00",
       d1 when "01",
       d2 when "10",
       d3 when others;
end;

architecture synth of mux4n is
  signal d: arr_of_slv(2**2-1 downto 0)(N-1 downto 0);
begin
   
    d(0) <= d0;
    d(1) <= d1;
    d(2) <= d2; 
    d(3) <= d3;

    y <= mux(d,s);      --y <= d(to_int(s));   
    
end;

architecture whenxor of mux4n is
  signal d: arr_of_slv(2**2-1 downto 0)(N-1 downto 0);
begin

    d(0) <= d0 when s= "00" else (others =>'0');
    d(1) <= d1 when s= "01" else (others =>'0');
    d(2) <= d2 when s= "10" else (others =>'0');
    d(3) <= d3 when s= "11" else (others =>'0');
    y    <= d(0) xor d(1) xor d(2) xor d(3);

end;

architecture withxor of mux4n is
  signal d: arr_of_slv(2**2-1 downto 0)(N-1 downto 0);
begin
            with s select
    d(0) <= d0 when "00",  (others =>'0') when others;
            with s select
    d(1) <= d1 when "01",  (others =>'0') when others;
            with s select
    d(2) <= d2 when "10",  (others =>'0') when others;
            with s select
    d(3) <= d3 when "11",  (others =>'0') when others;
    y <= d(0) xor d(1) xor d(2) xor d(3);

end;

architecture proccase of mux4n is
begin

  process(s, d0, d1, d2, d3)
  begin
    case s is
      when "00"   => y <= d0;
      when "01"   => y <= d1;
      when "10"   => y <= d2;
      when others => y <= d3;  
    end case;  
  end process;     
end;

architecture procif of mux4n is
begin

  process(s, d0, d1, d2, d3)
  begin
    if     s="00" then y <= d0;
    elsif  s="01" then y <= d1;
    elsif  s="10" then y <= d2;
    else               y <= d3;  
    end if;  
  end process;     
end;

architecture procif2 of mux4n is
  signal d: arr_of_slv(2**2-1 downto 0)(N-1 downto 0);
begin
  
  process(s, d0, d1, d2, d3)
  begin
    if s="00" then d(0) <= d0; else d(0) <= (others => '0'); end if;
    if s="01" then d(1) <= d1; else d(1) <= (others => '0'); end if;
    if s="10" then d(2) <= d2; else d(2) <= (others => '0'); end if;
    if s="11" then d(3) <= d3; else d(3) <= (others => '0'); end if;
    y <= d(0) xor d(1) xor d(2) xor d(3);
  end process;     
end;

architecture procfor of mux4n is
  signal d: arr_of_slv(2**2-1 downto 0)(N-1 downto 0);
begin
   
    d(0) <= d0;
    d(1) <= d1;
    d(2) <= d2; 
    d(3) <= d3;
    
    process (d,s) 
      variable mux2: arr_of_slv(2**2-1 downto 0)(N-1 downto 0);
      variable yi: std_logic_vector(N-1 downto 0);
    begin
      yi := (others => '0');
      for i in 0 to 3 loop
        if to_int(s)=i then mux2(i) := d(i); else mux2(i) := (others =>'0'); end if;
        yi := yi xor mux2(i);
      end loop;
      y <= yi;
    end process;
    
end;

-- architecture procfortree of mux4N is
--   signal d: arr_of_slv(2**2-1 downto 0)(N-1 downto 0);

--   function reduction( inputs: arr_of_slv ) return std_logic_vector is
--     variable lower, upper: std_logic_vector(11 downto 0); --inputs(0)'range);
--     constant N   : integer := inputs'length;
--     variable inp : array_of_slv(N-1 downto 0)(11 downto 0);
--   begin
--     N   := inputs'length;
--     inp := inputs;
--     if N = 1 then 
--        return inp(0); 
--     elsif N > 1 then
--        lower := reduction(inp(N/2-1 downto 0));
--        upper := reduction(inp(N-1 downto N/2));
--        return upper xor lower;
--     end if;   
--   end;  

-- begin
   
--     d(0) <= d0;
--     d(1) <= d1;
--     d(2) <= d2; 
--     d(3) <= d3;
    
--     process (d,s) 
--       variable mux2: arr_of_slv(2**2-1 downto 0)(N-1 downto 0);
--       variable yi: std_logic_vector(N-1 downto 0);
--     begin
--       yi := (others => '0');
--       for i in 0 to 3 loop
--         if to_int(s)=i then mux2(i) := d(i); else mux2(i) := (others =>'0'); end if;
--         --yi := yi xor mux2(i);
--       end loop;
--       y <= reduction(d);
--     end process;
    
-- end;

