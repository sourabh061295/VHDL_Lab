entity gcd is                   
  port (a, b : in  integer;   
        o    : out integer);  
end;

architecture with_process of gcd is
begin
  process (a, b)
    variable x,y : integer;
  begin  
    x := a;
    y := b;
    while (x /= y) loop
      if (x < y)
        then y := y - x;
        else x := x - y;
      end if;
    end loop;
    o <= x;
  end process;
end;
