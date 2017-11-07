library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
library work;
use work.basic.all;

entity instruction_register is
     port(
	    din     : in std_logic_vector(15 downto 0);
	    din_low : in std_logic_vector(7 downto 0);
            en_ir   : in std_logic;
            en_ir_low : in std_logic;
            clk,reset : in std_logic;
	    dout: out std_logic_vector(15 downto 0) 	
	 );
end instruction_register;

architecture behavior of instruction_register is
	signal mux_low_out : std_logic_vector(7 downto 0);
	signal en_low : std_logic;
begin
	en_low <= en_ir or en_ir_low;
	mux_low: mux_2to1_nbits
		generic map(8)
		port map(s0 => en_ir, input0 => din_low, input1 => din(7 downto 0), output => mux_low_out);
	reg_high: dregister
		generic map(8)
		port map(reset => reset, din => din(15 downto 8), dout => dout(15 downto 8), enable => en_ir, clk => clk);
	reg_low: dregister
		generic map(8)
		port map(reset => reset, din => mux_low_out, dout => dout(7 downto 0), enable => en_low , clk => clk);
end behavior;
	
