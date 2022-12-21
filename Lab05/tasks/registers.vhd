library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package registers is
  procedure dff   ( signal clk            : in  std_logic;
                    signal d              : in  std_logic;            
                    signal q              : out std_logic);

  procedure reg   ( signal clk            : in  std_logic;
                    signal d              : in  std_logic_vector;                  
                    signal q              : out std_logic_vector);

  procedure reg   ( signal clk            : in  std_logic;
                    signal d              : in  std_logic_vector;                  
                    signal q              : out unsigned);  
                    
  procedure reg   ( signal clk            : in  std_logic;
                    signal d              : in  unsigned;                  
                    signal q              : out unsigned);                  
                 
  procedure dffar ( signal clk, rst       : in  std_logic; 
                    signal d              : in  std_logic;                
                    signal q              : out std_logic); 
                    
  procedure regar ( signal clk, rst       : in  std_logic;
                    signal d              : in  std_logic_vector;                  
                    signal q              : out std_logic_vector); 
                    
  procedure dffe (  signal clk, rst, ena  : in  std_logic; 
                    signal d              : in  std_logic; 
                    signal q              : out std_logic);
                    
  procedure rege (  signal clk, rst, ena  : in  std_logic; 
                    signal d              : in  std_logic_vector; 
                    signal q              : out std_logic_vector);                  

end;  


package body registers is

  procedure dff   ( signal clk            : in  std_logic;
                    signal d              : in  std_logic;                  
                    signal q              : out std_logic) is
  begin    
    if clk = '1' and clk'event then      
      q <= d;
    end if;
  end;

  procedure reg   ( signal clk            : in  std_logic;
                    signal d              : in  std_logic_vector;                  
                    signal q              : out std_logic_vector) is
  begin    
    if clk = '1' and clk'event then      
      q <= d;
    end if;
  end;  

  procedure reg   ( signal clk            : in  std_logic;
                    signal d              : in  unsigned;                  
                    signal q              : out unsigned) is
  begin    
    if clk = '1' and clk'event then      
    q <= d;
    end if;
  end;  

  procedure reg   ( signal clk            : in  std_logic;
                    signal d              : in  std_logic_vector;                  
                    signal q              : out unsigned) is
  begin    
    if clk = '1' and clk'event then      
    q <= unsigned(d);
    end if;
  end;    

  procedure dffar ( signal clk, rst       : in  std_logic;
                    signal d              : in  std_logic;                  
                    signal q              : out std_logic) is
  begin    
    if rst = '1' then
      q <= '0';
    elsif clk = '1' and clk'event then      
      q <= d;
    end if;
  end;   

  procedure regar ( signal clk, rst       : in  std_logic;
                    signal d              : in  std_logic_vector;                  
                    signal q              : out std_logic_vector) is
  begin    
    if rst = '1' then
      for i in q'range loop q(i) <= '0'; end loop;  
    elsif clk = '1' and clk'event then      
      q <= d;
    end if;
  end; 

  procedure dffe (  signal clk, rst, ena  : in  std_logic; 
                    signal d              : in  std_logic; 
                    signal q              : out std_logic) is
  begin  
    if rst='1' then 
      q <= '0';
    elsif clk = '1' and clk'event then  
      if ena='1' then
        q <= d;
      end if;
    end if;
  end;  

  procedure rege (  signal clk, rst, ena  : in  std_logic; 
                    signal d              : in  std_logic_vector; 
                    signal q              : out std_logic_vector) is
  begin  
    if rst='1' then 
      for i in q'range loop q(i) <= '0'; end loop;
    elsif clk = '1' and clk'event then 
      if ena='1' then
        q <= d;
      end if;
    end if;
  end;  

end;