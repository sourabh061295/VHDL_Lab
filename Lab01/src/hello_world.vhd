use std.textio.all;    --  Imports the standard textio package

entity hello_world is  --  Defines a design entity, without any ports
end;

architecture behaviour of hello_world is
begin
  process
      variable l : line;
  begin
      write (l, String'("Hello world!"));
      writeline (output, l);
      wait;
  end process;
end;