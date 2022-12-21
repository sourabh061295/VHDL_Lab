-----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use std.textio.write;
use std.textio.output;

package riscv_pkg is
  subtype b1  is std_logic;
  subtype b2  is std_logic_vector( 1 downto 0);
  subtype b3  is std_logic_vector( 2 downto 0);
  subtype b5  is std_logic_vector( 4 downto 0);
  subtype b7  is std_logic_vector( 6 downto 0);
  subtype b11 is std_logic_vector(10 downto 0);
  subtype b32 is std_logic_vector(31 downto 0);

  type mctrlT is record
    resultsrc ,
    immsrc    : b2;
    memwr     , 
    alusrc    ,
    regwr     ,
    branch    ,
    jump      : b1;
    aluop     : b2;
  end record;

  type ctrlT is record
    m         : mctrlT;
    pcsrc     : b1;
    aluctrl   : b3;
  end record;

  impure function writeln( s: string) return string;

end;

package body riscv_pkg is

  impure function writeln( s: string) return string is
  begin  
    write(output, s & lf);
    return s(11 to 16);
  end;

end; 
-----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.riscv_pkg.all;

entity maindec is
  port ( opcode: in  b7;
         c     : out mctrlT);
end;
architecture rtl of maindec is
  signal ctrls : b11;
begin
            with opcode select
  ctrls <=  b"1_00_1_0_01_0_00_0" when "0000011", -- lw
            b"0_01_1_1_--_0_00_0" when "0100011", -- sw
            b"1_--_0_0_00_0_10_0" when "0110011", -- R-Type 
            b"0_10_0_0_--_1_01_0" when "1100011", -- beq
            b"1_00_1_0_00_0_10_0" when "0010011", -- I-type ALU
            b"0_00_0_0_00_0_00_0" when "1110011", -- ecall
            b"1_11_-_0_10_0_--_1" when "1101111", -- jal
            b"-_--_-_-_--_-_--_-" when others;    -- non-implemented instruction          
  (c.regwr, c.immsrc, c.alusrc, c.memwr, c.resultsrc, c.branch, c.aluop, c.jump) <= ctrls;
end;
-----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.casts.all;
use work.riscv_pkg.all;

entity aludec is
  port (funct7b5, 
        opcodeb5: in  b1;
        funct3  : in  b3;
        aluop   : in  b2;
        aluctrl : out b3 );
end;
architecture rtl of aludec is
  function match (l, r : std_logic_vector) return boolean is 
    variable flag: boolean; 
    constant len : natural := l'length-1;
  begin
    flag := true; 
    for i in len downto 0 loop 
      if (r(i) /= '-') and (l(len-i) /= r(i)) then
        flag := false; 
      end if; 
    end loop;
    return flag;
  end;
  signal ctrl : b7;
begin
  ctrl    <= aluop & opcodeb5 & funct3 & funct7b5;
  aluctrl <=  "010" when match(ctrl, b"00_-_---_-") else  -- lw/sw
              "110" when match(ctrl, b"01_-_---_-") else  -- beq
              "110" when match(ctrl, b"10_1_000_1") else  -- sub
              "010" when match(ctrl, b"10_-_000_-") else  -- add
              "111" when match(ctrl, b"10_-_010_-") else  -- slt
              "001" when match(ctrl, b"10_-_110_-") else  -- or
              "000" when match(ctrl, b"10_-_111_-") else  -- and
              "---";
end;
-----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.riscv_pkg.all;

entity control is
  port    ( instr : in  b32;
            zero  : in  b1; 
            c     : out ctrlT );
end;
architecture rtl of control is
  signal ctrl      : mctrlT;
  signal funct3    : b3;
  signal op        : b7;
  signal funct7b5  : b1;
  signal alucontrol: b3;  
  signal beq, bne  : b1;                
begin
  funct3   <= instr(14 downto 12);
  op       <= instr( 6 downto  0);
  funct7b5 <= instr(30);
  
  mdec: entity work.maindec port map (op, ctrl);
  adec: entity work.aludec  port map (funct7b5, op(5), funct3, ctrl.aluop, c.aluctrl);

  c.pcsrc <= (ctrl.branch and zero) or ctrl.jump;
  c.m     <= ctrl;
