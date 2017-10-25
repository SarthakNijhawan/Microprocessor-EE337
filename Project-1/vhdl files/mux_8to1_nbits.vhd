library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux8 is
	generic(input_width: integer := 16);
	port(
		inp1, inp2, inp3, inp4, inp5, inp6, inp7, inp8: in std_logic_vector(input_width-1 downto 0) := (others => '0');
		sel: in std_logic_vector(2 downto 0);
		output: out std_logic_vector(input_width-1 downto 0));
end entity;

architecture behave of mux8 is
begin
	output <= inp1 when (sel = "000") else
		inp2 when (sel = "001") else
		inp3 when (sel = "010") else
		inp4 when (sel = "011") else
		inp5 when (sel = "100") else
		inp6 when (sel = "101") else
		inp7 when (sel = "110") else
		inp8;
end;
