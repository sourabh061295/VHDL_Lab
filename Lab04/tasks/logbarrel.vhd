library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use work.types.all;
use work.functions.all;
use work.casts.all;

entity logbarrel is
	generic (	N     : natural := 32);
	port    (	a     : in  std_logic_vector(N-1       downto 0); -- input data word
            	func  : in  std_logic_vector(  2       downto 0); -- ctrl word (000=>>, 001=<<, 010=*>, 011=<*, 100=>>>)
			    shamt : in  std_logic_vector(log2(N)-1 downto 0); -- shift amount
            	y     : out std_logic_vector(N-1       downto 0)  -- output data word
          	);
end;

architecture rtl1 of logbarrel is
	begin
		process(all)
      	constant stage : natural := log2(N);                              -- number of stages
      	variable rotr  : arr_of_slv(stage-1 downto 0)(N-1 downto 0);      -- rotated words
      	variable mask  : arr_of_slv(    N-1 downto 0)(N-1 downto 0);      -- masks for all possible shifts
		variable sh    : std_logic_vector(shamt'range) := (others =>'0'); -- used as actual shift amount
			
		begin
  
      -- left or right shift
		if ((func = "000") or (func = "010") or (func = "100")) then  
			sh := shamt; 
		else
			sh := std_logic_vector((N - unsigned(shamt)));
		end if;
      
      --  1st stage
		if (sh(stage-1) = '1') then	 -- shift if needed
			rotr(stage-1) := a ror N/2; 
		else 
			rotr(stage-1) := a;
		end if;	
  
      -- i-th stage 
		for i in (stage-2) downto 0 loop
			if (sh(i) = '0') then    -- shift if needed
				rotr(i) := rotr(i+1);
			else
				rotr(i) := rotr(i+1) ror N/(2**(sh'length-i));
			end if;	
		end loop;
            
      -- mask the rotated data if needed
		for i in 0 to N-1 loop
			if (i = 0) then
				mask(i) := ((N-1) downto 0 => '1');
			else
				case func is
					when "000" | "100" => mask(i) := (N-1 downto N-i => '0') & (N-1-i downto 0 => '1');   -- right shift
					when "001" 		   => mask(i) := (N-1 downto N-i => '1') & (N-1-i downto 0 => '0'); 			-- left shift
					when "010" | "011" => mask(i) := (N-1 downto 0 => '1'); 									-- rotate
					when others 	   => mask(i) := (N-1 downto 0 => '1');									-- this case 101 should not occur
				end case; 
			end if;
		end loop;	
      
      -- output masking
		y <=  (not(mask(to_int(sh))) or rotr(0)) when (func = "100" and a(N-1) = '1') else         -- masking for arith. right shift
				(rotr(0) and mask(to_int(sh)));	                      -- masking for all other cases
		end process;
		
  end;