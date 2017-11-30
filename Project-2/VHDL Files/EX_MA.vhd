library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity EX_MA is
	generic( control_length : integer := 3);
	port(	CS3_in: in std_logic_vector(control_length-1 downto 0);           --control signals
		A3_in: in std_logic_vector(2 downto 0);
		CZ_in: in std_logic_vector(1 downto 0);   --updated by alu
		AO_in: in std_logic_vector(15 downto 0);   --alu out
		SH7_in: in std_logic_vector(15 downto 0);
		DR_in: in std_logic_vector(15 downto 0);    --forwarding D1 to mem_d in store type instruc.
		----------------------------------------
		CS3_out: out std_logic_vector(control_length-1 downto 0);          
		A3_out: out std_logic_vector(2 downto 0);
		CZ_out: out std_logic_vector(1 downto 0);
		AO_out: out std_logic_vector(15 downto 0);
		SH7_out: out std_logic_vector(15 downto 0);
		DR_out: out std_logic_vector(15 downto 0);
		----------------------------------------
		clk,flush,enable,flush_prev : in std_logic;
		flush_out : out std_logic);
end entity;

architecture four of EX_MA is
	signal flush_in : std_logic;
begin
		flush_in <= flush_prev or flush;    --flush from previous pipe
		CS3_REG: dregister
			generic map(control_length)
			port map(reset => flush_in, din => CS3_in, dout => CS3_out, enable => enable, clk => clk);
		A3_REG: dregister
			generic map(3)
			port map(reset => flush_in, din => A3_in, dout => A3_out, enable => enable, clk => clk);
		CZ_REG: dregister
			generic map(2)
			port map(reset => flush_in, din => CZ_in, dout => CZ_out, enable => enable, clk => clk);
		AO_REG: dregister
			generic map(16)
			port map(reset => flush_in, din => AO_in, dout => AO_out, enable => enable, clk => clk);
		SH7_REG: dregister
			generic map(16)
			port map(reset => flush_in, din => SH7_in, dout => SH7_out, enable => enable, clk => clk);
		DR_REG: dregister
			generic map(16)
			port map(reset => flush_in, din => DR_in, dout => DR_out, enable => enable, clk => clk);
		flush_reg: dflipflop
			port map(reset => '0', din => flush, dout => flush_out, enable => enable, clk => clk);

end architecture;
