library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--- Priority encoder.gives highest priority to LSB.
entity PriorityEncoder is
port(  
	input : in std_logic_vector(7 downto 0);
	output : out std_logic_vector(2 downto 0);
	invalid : out std_logic
       );
end PriorityEncoder;

architecture behave of PriorityEncoder is
signal x_bar,x : std_logic_vector(7 downto 0);
signal y : std_logic_vector(2 downto 0);

begin
	loopy: for i in 0 to 7 generate
		x(i) <= input(7-i);
	       end generate;
	x_bar<= not(x);

	invalid <= not (x(0) or x(1) or x(2) or x(3) or x(4) or x(5) or x(6) or x(7));
	y(0) <= x_bar(0) and (x(1) or(x_bar(2) and x(3))or (x_bar(2) and x_bar(4) and x(5)) or (x_bar(2) and x_bar(4) and x_bar(6) and x(7)));
	y(1) <= x_bar(0) and x_bar(1) and (x(2) or x(3) or (x_bar(4) and x_bar(5) and (x(6) or x(7)))); 
	y(2) <= x_bar(0) and x_bar(1) and x_bar(2) and x_bar(3) and (x(4) or x(5) or x(6) or x(7));
	
	output <= not y;
end behave;

