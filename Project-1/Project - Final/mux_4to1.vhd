library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_4to1 is	                                        
	port(
		s0, s1, input0, input1, input2, input3 : in std_logic;	        
		output : out std_logic);	                
end entity;

architecture behave of mux_4to1 is

begin
	output <= (
		      (s0 and s1 and input3) or
		      ((not s0) and s1 and input2) or 
		      (s0 and (not s1) and input1) or 
		      ((not s0) and (not s1) and input0)
		  );

end behave;
