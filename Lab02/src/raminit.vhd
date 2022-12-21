library IEEE; 
use IEEE.std_logic_1164.all;
use std.textio.all; 
use work.casts.all;

entity raminit is 
  generic ( InitFile : string  := "init.mem";
            Depth    : integer := 4;
            Width    : integer := 16);
  port    ( wclk, rclk, we, re  : in  std_logic;
            raddr, waddr        : in  std_logic_vector (Depth-1 downto 0);
            din                 : in  std_logic_vector (Width-1 downto 0);
            dout                : out std_logic_vector (Width-1 downto 0)
          );
end;

architecture synth of raminit is

  type MemType is array((2**Depth-1) downto 0) of std_logic_vector(Width-1 downto 0);
       
  impure function initRam(filename: string) return MemType is
    file text_file       : text open read_mode is filename; 
    variable text_line   : line;
    variable ram_content : MemType;
  begin
    for i in 0 to 2**Depth-1 loop
      readline(text_file, text_line);
      hread(text_line, ram_content(i));
    end loop;
   
    return ram_content;
  end;    
       
  signal mem: MemType := initRam(InitFile);

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
    if rising_edge(rclk) then
      if re = '1' then
        dout <= mem(to_int(raddr)); 
      end if;  
    end if;
  end process;
end;  