library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity PE_decoder is
	port(
		input : in std_logic_vector(2 downto 0);
		output : out std_logic_vector(7 downto 0)
	);
end PE_decoder;

architecture behave of PE_decoder is
	signal num : integer;
begin
	num <= to_integer(unsigned(input));
	loopy: for i in 0 to 7 generate
		output(i) <= '0' when i = num else
			     '1';
	       end generate;
end behave;
	
