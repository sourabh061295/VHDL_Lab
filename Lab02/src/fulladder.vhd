library IEEE; 
use IEEE.std_logic_1164.all;

entity fulladder is
  port ( a, b, cin: in  std_logic;
         s, cout  : out std_logic
       );
end;

architecture withvars of fulladder is
begin
  
  fa: process(a, b, cin)       
    variable p,g : std_logic;  
  begin
    p    := a xor b;           
    g    := a and b;           
    s    <= p xor cin;         
    cout <= g or (p and cin);  
  end process;
  
end;

architecture withsignals of fulladder is
  signal p,g: std_logic;
begin
  
  fa: process(a, b, cin, p, g) 
  begin
    p    <= a xor b;           
    g    <= a and b;           
    s    <= p xor cin;         
    cout <= g or (p and cin);  
  end process;
  
end;