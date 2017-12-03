library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--library work;
--use work.basic.all;

entity nCounter is
	generic (n : integer );
	port(
		rst, clk : in std_logic;
		count : out std_logic_vector(n downto 0)
		);
end nCounter;

architecture behave of nCounter is
	begin
	process (en_either, rst)
	begin
	  if rst = '1' then
	    count <= (others => '0');
	  elsif rising_edge(en_either) then
	    if en_up = '1' then
	      count <= count + 1;
	    else
	      count <= count - 1;
	    end if;
	  end if;
	end process;
end behave;