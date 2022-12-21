library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cria is -- carry ripple adder
  generic (N: integer := 4);  
  port( a, b : in  std_logic_vector(N-1 downto 0); 
        ci   : in  std_logic;
        s    : out std_logic_vector(N-1 downto 0); 
        co   : out std_logic);
end;

architecture withgenerate of cria is
  signal c  : std_logic_vector(N downto 0);
begin
 
  c(0) <= ci;

  rca_inst: for i in 0 to N-1 generate
    fa_i_inst: entity work.fulladder(withfunction) port map (a(i), b(i), c(i), s(i), c(i+1));
  end generate;
 
  co <= c(N);

end;  

-- architecture withfunc of cria is

--   function fulladder(a,b,ci: std_logic) return std_logic_vector is
--     variable g, p, co, s: std_logic;
--   begin
--     p  := a or b;
--     g  := a and b;
--     s  := a xor b xor ci;
--     co := g or (p and ci);                -- (10)
--     co := (p nand ci) nand (a nand b);    -- (11)
--     co := g or (a and ci) or (b and ci);  --  (7)
--     return (co, s);
--   end; 

--   function cria ( a, b : std_logic_vector; ci : std_logic) return std_logic_vector is    
--      variable sum : std_logic_vector(a'length-1 downto 0);
--      variable c, s: std_logic;
--   begin   
--     c := ci;
--     for i in 0 to a'length-1 loop  
--         (c,s)  := fulladder(a(i), b(i), c);
--         sum(i) := s;
--     end loop;
--     return(c & sum);  
--   end;
  
--   signal sum: std_logic_vector(N downto 0);

-- begin
    
--   sum <= cria(a, b, ci);
--   s   <= sum(N-1 downto 0);
--   co  <= sum(N);
    
-- end; 

-- architecture rtl of cria is
 
--   signal g, p : std_logic_vector(N-1 downto 0); -- Generate, Propagate
--   signal c    : std_logic_vector(N   downto 0); -- Carries
 
-- begin
 
--   -- Create Full Adders
--   gen_fa : for i in 0 to N-1 generate
--      fa_inst : entity work.fulladder port map (a(i),b(i),c(i), s(i), open);
--   end generate;

--   -- Create carries
--   gen_cla : for j in 0 to N-1 generate
--     g(j)   <= a(j) and b(j);
--     p(j)   <= a(j) or  b(j);
--     c(j+1) <= g(j) or (p(j) and c(j));
--   end generate;
     
--   c(0) <= ci;
--   co   <= c(N);
   
-- end;

-- architecture genprop of cria is
--   signal g, p: std_logic_vector(N-1 downto 0);
--   signal c   : std_logic_vector(N   downto 0);
-- begin
--   ------- Computation of g and p:
--   g <= a and b;
--   p <= a or  b;
--   ------- Computation of carry logic:
--   c(0) <= ci;
--   gen_cla : for j in 0 to N-1 generate
--     c(j+1) <= g(j) or (p(j) and c(j));
--   end generate;
--   ------- Computation of sum and carry-out:
--   s  <= a xor b xor c(N-1 downto 0);
--   co <= c(N);
-- end;

-- architecture withfunc1 of cria is

--   function fulladder(a,b,ci: std_logic) return std_logic_vector is
--     variable g, p, co, s: std_logic;
--   begin
--     p  := a xor b;
--     g  := a and b;
--     s  := p xor ci;
--     co := g or p and ci;
--     return (co, s);
--   end;  

--   function cria ( a, b  : std_logic_vector; ci : std_logic) return std_logic_vector is    
--     variable sum       : std_logic_vector(a'length-1 downto 0); 
--     variable co        : std_logic_vector(a'length-1 downto 0);
--     variable c, s : std_logic;
--     variable r         : std_logic_vector(1 downto 0);
--   begin 
--     --(co(0),sum(0)) := fulladder(a(0),b(0),ci);

--     for i in 0 to a'length-1 loop  
--       (c,s) := fulladder(a(i), b(i), co(i-1));
--       co(i) := c; sum(i) := s;
--     end loop;
--     ovf := co(a'length-1) xor co(a'length-2);
--     return (ovf & co(a'length-1) & sum);
--   end;
  
--   signal s: std_logic_vector(N+1 downto 0);

-- begin
  
--   s    <= cria(a, b, cin);
--   sum  <= s(N-1 downto 0);
--   cout <= s(N);
--   ovf  <= s(N+1);
    
-- end; 

