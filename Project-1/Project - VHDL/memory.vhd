library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
   port ( mem_a, mem_d 		: in std_logic_vector(15 downto 0);
			 mem_out				: out std_logic_vector(15 downto 0);
			 clk, wr_mem, rd_mem: in std_logic);
end entity;

architecture behave of memory is

	type mem is array (0 to 15) of std_logic_vector(15 downto 0);
	signal memory :mem := (0 => "1100000001000010", 1 => "1000110111111111", 2 => x"AAAA", others => (others => '0'));
	signal addr: integer range 0 to 15;
	
	begin
	
	addr <= to_integer(unsigned(mem_a(3 downto 0)));
	
	process (clk)
	begin	
		if( clk'event and clk = '1') then
			if (wr_mem = '1') then
				memory(addr)<= mem_d;
			end if;
		end if;
	end process;
	
	mem_out <= memory(addr) when rd_mem = '1' else x"0000";
end architecture behave;
