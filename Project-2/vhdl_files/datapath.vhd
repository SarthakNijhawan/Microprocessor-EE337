library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity datapath is
	port(
		reset, clk : in std_logic);
end datapath;

architecture behave of datapath is

	signal 

	component lsm_block is
	    port(SM,LM : in std_logic;
	         clk : in std_logic;
	         lm_sm_stall : in std_logic;
	         flush_bit_pipe1 : in std_logic;
	         ir8_IF : in std_logic_vector(7 downto 0);
	         lm_sm_halt : out std_logic;
	         lm_sm_nop : out std_logic;
	         lm_sm_start : out std_logic;
	         LM_address : out std_logic_vector(2 downto 0);
	         SM_address : out std_logic_vector(2 downto 0);
	         op2 : out std_logic_vector(15 downto 0)
	          );

	end component;

	
begin
	


end architecture ; -- behave