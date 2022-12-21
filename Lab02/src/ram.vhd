library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ramtypes is
  type RdAccT is (ASYNC, SYNC);
end;

package body ramtypes is
end;

library IEEE; 
use IEEE.std_logic_1164.all; 
use work.casts.all;
use work.ramtypes.all;

entity ram is 
  generic ( Width: integer := 16; Depth : integer := 4; readaccess: RdAccT := ASYNC);
  port    ( wclk, rclk, we, re  : in  std_logic;
            raddr, waddr        : in  std_logic_vector (Depth-1 downto 0);
            din                 : in  std_logic_vector (Width-1 downto 0);
            dout                : out std_logic_vector (Width-1 downto 0)
          );
end;

architecture behave of ram is
  
  type ramtype is array (2**Depth-1 downto 0) of std_logic_vector(Width-1 downto 0);
  signal mem: ramtype;

begin
  
  process (wclk)
  begin
    if rising_edge(wclk) then
      if we = '1' then
        mem(to_int(waddr)) <= din; 
      end if;
    end if;  
  end process;

  process (rclk)
  begin
    if readaccess = SYNC then
      if rising_edge(rclk) then
        if re = '1' then
          dout <= mem(to_int(raddr)); 
        end if;  
      end if;
    else -- readaccess = ASYNC
      if re = '1' then
        dout <= mem(to_int(raddr)); 
      else
        dout <= (others=>'0');  
      end if;
    end if;    
  end process;
end;