end;
-----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use work.riscv_pkg.all;
use work.casts.all;

entity regfile is
  generic ( Dbg            : boolean := false);
  port    ( clk, reset, we : in  b1; 
            a1, a2, a3     : in  b5;
            wd3            : in  b32;
            rd1, rd2       : out b32 );
end;
architecture rtl of regfile is
  type memT is array(0 to (2**5-1)) of b32;        
  impure function initRam(filename: string) return memT is
    file text_file       : text open read_mode is filename; 
    variable text_line   : line;
    variable ram         : memT;
  begin
    for i in 0 to 2**5-1 loop
      readline(text_file, text_line);
      hread(text_line, ram(i));
    end loop;
    return ram;
  end;    
  signal reg: memT := initRam("regfile.hex");

  procedure PrintD(Debug: in boolean; a3, wd3: in std_logic_vector) is
    variable s  : string(1 to 6);
  begin
    if Debug then
      s := writeln ("x" & str(to_int(a3)) & " = " & hstr(wd3) & " (" & str(to_sint(wd3)) & ")");
    end if;  
  end;     
begin
  process (clk, reset) begin
    if rising_edge(clk) then
      if we = '1' and a3 /= "00000" then
        reg(to_int(a3)) <= wd3;
        PrintD(Dbg,a3,wd3);
      end if;  
    end if;
  end process;
  rd1 <= reg(to_int(a1));
  rd2 <= reg(to_int(a2));
end;
-----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.riscv_pkg.all;
use ieee.numeric_std.all;

entity alu is
  port    ( a, b   : in  b32;
            aluctrl: in  b3;
            result : out b32; 
            zero   : out b1 );
end;
architecture rtl of alu is
  signal condinvB, sum: b32;
begin
  condinvB  <= not B when aluctrl(2)='1' else B;
  sum       <= std_logic_vector(unsigned(A) + unsigned(condinvB) + aluctrl(2));
               with aluctrl(1 downto 0) select
  result    <= A and B                         when "00",
               A or  B                         when "01",
               sum                             when "10",
               (31 downto 1 => '0') & sum(31)  when others;
  zero      <= '1' when result = (31 downto 0 => '0') else '0';
end;
-----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.riscv_pkg.all;

entity extend is
  port    ( i     : in  b32;
            immsrc: in  b2;
            immext: out b32 );
end;
architecture rtl of extend is
begin
         with immsrc select
  immext <= (19 downto 0 => i(31)) & i(31 downto 20)                                 when "00", -- I
            (19 downto 0 => i(31)) & i(31 downto 25)         & i(11 downto  7)       when "01", -- S
            (19 downto 0 => i(31)) & i(7) &  i(30 downto 25) & i(11 downto  8) & '0' when "10", -- B
            (11 downto 0 => i(31)) & i(19 downto 12) & i(20) & i(30 downto 21) & '0' when "11", -- J
            (31 downto 0 => '-') when others;
end;
-----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use std.env.finish;
use work.riscv_pkg.all;
use work.casts.all;

entity ecall is
  port  ( clk   ,
          reset ,
          we    : in b1;
          opc   : in b7;
          addr  : in b5;
          pc    ,
          data  : in b32);
end;
architecture rtl of ecall is
  signal a0, a7  : b32;
  signal mnemonic: string(1 to 6);
