library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package casts is
  function to_int(arg: std_logic)               return natural;
  function to_int(arg: std_logic_vector)        return natural;
  function to_int(arg: unsigned)                return natural;
  function to_int(arg: signed)                  return natural;
  function to_slv(arg: integer; bits: integer)  return std_logic_vector;
  function to_slv(arg: unsigned)                return std_logic_vector;
  function to_slv(arg: signed)                  return std_logic_vector;
  function to_slv(arg: std_ulogic_vector)       return std_logic_vector;
  function to_slvs(arg: integer; bits: integer) return std_logic_vector;
end;

package body casts is
  
  subtype logic is std_logic;
  type logic_vector is array (natural range <>) of std_logic;

  function to_int (arg: std_logic) return natural IS
  begin
    if (arg = '1') then
      return 1;
    else
      return 0;
    end if;    
  end;

  function to_int (arg: std_logic_vector) return natural IS
  begin
    return to_integer(unsigned(arg));
  end;

  function to_int (arg: unsigned) return natural IS
  begin
    return to_integer(arg);
  end;

  function to_int (arg: signed) return natural IS
  begin
    return to_integer(arg);
  end;

  function to_slvs(arg: integer; bits: integer) return std_logic_vector is
  begin
    return std_logic_vector(to_signed(arg,bits));
  end;

  function to_slv(arg: integer; bits: integer) return std_logic_vector is
  begin
    return std_logic_vector(to_unsigned(arg,bits));
  end;

  function to_slv(arg: unsigned) return std_logic_vector IS     
  begin     
    return std_logic_vector(arg);    
  end;

  function to_slv(arg: std_ulogic_vector) return std_logic_vector IS     
  begin     
    return to_stdlogicvector(arg);    
  end;
  
  function to_slv(arg: signed) return std_logic_vector IS     
  begin     
    return std_logic_vector(arg);    
  end;

  function chr2sl (ch: in character) return std_logic is
    begin
      case ch is
        when 'U' | 'u' => return 'U';
        when 'X' | 'x' => return 'X';
        when '0'       => return '0';
        when '1'       => return '1';
        when 'Z' | 'z' => return 'Z';
        when 'W' | 'w' => return 'W';
        when 'L' | 'l' => return 'L';
        when 'H' | 'h' => return 'H';
        when '-'       => return '-';
        when OTHERS    => assert false
                          report "Illegal Character found" & ch
                          severity error;
                          return 'U';
      end case;
    end;
    
    function str2sl (s: string) return std_logic_vector is
      variable vector: std_logic_vector(s'LEFT - 1 DOWNTO 0);
    begin
      for i in s'RANGE loop
        vector(i-1) := chr2sl(s(i));
      end loop;
      return vector;
    end;
    
end;
