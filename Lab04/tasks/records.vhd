library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package records is
  
  type FlagType is record
    v, c, n, z, lt, le, gt, ge: std_logic;      
  end record;
    
end;

package body records is
end;  
