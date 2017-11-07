library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nor_box is
	generic(input_width: integer := 16);
	port(
		input: in std_logic_vector(input_width-1 downto 0);
		output: out std_logic);
end entity;

architecture norer of nor_box is
	signal temp: std_logic_vector(input_width-1 downto 0);
begin
	temp(0) <= input(0);
	anding:
	for i in 1 to input_width-1 generate
		temp(i) <= temp(i-1) or input(i);
	end generate;

	output <= not temp(input_width-1);
	
end architecture;

