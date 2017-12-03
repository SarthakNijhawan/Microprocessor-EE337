library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity HazardMitigationUnit is
	port(
		reset : in std_logic;
		op_code : in std_logic_vector(3 downto 0);
		imm_ir_8 : in std_logic_vector(7 downto 0);
		LM_address : out std_logic_vector(2 downto 0);
		SM_address : out std_logic_vector(2 downto 0);
		op2 : out std_logic_vector(15 downto 0);
		en_IFID : out std_logic;
		en_PC : out std_logic);
	
end HazardMitigationUnit;

architecture behave of HazardMitigationUnit is

end behave;