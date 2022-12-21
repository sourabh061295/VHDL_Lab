library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.casts.all;
use work.types.all;

package functions is
  function log2  (a          : natural)                             return natural;
  function replicate(s       : std_logic; n: integer)               return std_logic_vector;
  function decode(arg        : std_logic_vector)                    return std_logic_vector;
  function mux(Inputs, Sel   : std_logic_vector)                    return std_logic;
  function mux(Inputs        : arr_of_slv; Sel : std_logic_vector)  return std_logic_vector;
  function reduce(Inputs     : std_logic_vector )                   return std_logic_vector;
end;  
  
package body functions is

  function log2 (a: natural) return natural IS
    variable val : natural := a;
    variable log : natural := 0;
  begin
    for i in a downto 0 loop
      val := val / 2;
      if val > 0 then
        log := log + 1;
      end if;
    end loop;
    return log;
  end;

  function replicate(s: std_logic; n: integer) return std_logic_vector is
    variable r : std_logic_vector(n-1 downto 0);
  begin
    for i in 0 to n-1 loop
      r(i) := s;
    end loop;
    return r;
  end;

  function decode (arg : std_logic_vector) return std_logic_vector is
		variable res : std_logic_vector((2**arg'length)-1 downto 0);
	begin
		res(to_int(arg)) := '1';
		return res;
	end;

  function mux( Inputs, Sel : std_logic_vector ) return std_logic is  
  begin
     
    return Inputs(to_int(Sel));

  end;

  function mux( Inputs: arr_of_slv; Sel : std_logic_vector ) return std_logic_vector is  
  begin

    assert Inputs'length <= 2 ** Sel'length
      report "Inputs size: " & integer'image(Inputs'length) & " is too big for the select";
     
    return Inputs(to_int(Sel));

  end;

  function reduce( Inputs : std_logic_vector ) return std_logic_vector is
    constant N   : integer := Inputs'length;
    variable inp : std_logic_vector(N-1 downto 0);
  begin
    inp := Inputs;
    if(N = 4) then
      return inp(1 downto 0) xor inp(3 downto 2);
    else
      return reduce(inp((N-1) downto N/2)) xor reduce(inp(((N/2)-1) downto 0));
    end if;
  end;
end;  