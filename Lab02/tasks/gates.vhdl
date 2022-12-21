library IEEE; 
use IEEE.std_logic_1164.all;

entity gates is 
  port ( a, b: in  std_logic; 
         y   : out std_logic_vector(6 downto 0)
       );
end;

architecture slice of gates is              

  signal   t: std_logic_vector(6 downto 0); 

begin

  t(0) <= a and  b;                         
  t(1) <= a or   b;
  t(2) <= a xor  b;
  t(3) <=   not  a;
  t(4) <= a nand b;
  t(5) <= a nor  b;
  t(6) <= a xnor b;

  y <= t;

end;

architecture concate of gates is   
begin

  y <= (a xnor b) & (a nor b) & (a nand b) & (not a) & (a xor b) & (a or b) & (a and b);

end;

architecture aggregate of gates is   
begin

  y <= ((a xnor b), (a nor b), (a nand b), (not a), (a xor b), (a or b), (a and b));

end;


-- Architecture using process
architecture withprocess of gates is   
begin 
  -- Process sensible to inputs a and b
  process (a,b)
  -- Temporary variable 't' decalaration
  variable t: std_logic_vector(6 downto 0);
  begin
    -- Gate logics
    t(0) := a and  b;                         
    t(1) := a or   b;
    t(2) := a xor  b;
    t(3) :=   not  a;
    t(4) := a nand b;
    t(5) := a nor  b;
    t(6) := a xnor b;

    -- Output signal assignment
    y <= t;
  end process;

end;