library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity decoder is
	port(
		IR : in std_logic_vector(15 downto 0);
		lm_sm_start : in std_logic;
		lm_detected
		);
end entity;

architecture behave of decoder is
	signal RA,RB,RC : std_logic_vector(2 downto 0);
	signal op_code : std_logic_vector(3 downto 0);
begin
	op_code <= IR(15 downto 12);
	RA <= IR(11 downto 9);
	RB <= IR(8 downto 6);
	RC <= IR(5 downto 3);

	main: process(IR)
	begin
		case op_code is
			when "0000" => 
			when "0001" => 
			when "0010" => 
			when "0011" => 
			when "0000" => 
			when "0000" => 
			when "0000" => 
			when "0000" => 
			when "0000" => 
			when "0000" => 
			when "0000" => 
			when "0000" =>
			when others =>
		end case;
	end process;
end architecture; 
