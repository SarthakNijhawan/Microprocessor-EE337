library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_1 is
port(
	input: in std_logic_vector(15 downto 0);
	output: out std_logic_vector(15 downto 0)
	);
end entity;

architecture behave of add_1 is
begin
	output <= std_logic_vector(unsigned(input)+1);
end behave;
