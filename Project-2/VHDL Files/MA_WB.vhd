library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity MA_WB is
	generic( control_length : integer := 3);
	port(	CS4_in: in std_logic_vector(control_length-1 downto 0);           --control signals
		A3_in: in std_logic_vector(2 downto 0);
		RFD_in: in std_logic_vector(15 downto 0);   --register file input data register
		----------------------------------------
		CS4_out: out std_logic_vector(control_length-1 downto 0);          
		A3_out: out std_logic_vector(2 downto 0);
		RFD_out: out std_logic_vector(15 downto 0);
		----------------------------------------
		clk,flush,enable,flush_prev : in std_logic;
		flush_out : out std_logic);
end entity;

architecture five of MA_WB is
	signal flush_in : std_logic;
begin
		flush_in <= flush_prev or flush;    --flush from previous pipe
		CS4_REG: dregister
			generic map(control_length)
			port map(reset => flush_in, din => CS4_in, dout => CS4_out, enable => enable, clk => clk);
		A3_REG: dregister
			generic map(3)
			port map(reset => flush_in, din => A3_in, dout => A3_out, enable => enable, clk => clk);
		RFD_REG: dregister
			generic map(16)
			port map(reset => flush_in, din => RFD_in, dout => RFD_out, enable => enable, clk => clk);
		flush_reg: dflipflop
			port map(reset => '0', din => flush, dout => flush_out, enable => enable, clk => clk);

end architecture;
