library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dflipflop is
  port (
    reset: in std_logic;
    din  : in  std_logic;
    dout : out std_logic;
    enable: in std_logic;
    clk     : in  std_logic);
end dflipflop;

architecture behave of dflipflop is

begin  -- behave
process(clk,reset,din)
begin
if(reset = '0') then
  if(clk'event and clk = '1') then
    if enable = '1' then
      dout <= din;
    end if;
  end if;

else dout <= '0';
end if;

end process;
end behave;
