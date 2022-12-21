Library ieee;
use ieee.std_logic_1164.ALL; 
use std.textio.all; 
use work.records.all;     
use work.casts.all; 
use ieee.numeric_std.all;     

entity alu_test is
  generic (N : natural := 4);
end;

architecture test of alu_test is
  signal clk, cin : std_logic := '0';
  signal a, b, res: std_logic_vector(N-1 downto 0) := (others => '0');
  signal flags    : FlagType := ('0','0','0','0','0','0','0','0');
  signal ctrl     : std_logic_vector(1 downto 0) := (others => '0');
begin

  alu_inst: entity work.alu generic map (N)    -- alu instantiation
                            port    map (a, b, cin, ctrl, res, flags);

  clk <= not clk after 10 ns;  -- clock generator                 
  
  process is
    file tv                 : text;
    variable L              : line;
    variable ai, bi         : integer;
    variable aluop          : character;
    variable dummy          : character;
    variable ci             : std_logic;
    variable result_expect  : std_logic_vector(N-1 downto 0);
    variable flags_expect,
             relas_expect   : std_logic_vector(3 downto 0); 
    variable ln             : integer := 0;         

    function to_ctrl(aluop:character) return std_logic_vector is
      variable aluctrl      : std_logic_vector(1 downto 0);
    begin
      case aluop is
        when '+'    => aluctrl := "00";
        when '-'    => aluctrl := "01";
        when '^'    => aluctrl := "10";
        when others => aluctrl := "11";
      end case;
      return aluctrl;  
    end;    

  begin
    file_open(tv, "alu.tv", READ_MODE); 
    readline(tv,L);                     -- comment line            
    readline(tv,L);                     -- comment line
    while not endfile(tv) loop
      wait until rising_edge(clk);      -- change vectors on rising edge 
      readline(tv, L);                  -- read the next line of testvectors 
      read(L, ai);                      -- read a input vector (N-bit)
      read(L, dummy);                   -- skip over whitespace character
      read(L, aluop);                   -- operation (+|-|^|v)
      read(L, dummy);                   
      read(L, bi);                      -- read b input vector (N-bit)
      read(L, dummy);                   
      read(L, dummy);                   -- read operation
      read(L, dummy);
      read(L, ci);                      -- read carry-in 
      read(L, dummy);
      read(L, dummy);                   -- read '='
      read(L, dummy);
      read(L, result_expect);            -- expected result vector (N-bit)
      read(L, dummy);
      read(L, flags_expect);            -- expected flags vector (4bit)
      read(L, dummy);                   -- read ':'
      read(L, relas_expect);            -- expected relations vector (4bit)

      ln := ln + 1;

      a    <= to_sslv(ai,N);            -- convert integer to std_logic_vector
      b    <= to_sslv(bi,N);
      cin  <= ci;
      ctrl <= to_ctrl(aluop);           -- convert (+|-|^|v) operator to alu control word

      wait until falling_edge(clk);     -- check results on falling edge
        assert  (res = result_expect) 
                report  "Result error in line " & str(ln+2) & ": " & 
                        strs(ai) & aluop & " " & strs(bi) & str(ci) & " = " & str(res) & " /= " & str(result_expect);

        assert  (flags.Z  = flags_expect(3)) and (flags.N = flags_expect(2)) and 
                (flags.V  = flags_expect(1)) and (flags.C = flags_expect(0)) 
                report "Flag error in line " & str(ln+2) & ": " & str(flags.Z) & str(flags.N) & str(flags.V) & str(flags.C);
                
        assert  (flags.LT = relas_expect(3)) and (flags.LE = relas_expect(2)) and
                (flags.GT = relas_expect(1)) and (flags.GE = relas_expect(0)) 
                report "Relation error in line " & str(ln+2) & ": " & strs(ai) &  aluop & " " &  strs(bi) & strs(ci)  & "= " &
                       str(flags.LT) & str(flags.LE) & str(flags.GT) & str(flags.GE) & " /= " & str(relas_expect);
                                             
    end loop; 

    file_close(tv);
    wait;
  end process; 
end; 

--     5  = 0101      5  = 00101    (-5) = 01011    (-5) = 1011      3  = 0011    3 = 0011   (-3) = 01101    (-3) = 01101   
-- - (-3) = 0011    - 3  = 01101   -  3  = 01101  - (-3) = 0011  - (-5) = 0101  - 5 = 1011   - 5  = 01011  - (-5) = 00101
--     c    1110      c  = 11010      c  = 11110      c  = 0110      c  = 1110    c = 0110     c  = 11110      c  = 11010
-----------------    -----------   -------------  -------------  -------------  ----------   ------------  --------------
--     8  = 1000      2  = 10010     -8  = 11000     -2  = 1110      8  = 1000   -2 = 1110    -8  = 11000      2  = 10010

--     6  = 0110    (-6) = 01010    (-3) = 01101      3  = 0011  
-- - (-3) = 0011   -  3  = 01101   -  6  = 01010  - (-6) = 0110
--     c    1100      c  = 10000      c  = 10000      c  = 1100
---------------------------------------------------------------
--     9  = 1001     -9  = 10111     -9  = 10111      9  = 1001         

