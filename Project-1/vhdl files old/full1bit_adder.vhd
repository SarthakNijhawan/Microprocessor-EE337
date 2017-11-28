library ieee;
use ieee.std_logic_1164.all;

entity full1bit_adder is
	port (cin, x, y   :in std_logic;
	      sum, cout   :out std_logic
	);
end full1bit_adder;

architecture adder of full1bit_adder is
begin

sum <=  x xor y xor cin;

cout <= (x and y) or (cin and x) or (cin and y);

end adder;
