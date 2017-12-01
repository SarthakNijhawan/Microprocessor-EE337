library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity d_memory is
	generic(num_words: integer := 256);
	port(
		dmem_d: in std_logic_vector(15 downto 0);
		dmem_a: in std_logic_vector(15 downto 0);
		dmem_out: out std_logic_vector(15 downto 0);
		wr_dmem,clk : in std_logic);
end entity;

architecture behave of d_memory is
	type dmem is array (0 to num_words-1) of std_logic_vector(15 downto 0);
	signal dmemory : dmem := (others => (others => '0'));
	signal addr : integer range 0 to 65535;
begin
	addr <= to_integer(unsigned(dmem_a));

	process (clk)
	begin	
		if( clk'event and clk = '1') then
			if (wr_dmem = '1') then
				dmemory(addr)<= dmem_d;
			end if;
		end if;
	end process;

	dmem_out <= dmemory(addr) when wr_dmem = '0' else x"0000";
end behave;
	
