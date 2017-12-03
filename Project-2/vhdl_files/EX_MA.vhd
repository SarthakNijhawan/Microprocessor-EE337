library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity EX_MA is
	generic( control_length : integer := 3);
	port(	IR_in: in std_logic_vector(15 downto 0);
			PC_in: in std_logic_vector(15 downto 0);
			CS3_in: in std_logic_vector(control_length-1 downto 0);           --control signals
			A3_in: in std_logic_vector(2 downto 0);
			CZ_in: in std_logic_vector(1 downto 0);   --updated by alu
			AO_in: in std_logic_vector(15 downto 0);   --alu out
			DR_in: in std_logic_vector(15 downto 0);    --forwarding D1 to mem_d in store type instruc.
			----------------------------------------
			IR_out: out std_logic_vector(15 downto 0);
			PC_out: out std_logic_vector(15 downto 0);
			CS3_out: out std_logic_vector(control_length-1 downto 0);          
			A3_out: out std_logic_vector(2 downto 0);
			CZ_out: out std_logic_vector(1 downto 0);
			AO_out: out std_logic_vector(15 downto 0);
			DR_out: out std_logic_vector(15 downto 0);
			----------------------------------------
			clk, flush, enable, flush_prev, lm_sm_bit_in : in std_logic;
			flush_out, lm_sm_bit_out : out std_logic);
end entity;

architecture four of EX_MA is
	signal flush_in : std_logic;
begin
		flush_in <= flush_prev or flush;    --flush from previous pipe

		IR_REG: dregister
			generic map(16)
			port map(reset => flush_in, din => IR_in, dout => IR_out, enable => enable, clk => clk);
		PC_REG: dregister
			generic map(16)
			port map(reset => flush_in, din => PC_in, dout => PC_out, enable => enable, clk => clk);
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
		DR_REG: dregister
			generic map(16)
			port map(reset => flush_in, din => DR_in, dout => DR_out, enable => enable, clk => clk);
		flush_reg: dflipflop
			port map(reset => '0', din => flush_in, dout => flush_out, enable => '1', clk => clk);--enable is always 1
		lm_sm_reg: dflipflop
			port map(reset => flush_in, din => lm_sm_bit_in, dout => lm_sm_bit_out, enable => enable, clk => clk);--enable is always 1

end architecture;
