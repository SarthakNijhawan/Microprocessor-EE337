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
	signal imemory :imem := (	0 => "0100000001011110", 1 => "0110000000011111",
									2 => "0000000001101000", 3 => "0000010101101000", 
									4 => "0000011101101000", 5 => "0000100101101000", 
									6 => "0101101110001111", 7 => "0101101110010000", 
									8 => "0101101110010001", 9 => "0101101110010010", 
									10 => "0101101110010011", 11 => "1000110000000000",
									30 => "0000000000011111" ,31 => "0000000000000001", 
									32 => "0000000000000010", 33 => "0000000000000011", 
									34 => "0000000000000100", 35 => "0000000000000101",
									others => (others => '0'));
	signal addr : integer range 0 to 65535;
begin
	addr <= to_integer(unsigned(imem_a));
	imem_out <= imemory(addr) when rd_imem = '1' else x"0000";
end behave;
	
