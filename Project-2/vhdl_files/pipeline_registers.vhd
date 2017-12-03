library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pipeline_registers is

	component IF_ID is
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
	end component;

	component ID_RR is
		generic( control_length : integer := 3);
		port(	PC_in: in std_logic_vector(15 downto 0);
			CS1_in: in std_logic_vector(control_length-1 downto 0);           --control signals
			A1_in: in std_logic_vector(2 downto 0);
			A2_in: in std_logic_vector(2 downto 0);
			A3_in: in std_logic_vector(2 downto 0);		--write address in RF(carried till last stage)
			SE6_in: in std_logic_vector(15 downto 0);
			SE9_in: in std_logic_vector(15 downto 0);
			SH7_in: in std_logic_vector(15 downto 0);
			OP2_in: in std_logic_vector(2 downto 0);	--from LM/SM block
			PC_im_in: in std_logic_vector(15 downto 0);	--pc+imm
			----------------------------------------
			PC_out: out std_logic_vector(15 downto 0);
			CS1_out: out std_logic_vector(control_length-1 downto 0);
			A1_out: out std_logic_vector(2 downto 0);
			A2_out: out std_logic_vector(2 downto 0);
			A3_out: out std_logic_vector(2 downto 0);
			SE6_out: out std_logic_vector(15 downto 0);
			SE9_out: out std_logic_vector(15 downto 0);
			SH7_out: out std_logic_vector(15 downto 0);
			OP2_out: out std_logic_vector(2 downto 0);
			PC_im_out: out std_logic_vector(15 downto 0);
			----------------------------------------
			clk,flush,enable,flush_prev : in std_logic;
			flush_out : out std_logic);
	end component;

	component RR_EX is
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
	end component;

	component EX_MA is
		generic( control_length : integer := 3);
		port(	PC_in: in std_logic_vector(15 downto 0);
			CS3_in: in std_logic_vector(control_length-1 downto 0);           --control signals
			A3_in: in std_logic_vector(2 downto 0);
			CZ_in: in std_logic_vector(1 downto 0);   --updated by alu
			AO_in: in std_logic_vector(15 downto 0);   --alu out
			SH7_in: in std_logic_vector(15 downto 0);
			DR_in: in std_logic_vector(15 downto 0);    --forwarding D1 to mem_d in store type instruc.
			----------------------------------------
			PC_out: out std_logic_vector(15 downto 0);
			CS3_out: out std_logic_vector(control_length-1 downto 0);
			A3_out: out std_logic_vector(2 downto 0);
			CZ_out: out std_logic_vector(1 downto 0);
			AO_out: out std_logic_vector(15 downto 0);
			SH7_out: out std_logic_vector(15 downto 0);
			DR_out: out std_logic_vector(15 downto 0);
			----------------------------------------
			clk,flush,enable,flush_prev : in std_logic;
			flush_out : out std_logic);
	end component;

	component MA_WB is
		generic( control_length : integer := 3);
		port(	PC_in : in std_logic_vector(15 downto 0);
			CS4_in: in std_logic_vector(control_length-1 downto 0);           --control signals
			A3_in: in std_logic_vector(2 downto 0);
			RFD_in: in std_logic_vector(15 downto 0);   --register file input data register
			----------------------------------------
			PC_out : out std_logic_vector(15 downto 0);
			CS4_out: out std_logic_vector(control_length-1 downto 0);
			A3_out: out std_logic_vector(2 downto 0);
			RFD_out: out std_logic_vector(15 downto 0);
			----------------------------------------
			clk,flush,enable,flush_prev : in std_logic;
			flush_out : out std_logic);
	end component;

end package;
--------------------------------------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity ID_RR is
	generic( control_length : integer := 3);
	port(	PC_in: in std_logic_vector(15 downto 0);
		CS1_in: in std_logic_vector(control_length-1 downto 0);           --control signals
		A1_in: in std_logic_vector(2 downto 0);
		A2_in: in std_logic_vector(2 downto 0);
		A3_in: in std_logic_vector(2 downto 0);		--write address in RF(carried till last stage)
		SE6_in: in std_logic_vector(15 downto 0);
		SE9_in: in std_logic_vector(15 downto 0);
		SH7_in: in std_logic_vector(15 downto 0);
		OP2_in: in std_logic_vector(2 downto 0);	--from LM/SM block
		PC_im_in: in std_logic_vector(15 downto 0);	--pc+imm
		----------------------------------------
		PC_out: out std_logic_vector(15 downto 0);
		CS1_out: out std_logic_vector(control_length-1 downto 0);
		A1_out: out std_logic_vector(2 downto 0);
		A2_out: out std_logic_vector(2 downto 0);
		A3_out: out std_logic_vector(2 downto 0);
		SE6_out: out std_logic_vector(15 downto 0);
		SE9_out: out std_logic_vector(15 downto 0);
		SH7_out: out std_logic_vector(15 downto 0);
		OP2_out: out std_logic_vector(2 downto 0);
		PC_im_out: out std_logic_vector(15 downto 0);
		----------------------------------------
		clk,flush,enable,flush_prev : in std_logic;
		flush_out : out std_logic);
