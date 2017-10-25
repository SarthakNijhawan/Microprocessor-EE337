library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_4to1 is
	generic ( nbits : integer);  	                                        
	port(
		s0, s1 : in std_logic;
		input0, input1, input2, input3 : in std_logic_vector(nbits-1 downto 0);	        
		output : out std_logic_vector(nbits-1 downto 0));	                
end entity;

architecture behave of mux_4to1 is

begin

	   gen: for I in 0 to nbits-1 generate
				output(I) <= (
					      (s0 and s1 and input3(I)) or
					      ((not s0) and s1 and input2(I)) or 
					      (s0 and (not s1) and input1(I)) or 
					      ((not s0) and (not s1) and input0(I))
					     );
		end generate;

end behave;
