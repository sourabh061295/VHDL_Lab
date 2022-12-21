entity processes is
  port ( a,b           : in  integer;
         r1, r2, r3, r4: out integer
  );
end;

architecture rtl of processes is
  
  --signal a                 : integer := 7;
  --signal b                 : integer := 5;
  signal t1, t2, t3, t4    : integer := 0;
  --signal r1, r2, r3, r4    : integer := 0;
  
begin 
  
  p1: process (a,b)          
    variable c,t : integer := 0;
  begin
      t  := a + 2;        
      c  := t * b; 
      r1 <= c;
  end process;
    
  p2: process (a,b)           
    variable c : integer := 0;
  begin
      t1 <= a + 2;        
      c  := t1 * b; 
      r2 <= c;
  end process;
  
  p3: process (a,b)         
    variable c,t : integer := 0;
  begin
      c  := a + 2;        
      t2 <= c * b; 
      r3 <= t2;
  end process;
     
  p4: process (a,b)      
    variable c,t : integer := 0;
  begin
      t3 <= a + 2;        
      t4 <= t3 * b; 
      r4 <= t4;
  end process;
end;
