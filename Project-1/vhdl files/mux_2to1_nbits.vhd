library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2to1_nbits is	
	generic ( nbits : integer :=16);                                        
	port(
		s0 : in std_logic;
		input0, input1 : in std_logic_vector(nbits-1 downto 0);	        
		output : out std_logic_vector(nbits-1 downto 0));	                
end entity;

architecture behave of mux_2to1_nbits is

begin

	   gen: for I in 0 to nbits-1 generate
				output(I) <= (s0 and input1(I)) or ((not s0) and input0(I)) ; 
		end generate;

end behave;
