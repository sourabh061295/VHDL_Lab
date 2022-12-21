library IEEE; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.types.all;
use work.functions.all;
use work.records.all;
use work.casts.all;

entity alu is
  generic ( N: integer := 32);
  port    ( a, b      : in  std_logic_vector(N-1 downto 0);  -- input operands a and b
            ci        : in  std_logic;                       -- carry-input
            ctrl      : in  std_logic_vector(  1 downto 0);  -- control word selects operation (+|-|^|v)
            result    : out std_logic_vector(N-1 downto 0);  -- output result 
            flags     : buffer flagType                      -- output flags (Z, N, V, C, LT, LE, GT, GE)
          );
end;

architecture rtl of alu is
  constant zero : std_logic_vector(N-1 downto 0) := (others => '0'); -- defining a constant  zero
  signal   bi   : std_logic_vector(N-1 downto 0) := (others => '0'); -- internal b operand
  signal   sum  : std_logic_vector(N   downto 0);                    -- sum output signal from adder

  

begin

  add_inst: entity work.add generic map (N)    -- adder instantiation
                            port    map (a, bi, (ci xor ctrl(0)), sum(N-1 downto 0), sum(N));
  
  process(all)
  begin
     
    bi       <= b xor not(zero)  when (ctrl = "01") else 
                b;                -- internal b operand, depends on operation
    
    result   <= sum(N-1 downto 0) when (ctrl = "00" or ctrl = "01") else  -- result output of the alu
                a and bi when (ctrl = "10") else
                a or bi;
    -- Flags
    flags.z  <= '1' when (result = zero) else '0';
    flags.c  <= sum(N) when (ctrl ="00" or ctrl = "01") else
                '0';
    flags.n  <= result(N-1);
    flags.v  <= ((a(N-1) xnor b(N-1)) and (a(N-1) xor sum(N-1))) when (ctrl = "00") else
                ((a(N-1) xor b(N-1)) and (a(N-1) xor sum(N-1))) when (ctrl = "01") else
                '0';
    flags.lt <= (flags.v) xor (flags.n);
    flags.le <= (flags.lt) or (flags.z);
    flags.gt <= not(flags.le);
    flags.ge <= (flags.v) xnor (flags.n);
  end process;

end;

--     5  = 0101      5  = 00101    (-5) = 01011    (-5) = 1011      3  = 0011     (-6) = 01010 
-- - (-3) = 0011    - 3  = 01101   -  3  = 01101  - (-3) = 0011  - (-5) = 0101    -  3  = 01101 
--     c    1110      c  = 11010      c  = 11110      c  = 0110      c  = 1110       c  = 10000 
-- -------------    ------------   -------------  -------------  -------------    ------------- 
--     8  = 1000      2  = 10010     -8  = 11000     -2  = 1110      8  = 1000      -9  = 10111 
--  ZNVC  = 0110    ZNVC =  0001    ZNVC =  0101    ZNVC = 0100    ZNVC = 0110     ZNVC =  0011