begin  
  a0  <= (others => '0') when reset = '1' else
         data            when rising_edge(clk) and addr = "01010" and we = '1';  
  a7  <= (others => '0') when reset = '1' else
         data            when rising_edge(clk) and addr = "10001" and we = '1';    
         
  process (clk)
  begin
    if rising_edge(clk) then
      if opc = "1110011" then       -- opc = ecall
        if    a7 = x"00000001" then -- ID = 1: print integer
              mnemonic <= writeln (hstr(pc) & ": " & "ecall print_int: " & str(to_int(a0)));
        elsif a7 = x"0000000A" then -- ID = 10 
              mnemonic <= writeln (hstr(pc) & ": " & "ecall exit!      "); finish;
        elsif a7 = x"0000000B" then -- ID = 11 
              mnemonic <= writeln (hstr(pc) & ": " & "ecall print_chr: " & to_chr(a0));  
        elsif a7 = x"00000022" then -- ID = 34 
              mnemonic <= writeln (hstr(pc) & ": " & "ecall print_hex: " & "0x" & hstr(a0)); 
        elsif a7 = x"00000023" then -- ID = 35 
              mnemonic <= writeln (hstr(pc) & ": " & "ecall print_bin: " & str(a0));  
        elsif a7 = x"0000005d" then -- ID = 93 
          if a0 = x"00000000" then
              mnemonic <= writeln (hstr(pc) & ": " & "program passed! (0)");
          elsif a0 = x"0000002a" then
              mnemonic <= writeln (hstr(pc) & ": " & "program failed! (42)"); 
          else 
              mnemonic <= writeln ("not implemented syscall!"); 
          end if;  
          finish;  
        end if; 
      end if;  
    end if;  
  end process;     
end;         
-----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.riscv_pkg.all;
use ieee.numeric_std.all;

entity datapath is
  generic ( Debug : boolean := false);
  port    ( clk       ,  
            reset     : in  b1;
            instr     : in  b32;
            c         : in  ctrlT;
            rddata    : in  b32;
            zero      : out b1;
            pc        ,
            aluresult ,
            wrdata    : out b32;
            immexto   : out b32 );
end;           
architecture rtl of datapath is
  signal  pcnext    , 
          pcplus4   , 
          pctarget  ,
          immext    ,
          srca      , 
          srcb      ,
          result    : b32; 
  alias   a1        : b5 is instr(19 downto 15);    
  alias   a2        : b5 is instr(24 downto 20); 
  alias   a3        : b5 is instr(11 downto  7);
begin
  pc        <= (others => '0') when reset = '1' else
               pcnext          when rising_edge(clk);               
  pcplus4   <= std_logic_vector(signed(pc) + 4);                
  pctarget  <= std_logic_vector(signed(pc) + signed(immext));     
  pcnext    <= pcplus4   when c.pcsrc  = '0' else                 
               pctarget; 

  ec  : entity work.ecall   port    map (clk, reset, c.m.regwr, instr(6 downto 0), a3, pc, result); 
  rf  : entity work.regfile generic map (Debug) 
                            port    map (clk, reset, c.m.regwr, a1, a2, a3, result, srca, wrdata); 
  ext : entity work.extend  port    map (instr, c.m.immsrc, immext);                
  srcb      <= wrdata    when c.m.alusrc = '0' else                 
               immext;
  alui: entity work.alu     port    map (srca, srcb, c.aluctrl, aluresult, zero);  
  result    <= aluresult when c.m.resultsrc = "00" else                         
               rddata    when c.m.resultsrc = "01" else
               pcplus4   when c.m.resultsrc = "10" else 
               (others => '-');

  immexto   <= immext;             
end;
-----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.riscv_pkg.all;
use work.casts.all;

entity disasm is
  generic ( Disassemble  : boolean := false);
  port    ( clk    : in b1;
            pc     : in b32;
            instr  : in b32;
            immext : in b32 );
end;  
architecture rtl of disasm is
  alias  opcode    : b7 is instr( 6 downto  0);
  alias  funct3    : b3 is instr(14 downto 12);
  signal funct7b5  : b1; 
  signal a1, a2, a3: b5;
  signal ins       : string(1 to 6);

  function reg(x: std_logic_vector) return string is
  begin
    return " x" & str(to_int(x)) & " ";
  end;  

  function imm(immediate: std_logic_vector) return string is
  begin
    return str(to_sint(immediate));
  end; 

  function offset(immediate: std_logic_vector) return string is
  begin
    return "0x" & hstr(immediate);
  end;  

  function rtype(mnemonic: string; a3, a1, a2: std_logic_vector) return string is
  begin
    return mnemonic & reg(a3) & reg(a1) & reg(a2);
  end;    

  function itype(mnemonic: string; a3, a1, immext: std_logic_vector) return string is
  begin
    return mnemonic & reg(a3) & reg(a1) & imm(immext);
  end; 

  function btype(mnemonic: string; a3, a1, immext: std_logic_vector) return string is
  begin
    return mnemonic & reg(a3) & reg(a1) & offset(immext);
  end; 

  function stype(mnemonic: string; a2, immext, a1: std_logic_vector) return string is
  begin
    return mnemonic & reg(a2) & imm(immext) & "(" & reg(a1) & ")";
  end;

