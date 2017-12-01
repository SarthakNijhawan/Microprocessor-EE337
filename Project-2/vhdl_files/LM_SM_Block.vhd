library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity LM_SM_Block is
  port
	    (reset : in std_logic;
	     clk : in std_logic;
	     op_code : in std_logic_vector(3 downto 0);
	     imm_ir_8 : in std_logic_vector(7 downto 0);
	     LM_address : out std_logic_vector(2 downto 0);
	     SM_address : out std_logic_vector(2 downto 0);
	     op2 : out std_logic_vector(15 downto 0);
	     en_IFID : out std_logic;
	     en_PC : out std_logic
	    );
end LM_SM_Block;

architecture behave of LM_SM_Block is
	signal ir8_out : std_logic_vector(7 downto 0);
	signal ir8_in : std_logic_vector(7 downto 0);
	signal mux_select : std_logic;
	signal mux_out : std_logic_vector(7 downto 0);

	component LM_SM_logic is
	  port
		    (reset : in std_logic;
		     clk : in std_logic;
		     op_code : in std_logic_vector(3 downto 0);
		     ir8_out : in std_logic_vector(7 downto 0);
		     ir8_in : inout std_logic_vector(7 downto 0);
		     LM_address : out std_logic_vector(2 downto 0);
		     SM_address : out std_logic_vector(2 downto 0);
		     mux_select : out std_logic;
		     op2 : out std_logic_vector(15 downto 0);
		     en_IFID : out std_logic;
		     en_PC : out std_logic
		    );
	end component;

begin
	mux1 : mux_2to1_nbits
	  generic map(8)
	  port map(s0 => mux_select, input0 => imm_ir_8, input1 => ir8_in, output => mux_out);

	ir8_reg : dregister
	  generic map(8)
	  port map(reset => reset, din => mux_out, dout => ir8_out, enable => '1', clk => clk );

	lsm_block : LM_SM_logic
	  port map(reset => reset,
		   clk => clk,
		   op_code => op_code,
		   ir8_out => ir8_out,
		   ir8_in => ir8_in,
		   LM_address => LM_address,
		   SM_address => SM_address,
		   mux_select => mux_select,
		   op2 => op2,
		   en_IFID => en_IFID,
		   en_PC => en_PC
		   );

end behave;
