library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity comp2 is
  port(d1_in,d2_in : in std_logic_vector(15 downto 0);
       comp2 : out std_logic
      );
end comp2;

architecture behave of comp2 is
  begin
    process(d1_in,d2_in)
	  begin
      if(d1_in = d2_in) then
        comp2 <= '1';
      else
        comp2 <= '0';
      end if;
    end process;
end behave;
