library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity comp1 is
  port(mem_out : in std_logic_vector(15 downto 0);
       comp1 : out std_logic
      );
end comp1;

architecture behave of comp1 is
  begin
    process(mem_out)
	  begin
      if(mem_out = "0000000000000000") then
        comp1 <= '1';
      else
        comp1 <= '0';
      end if;
    end process;
end behave;
