library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity i_memory is
	generic(num_words: integer := 256);
	port(
		imem_a: in std_logic_vector(15 downto 0);
		imem_out: out std_logic_vector(15 downto 0);
		rd_imem ,clk : in std_logic);
end entity;

architecture behave of i_memory is
	type imem is array (0 to num_words-1) of std_logic_vector(15 downto 0);
	signal imemory : imem := (others => (others => '0'));
	signal addr : integer range 0 to 65535;
begin
	addr <= to_integer(unsigned(imem_a));
	imem_out <= imemory(addr) when rd_imem = '1' else x"0000";
end behave;
	
