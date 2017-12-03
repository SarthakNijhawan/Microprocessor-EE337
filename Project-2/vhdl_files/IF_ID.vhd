library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity IF_ID is
	port(	PC_in: in std_logic_vector(15 downto 0);      --PC+1
			nPC_in: in std_logic_vector(15 downto 0);
			IR_in: in std_logic_vector(15 downto 0);
			----------------------------------------
			PC_out: out std_logic_vector(15 downto 0);
			nPC_out: out std_logic_vector(15 downto 0);
			IR_out: out std_logic_vector(15 downto 0);
			----------------------------------------
			clk,flush,enable : in std_logic;
			flush_out : out std_logic);
end entity;

architecture one of IF_ID is
begin

		PC_REG: dregister
					generic map(16)
					port map(reset => flush, din => PC_in, dout => PC_out, enable => enable, clk => clk);
		nPC_REG: dregister
					generic map(16)
					port map(reset => flush, din => nPC_in, dout => nPC_out, enable => enable, clk => clk);
		IR_REG: dregister
					generic map(16)
					port map(reset => flush, din => IR_in, dout => IR_out, enable => enable, clk => clk);
		flush_reg: dflipflop
					port map(reset => '0', din => flush, dout => flush_out, enable => '1', clk => clk);--enable is always1

end architecture;
		
		
