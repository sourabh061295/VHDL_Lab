library IEEE; 
use IEEE.std_logic_1164.all;

entity fulladder is
  port ( a, b, ci: in  std_logic;
         s, co   : out std_logic
       );
end;

architecture withsignals of fulladder is
  begin
    
    fa: process(a, b, ci)   
    begin
      s	 <=  a xor b xor ci;	
      co <= (a and b) or (a and ci) or (b and ci);	
    end process;
    
  end;
  
  architecture withpg of fulladder is
    signal p,g: std_logic;
  begin
    
    fa: process(a, b, ci, p, g) 
    begin
      p  <= a  or b;           
      g  <= a and b;           
      s  <= a xor b xor ci;         
      co <= g or (p and ci);  
    end process;
    
  end;
  
  architecture withfunction of fulladder is
  
    function fa(a,b,ci: std_logic) return std_logic_vector is
      variable p, g, s, co : std_logic;
    begin
      p  := a  or b;                        -- propagate carry
      g  := a and b;                        -- generate  carry
      s  := a xor b xor ci; 
      co := g or (p and ci);                -- (10)
      return (co,s);
    end;   
  
  begin
     
    (co,s) <= fa(a,b,ci);
     
  end;

architecture withmux of fulladder is

  function mux(sel: std_logic_vector; in0, in1, in2, in3: std_logic) return std_logic is
    variable o : std_logic;
  begin
    o := in0 when sel="00" else
         in1 when sel="01" else
         in2 when sel="10" else
         in3;
    
    return o;     
  end;  

  signal nci: std_logic;

begin

  nci <= not ci;
  co  <= mux((a & b), '0', ci, ci, '1');
  s   <= mux((a & b), ci, nci, nci, ci);
   
end;