library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use work.types.all;
use work.functions.all;
use work.casts.all;

entity shifter is
	generic (	N     : natural := 32);
	port    (	a     : in  std_logic_vector(N-1       downto 0);
            	func  : in  std_logic_vector(  2       downto 0);
			    shamt : in  std_logic_vector(log2(N)-1 downto 0); 
            	y     : out std_logic_vector(N-1       downto 0)
          	);
end;

architecture rtl of shifter is
begin
	process(all)
		variable rotr, rotl, ashr, lshr, lshl : arr_of_slv(N-1 downto 0)(N-1 downto 0); 
	begin
				
		lshr(0) := a; lshl(0) := a; ashr(0) := a; rotr(0) := a; rotl(0) := a;
		for i in 1 to N-1 loop
			lshr(i) := (i-1 downto 0 => '0')    & a(N-1 downto i);
			lshl(i) := a((N-1)-i downto 0)      &  (i-1 downto 0 => '0');	
			ashr(i) := (i-1 downto 0 => a(N-1)) & a(N-1 downto i); 
			rotr(i) := a(    i-1 downto 0)      & a(N-1 downto i); 
			rotl(i) := a((N-1)-i downto 0)      & a(N-1 downto N-i);
		end loop;	
		
		y <= 	lshr(to_int(shamt)) when func = "000" else
					lshl(to_int(shamt)) when func = "001" else
					rotr(to_int(shamt)) when func = "010" else
					rotl(to_int(shamt)) when func = "011" else
					ashr(to_int(shamt));
	end process;

end;