begin 
  a1        <= instr(19 downto 15);
  a2        <= instr(24 downto 20);
  a3        <= instr(11 downto  7);
  funct7b5  <= instr(30);
  process(clk)
  begin 
    if falling_edge(clk) and Disassemble then 
      if opcode = "1101111" then
        ins <= writeln (hstr(pc) & ": " & itype("jal   ", a3, a1, immext));
      else  
        case opcode & funct3 is 
          when b"0110011_000" =>  if funct7b5 = '0' then 
                                    ins <= writeln (hstr(pc) & ": " & rtype("add   ", a3, a1, a2));   
                                  else   
                                    ins <= writeln (hstr(pc) & ": " & rtype("sub   ", a3, a1, a2));   
                                  end if;   
          when b"0110011_111" =>  ins <= writeln (hstr(pc) & ": " & rtype("and   ", a3, a1, a2));     
          when b"0110011_110" =>  ins <= writeln (hstr(pc) & ": " & rtype("or    ", a3, a1, a2));     
          when b"0110011_010" =>  ins <= writeln (hstr(pc) & ": " & rtype("slt   ", a3, a1, a2));     
          when b"0010011_000" =>  ins <= writeln (hstr(pc) & ": " & itype("addi  ", a3, a1, immext)); 
          when b"0010011_111" =>  ins <= writeln (hstr(pc) & ": " & itype("andi  ", a3, a1, immext)); 
          when b"0010011_110" =>  ins <= writeln (hstr(pc) & ": " & itype("ori   ", a3, a1, immext)); 
          when b"0010011_010" =>  ins <= writeln (hstr(pc) & ": " & itype("slti  ", a3, a1, immext)); 
          when b"1100011_000" =>  ins <= writeln (hstr(pc) & ": " & btype("beq   ", a1, a2, immext)); 
          when b"1100011_001" =>  ins <= writeln (hstr(pc) & ": " & btype("bne   ", a1, a2, immext)); 
          when b"0000011_010" =>  ins <= writeln (hstr(pc) & ": " & stype("lw    ", a3, immext, a1)); 
          when b"0100011_010" =>  ins <= writeln (hstr(pc) & ": " & stype("sw    ", a2, immext, a1));
          when b"1110011_000" =>  ins <= writeln (hstr(pc) & ": " & "ecall                        ");  
          when others         =>  ins <= writeln (hstr(pc) & ": " & "undefined instr @: "             
                                                                       & " Opc: " & str (opcode) 
                                                                       & " F3 : " & str (funct3));     
        end case;
      end if; 
    end if;
  end process;
end;
-----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.riscv_pkg.all;

entity cpu is
  generic ( Debug : boolean := false; Disassemble : boolean := false);
  port    ( clk        , 
            reset      : in  b1;
            instr      , 
            rddata     : in  b32;
            pc         , 
            aluresult  , 
            wrdata     : out b32;
            memwr      : out b1 );
end;
architecture rtl of cpu is
  signal ctrl  : ctrlT;
  signal zero  : b1;
  signal immext: b32;
begin
  dpu : entity work.datapath generic map (Debug)  
                             port    map (clk, reset, instr, ctrl, rddata, zero, 
                                          pc, aluresult, wrdata, immext);
  ctl : entity work.control  port    map (instr, zero, ctrl);
  dasm: entity work.disasm   generic map (Disassemble) port map (clk, pc, instr, immext);
  memwr <= ctrl.m.memwr;
end;
-----------------------------------------------------------------------------------------
library IEEE; 
use IEEE.std_logic_1164.all;
use std.textio.all; 
use work.casts.all;
use work.riscv_pkg.all;

