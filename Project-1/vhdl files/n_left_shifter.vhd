library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity 7_left_shifter is
	generic(input_width: integer := 9;
		output_width: integer := 16);
	port(
		input: in std_logic_vector(input_width-1 downto 0);
		output: out std_logic_vector(output_width-1 downto 0));
end entity;

architecture shift of n_left_shifter is
begin
	output(output_width-1 downto 7) <= input;
	output(6 downto 0) <= "0000000";

end architecture;