end entity;

architecture two of ID_RR is
	signal flush_in : std_logic;
begin
		flush_in <= flush_prev or flush;    --flush from previous pipe
		PC_REG: dregister
			generic map(16)
			port map(reset => flush_in, din => PC_in, dout => PC_out, enable => enable, clk => clk);
		CS1_REG: dregister
			generic map(control_length)
			port map(reset => flush_in, din => CS1_in, dout => CS1_out, enable => enable, clk => clk);
		A1_REG: dregister
			generic map(3)
			port map(reset => flush_in, din => A1_in, dout => A1_out, enable => enable, clk => clk);
		A2_REG: dregister
			generic map(3)
			port map(reset => flush_in, din => A2_in, dout => A2_out, enable => enable, clk => clk);
		A3_REG: dregister
			generic map(3)
			port map(reset => flush_in, din => A3_in, dout => A3_out, enable => enable, clk => clk);
		SE6_REG: dregister
			generic map(16)
			port map(reset => flush_in, din => SE6_in, dout => SE6_out, enable => enable, clk => clk);
		SE9_REG: dregister
			generic map(16)
			port map(reset => flush_in, din => SE9_in, dout => SE9_out, enable => enable, clk => clk);
		SH7_REG: dregister
			generic map(16)
			port map(reset => flush_in, din => SH7_in, dout => SH7_out, enable => enable, clk => clk);
		OP2_REG: dregister
			generic map(3)
			port map(reset => flush_in, din => OP2_in, dout => OP2_out, enable => enable, clk => clk);
		PC_im_REG: dregister
			generic map(16)
			port map(reset => flush_in, din => PC_im_in, dout => PC_im_out, enable => enable, clk => clk);
		flush_reg: dflipflop
			port map(reset => '0', din => flush, dout => flush_out, enable => '1', clk => clk);--enable is always 1

end architecture;
--------------------------------------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity EX_MA is
	generic( control_length : integer := 3);
	port(	PC_in: in std_logic_vector(15 downto 0);
		CS3_in: in std_logic_vector(control_length-1 downto 0);           --control signals
		A3_in: in std_logic_vector(2 downto 0);
		CZ_in: in std_logic_vector(1 downto 0);   --updated by alu
		AO_in: in std_logic_vector(15 downto 0);   --alu out
		SH7_in: in std_logic_vector(15 downto 0);
		DR_in: in std_logic_vector(15 downto 0);    --forwarding D1 to mem_d in store type instruc.
		----------------------------------------
		PC_out: out std_logic_vector(15 downto 0);
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
		SH7_REG: dregister
			generic map(16)
			port map(reset => flush_in, din => SH7_in, dout => SH7_out, enable => enable, clk => clk);
		DR_REG: dregister
			generic map(16)
			port map(reset => flush_in, din => DR_in, dout => DR_out, enable => enable, clk => clk);
		flush_reg: dflipflop
			port map(reset => '0', din => flush_in, dout => flush_out, enable => '1', clk => clk);--enable is always 1

end architecture;
--------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity MA_WB is
	generic( control_length : integer := 3);
	port(	PC_in : in std_logic_vector(15 downto 0);
		CS4_in: in std_logic_vector(control_length-1 downto 0);           --control signals
		A3_in: in std_logic_vector(2 downto 0);
		RFD_in: in std_logic_vector(15 downto 0);   --register file input data register
		----------------------------------------
		PC_out : out std_logic_vector(15 downto 0);
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
		PC_REG: dregister
			generic map(16)
			port map(reset => flush_in, din => PC_in, dout => PC_out, enable => enable, clk => clk);
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
			port map(reset => '0', din => flush_in, dout => flush_out, enable => '1', clk => clk);--enable is always 1

end architecture;
--------------------------------------------------------------------------------------------------------------------
