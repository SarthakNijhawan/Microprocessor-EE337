library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
   port ( mem_a, mem_d 		: in std_logic_vector(15 downto 0);
			 mem_out				: out std_logic_vector(15 downto 0);
			 clk, wr_mem, rd_mem: in std_logic);
end entity;

architecture behave of memory is

	type mem is array (0 to 255) of std_logic_vector(15 downto 0);
	signal memory :mem := (0 => "0100000001001010", 1 => "0100001010001011", 2 => "0100101110001100", 3 => "1000010000000011", 4 => "0000000000000000", 5 => "0000000000000000", 6 => "0000001000100000", 7 => "0110110000010011", 8 => "1000110000000000", 9 => "0000000000000000", 10 => "0000000000000111", 11 => "0000000000001111", 12 => "0000000000001101", 13 => "0000000000000000", 14 => "0000000000000000", 15 => "0000000000000000", others => (others => '0'));
	signal addr: integer range 0 to 255;
	
	begin
	
	addr <= to_integer(unsigned(mem_a(7 downto 0)));
	
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
