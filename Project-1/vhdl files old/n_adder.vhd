library ieee;
use ieee.std_logic_1164.all;

--------generic n bit adder without cin and cout 
-----------------------------------------------------------entity declaration----------------------------------
entity n_adder is
generic (n_bits : positive range 2 to positive'right := 16);--------n_bits starting from 2 -------------

port(op1,op2 : in std_logic_vector(n_bits-1 downto 0);
		sum    : out std_logic_vector(n_bits-1 downto 0);
		cz : out std_logic
);

end n_adder;
---------------------------------------------------------architecture declaration of n adder----------------------------------
architecture component_placing of n_adder is

component full1bit_adder is		----------------------full 1 bit adder as a component-----------------------------------
port (cin, x, y   :in std_logic;
	      sum, cout :out std_logic
	);
end component;
signal t: std_logic_vector(n_bits downto 0);

begin
t(0)<='0';
LOOPIN: for i in 0 to n_bits-1 generate			----------using generate to loop----------------
		 loopi :full1bit_adder port map(t(i), op1(i), op2(i), sum(i), t(i+1));
		 end generate;
cz<=t(n_bits);
end component_placing;