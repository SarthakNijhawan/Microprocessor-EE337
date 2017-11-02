library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity alu is
 Port ( 
	 inp1 : in std_logic_vector(15 downto 0);
	 inp2 : in std_logic_vector(15 downto 0); 
	 op_sel : in std_logic;
	 output : out std_logic_vector(15 downto 0);
	 c : out std_logic;
	 z : out std_logic
);
end alu;

architecture Behavioral of alu is
	signal add_carry: std_logic;
	signal add_sum,nander: std_logic_vector(15 downto 0);
	signal add_zero,nand_zero: std_logic;

	component n_adder is
		generic (n_bits : positive range 2 to positive'right := 16);
		port(op1,op2 : in std_logic_vector(n_bits-1 downto 0);
	                 sum : out std_logic_vector(n_bits-1 downto 0);
		       	  cz : out std_logic);
	end component;	
begin
	addition: n_adder 
		  generic map(16)
	          port map (inp1,inp2,add_sum,add_carry);
	nander <= inp1 nand inp2;
	add_zero <= '1' when (add_sum = "0000000000000000") else
		    '0';
	nand_zero <= '1' when (nander = "0000000000000000") else
		     '0';
	
	with op_sel select
		output <= add_sum when '0',
		          nander when others;
	with op_sel select
		c <= add_carry when '0',
		      '0' when others;
	with op_sel select
		z <= add_zero when '0',
		     nand_zero when others;
 
end Behavioral;

--process(inp1, inp2, op_sel) 
--begin
--	if (op_sel = '0') then
--		output <= add_sum;
--		     c <= add_carry;
--		     z <= add_zero;
--	elsif (op_sel = '1') then
--		output <= nander;
--		z <= nand_zero;
--		c <= '0';
--	else NULL;
--	end if;		
--end process; 
