library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2to1 is	                                        
	port(
		s, input0, input1 : in std_logic;	        
		output : out std_logic);	                
end entity;

architecture behave of mux_2to1 is

begin
	output <= ((s and input1) or ((not s) and input0));

end behave;
