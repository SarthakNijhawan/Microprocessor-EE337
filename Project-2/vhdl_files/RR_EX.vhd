library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity RR_EX is
	generic( control_length : integer := 3);
	port(	PC_in: in std_logic_vector(15 downto 0);
		CS2_in: in std_logic_vector(control_length-1 downto 0);           --control signals
		A3_in: in std_logic_vector(2 downto 0);
		D1_in: in std_logic_vector(15 downto 0);
		D2_in: in std_logic_vector(15 downto 0);
		SE6_in: in std_logic_vector(15 downto 0);
		SH7_in: in std_logic_vector(15 downto 0);
		OP2_in: in std_logic_vector(2 downto 0);	--from LM/SM block
		----------------------------------------
		PC_out: out std_logic_vector(15 downto 0);
		CS2_out: out std_logic_vector(control_length-1 downto 0);          
		A3_out: out std_logic_vector(2 downto 0);
		D1_out: out std_logic_vector(15 downto 0);
		D2_out: out std_logic_vector(15 downto 0);
		SE6_out: out std_logic_vector(15 downto 0);
		SH7_out: out std_logic_vector(15 downto 0);
		OP2_out: out std_logic_vector(2 downto 0);
		----------------------------------------
		clk,flush,enable,flush_prev : in std_logic;
		flush_out : out std_logic);
end entity;

architecture three of RR_EX is
	signal flush_in : std_logic;
begin
		flush_in <= flush_prev or flush;    --flush from previous pipe
		PC_REG: dregister
			generic map(16)
			port map(reset => flush_in, din => PC_in, dout => PC_out, enable => enable, clk => clk);
		CS2_REG: dregister
			generic map(control_length)
			port map(reset => flush_in, din => CS2_in, dout => CS2_out, enable => enable, clk => clk);
		A3_REG: dregister
			generic map(3)
			port map(reset => flush_in, din => A3_in, dout => A3_out, enable => enable, clk => clk);
		D1_REG: dregister
			generic map(16)
			port map(reset => flush_in, din => D1_in, dout => D1_out, enable => enable, clk => clk);
		D2_REG: dregister
			generic map(16)
			port map(reset => flush_in, din => D2_in, dout => D2_out, enable => enable, clk => clk);
		SE6_REG: dregister
			generic map(16)
			port map(reset => flush_in, din => SE6_in, dout => SE6_out, enable => enable, clk => clk);
		SH7_REG: dregister
			generic map(16)
			port map(reset => flush_in, din => SH7_in, dout => SH7_out, enable => enable, clk => clk);
		OP2_REG: dregister
			generic map(3)
			port map(reset => flush_in, din => OP2_in, dout => OP2_out, enable => enable, clk => clk);
		flush_reg: dflipflop
			port map(reset => '0', din => flush_in, dout => flush_out, enable => '1', clk => clk);--enable is always 1

end architecture;