entity memory is 
  generic ( InitFile : string  := "init.mem";
            M        : integer := 10;   -- 2^M Addresses
            Debug    : boolean := false);  
  port    ( clk, we  : in  b1;
            a        : in  std_logic_vector(M-1 downto 0);
            wd       : in  b32;
            rd       : out b32
          );
end;
architecture synth of memory is

  type memT is array(0 to (2**M-1)) of b32;
       
  impure function initRam(filename: string) return memT is
    file text_file       : text open read_mode is filename; 
    variable text_line   : line;
    variable ram         : memT;
  begin
    for i in 0 to 2**M-1 loop
      readline(text_file, text_line);
      hread(text_line, ram(i));
    end loop;
    return ram;
  end;    
       
  signal mem: memT := initRam(InitFile);
  

  procedure PrintD(Debug: in boolean; a, wd: in std_logic_vector) is
    variable s  : string(1 to 6);
  begin
    if Debug then
      s := writeln ( "dmem(" & str(to_int(a)*4) & ") = " & hstr(wd) & " (" & str(to_sint(wd)) & ")");
    end if;  
  end;   

begin 

  process (clk)
  begin
    if rising_edge(clk) then
      if We = '1' then
        mem(to_int(a)) <= wd; 
        PRINTD(Debug,a,wd);
      end if;
    end if;  
  end process;

  rd <= mem(to_int(a));

end;  
-----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.riscv_pkg.all;

entity top is
  generic ( MI            : natural := 8;  -- depth of instruction memory (2^8 words)
            MD            : natural := 8;  -- depth of data memory
            imemfile      : string  := "imem.hex";
            dmemfile      : string  := "dmem.hex");
  port    ( clk, reset    : in  b1;
            memwr         : out b1;
            wrdata, daddr : out b32);
end;
architecture rtl of top is
  signal pc, wrinstr, instr, rddata : b32 := (others => '0');
begin  
  wrinstr <= (others => '0');
  cpu  : entity work.cpu    generic map (Debug => false, Disassemble => true)
                            port    map (clk, reset, instr, rddata, pc, daddr, wrdata, memwr);
  imem : entity work.memory generic map (imemfile, MI)
                            port    map (clk, '0'  , pc   (MI+1 downto 2), wrinstr, instr);
  dmem : entity work.memory generic map (dmemfile, MD, Debug => false)
                            port    map (clk, memwr, daddr(MI+1 downto 2), wrdata , rddata);
end;
-----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.riscv_pkg.all;
use work.casts.all;
entity top_tb is
  generic ( MI            : natural := 8;  -- depth of instruction memory (2^8 words)
            MD            : natural := 8;  -- depth of data memory
            imemfile : string  := "imem.hex";
            dmemfile : string  := "dmem.hex");
end;
architecture rtl of top_tb is

  signal clk, reset, memwr: b1 := '0';
  signal wrdata           : b32;
  signal daddr            : b32;

begin

  dut: entity work.top    generic map (MI => MI, MD => MD, imemfile => imemfile, dmemfile => dmemfile)
                          port    map (clk, reset, memwr, wrdata, daddr);

  reset <= '1', '0' after 22 ns;
  clk   <= not clk  after  5 ns; 
  
end;

-- How to use:

------------------------------------------------------------------
-- Assemble riscvtest.s with rars RISCV-Assembler-Simulator  : 
------------------------------------------------------------------
--    assemble.py riscvtest 256          (for instruction memory)
--    assemble.py riscvtest 1024 --data  (for data memory)

--    256 = memory size

------------------------------------------------------------------
-- Run riscvtest.s assembly with rars RISCV-Assembler-Simulator  : 
------------------------------------------------------------------

--    execute.py riscvtest

------------------------------------------------------------------
-- Simulate VHDL model with assembly program riscvtest.hex        
------------------------------------------------------------------

--    simulate.py top_tb -p imemfile=riscvtest_imem.hex,dmemfile=riscvtest_dmem.hex

------------------------------------------------------------------
-- Synthesize VHDL model of RISCV CPU        
------------------------------------------------------------------

-- synthesize.py b cpu    or 
-- synthesize.py s cpu



