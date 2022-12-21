library IEEE; 
use IEEE.STD_logic_1164.ALL;

entity shiftreg is
  generic (N     : integer := 8);
  port ( clk, rst : in     std_logic;
         load     : in     std_logic;
         d        : in     std_logic_vector(N-1 downto 0);
         q        : buffer std_logic
       );
end;

architecture withproc of shiftreg is
  signal sreg : std_logic_vector(N-1 downto 0);
begin

  process(clk, rst) begin
    if rst = '1' then 
        sreg <= (others => '0');
    elsif rising_edge(clk) then
      if load='1' then
        sreg <= d;
      else
        sreg <= sreg(N-2 downto 0) & '0';
      end if;
    end if;
  end process;

  q <= sreg(N-1);

end;

architecture withwhen of shiftreg is
  signal sreg, inp : std_logic_vector(N-1 downto 0);
begin

  inp   <= d               when load = '1' else    -- combinational part (mux)
           sreg(N-2 downto 0) & '0';

  sreg  <= (others => '0') when rst = '1' else     -- sequential part (register)
           inp             when rising_edge(clk);

  q <= sreg(N-1);

end;

-- architecture withprocedure of shiftreg is
  
--   procedure sreg (signal clk, rst, load : in  std_logic;
--                  signal d               : in  std_logic_vector;               
--                  signal q               : out std_logic ) is
                 
--    variable sreg: std_logic_vector(d'length-1 downto 0);              
                    
--   begin    
--     if rst = '1' then 
--       sreg := (others => '0');
--     elsif clk = '1' and clk'event then
--       if load =' 1' then
--         sreg := d;
--       else
--         sreg := sreg(N-2 downto 0) & '0';
--       end if;  
--     end if;
--     q <= sreg(N-1);
--   end;
  
-- begin
   
--   sreg(clk, rst, load, d, q);
      
-- end architecture;