library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package casts is
  function to_int(arg: std_logic_vector)       return natural;
  function to_sint(arg: std_logic_vector)      return integer;
  function to_int(arg: unsigned)               return natural;
  function to_int(arg: signed)                 return natural;
  function to_slv(arg: integer; bits: integer) return std_logic_vector;
  function to_slv(arg: unsigned)               return std_logic_vector;
  function to_slv(arg: signed)                 return std_logic_vector;
  function to_slv(arg: std_ulogic_vector)      return std_logic_vector;
  function to_sslv(arg: integer; bits: natural) return std_logic_vector;

  function str(s: std_ulogic_vector)           return string;
  function str(s: integer)                     return string;
  function strs(s: std_ulogic_vector)          return string;
  function strs(s: integer)                    return string;
  function strs(s: std_logic)                  return string;
  function str(s: std_logic)                   return character;
end;

package body casts is
  
  subtype logic is std_logic;
  type logic_vector is array (natural range <>) of std_logic;

  function to_int (arg: std_logic_vector) return natural IS
  begin
    return to_integer(unsigned(arg));
  end;

  function to_sint (arg: std_logic_vector) return integer IS
    variable x : signed(arg'range);
  begin
    x := signed(arg);
    return to_integer(x);
  end;

  function to_int (arg: unsigned) return natural IS
  begin
    return to_integer(arg);
  end;

  function to_int (arg: signed) return natural IS
  begin
    return to_integer(arg);
  end;

  function to_slv(arg: integer; bits: integer) return std_logic_vector is
  begin
      return std_logic_vector(to_unsigned(arg,bits));
  end;

  function to_sslv(arg: integer; bits: natural) return std_logic_vector is
  begin
      return std_logic_vector(to_signed(arg,bits));
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

    function to_char(s: std_ulogic) return character is
    begin
      case s is
        when 'X' => return 'X';  
        when '0' => return '0';  
        when '1' => return '1';  
        when 'Z' => return 'Z';  
        when 'U' => return 'U';  
        when 'W' => return 'W';  
        when 'L' => return 'L';  
        when 'H' => return 'H';  
        when '-' => return '-';  
      end case;
    end;

  function str(s: std_ulogic_vector) return string is
    variable ret:string(1 to s'length);
    variable K  : integer:= 1;
  begin
    for J in s'range loop
      ret(K) := to_char(s(J));
      K := K + 1;
    end loop;
    return ret;      
  end;  

  function strs(s: std_ulogic_vector) return string is
  begin
    return str(s) & " ";
  end;   

  function str(s: std_logic) return character is
  begin  
    return to_char(s);    
  end; 
  
  function strs(s: std_logic) return string is
  begin
    return str(s) & " ";
  end; 

  function to_nstring(s: natural) return string is
    variable ret, iret : string(1 to 16);
    variable k, j      : integer;
    variable s1, s2, s3: natural := 0;
  begin  

    s1     := s;
    ret(1) := '0';  
    k      := 1;  
  
    while (s1 > 0 and K < 16) loop
      s2 := s1 / 10;
      s3 := s1 - (s2 * 10);
      if (s3 = 0) then 
        ret(k) := '0';
      elsif (s3 = 1) then
        ret(k) := '1';
      elsif (s3 = 2) then
        ret(k) := '2';
      elsif (s3 = 3) then
        ret(k) := '3';
      elsif (s3 = 4) then
        ret(k) := '4';
      elsif (s3 = 5) then
        ret(k) := '5';
      elsif (s3 = 6) then
        ret(k) := '6';
      elsif (s3 = 7) then
        ret(k) := '7';
      elsif (s3 = 8) then
        ret(k) := '8';
      elsif (s3 = 9) then
        ret(k) := '9';
      end if;
      k := k + 1;
      s1 := s2;
    end loop;
  
    if (k > 1) then
      k := k-1;
    end if;

    J := 1;
    while (k > 0) loop
      iret(j) := ret(k);
      k := k-1;
      j := j+1;
    end loop;        

    return iret;      

  end;


  function str(s: integer) return string is
  begin
    if (s < 0) then
      return "-" & to_nstring(-s);
    else
      return to_nstring(s);
    end if;    
  end;
 
  function strs(s: integer) return string is
  begin
    return str(s) & ' ';
  end;

end;   
