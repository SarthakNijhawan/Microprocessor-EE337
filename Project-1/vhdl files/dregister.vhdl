library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dregister is
  generic (
    nbits : integer:=16);                    -- no. of bits
  port (
    reset: in std_logic;
    din  : in  std_logic_vector(nbits-1 downto 0);
    dout : out std_logic_vector(nbits-1 downto 0);
    enable: in std_logic;
    clk     : in  std_logic);
end dregister;

architecture behave of dregister is

begin  -- behave
process(clk,reset)
begin 
if(reset = '0') then
  if(clk'event and clk = '1') then
    if enable = '1' then
      dout <= din;
    end if;
  end if;

else dout <= (others => '0');
end if;

end process;
end behave;
