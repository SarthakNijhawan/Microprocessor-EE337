library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-----------------------------------------------------no use of entity in a testbench-------------------------------
entity tb_n_adder is
end tb_n_adder;

architecture testbench of tb_n_adder is
-----------------------------------------------------------Add DUT COMPONENT-------------------------------------
component n_adder is
generic (n_bits : positive range 2 to positive'right := 16);--------n_bits starting from 2 -------------

port(op1,op2 : in std_logic_vector(n_bits-1 downto 0);
		sum    : out std_logic_vector(n_bits-1 downto 0);
		cz : out std_logic
);

end component;
-----------------------------------------------------create constant for every generic item in DUT-------------------------
constant n_bits: positive range 2 to positive'right :=16;

-----------------------------------------------------create signals for every port item in DUT-------------------------

signal op1,op2,sum: std_logic_vector(n_bits-1 downto 0);
signal cz:std_logic;

begin
------------------------------------------------------instantiate DUT----------------------------------------
dut: n_adder generic map (n_bits) port map (op1,op2,sum,cz);

simulation: process
begin 
op1<=std_logic_vector(to_unsigned(90, 16));
op2<=std_logic_vector(to_unsigned(845, 16));
wait for 10 us;
op1<="1000101101011101";
op2<="0111010100101011";
wait for 5 us; 
end process simulation;

end testbench;
