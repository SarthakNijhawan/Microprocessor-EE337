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
     ir8_out : in std_logic_vector(7 downto 0);
     ir8_in : out std_logic_vector(7 downto 0);
     LM_address : out std_logic_vector(2 downto 0);
     SM_address : out std_logic_vector(2 downto 0);
     mux_select : out std_logic;
     pe_done : out std_logic;
     op2 : out std_logic_vector(15 downto 0)
	 en_IFID : out std_logic;
    );
end LM_SM_Block;

architecture behave of LM_SM_Block is
	signal start : std_logic := '0';
	signal counter : integer := 0;
	signal pe_done : std_logic := '0';
	signal LSM : std_logic;
  begin
	pe: PriorityEncoder
			port map(input => ir8_out , output => LSM , invalid => pe_done); 
	op2(15 downto 0) <= "0000000000000000";
	process(clk)
	begin
		if(clk'event and clk = '1') then 
			if((op_code = "0110" or opcode ="0111") and start = '0' and pe_done = '0') then
				start = '1';
				counter = 0;
				en_IFID = '0';
			end if;
			if(start = '1' and pe_done = '0' and op_code = "0110") then
				LM_address <= LSM;
				op2(2 downto 0) <= std_logic(counter,3);
				
				
			
			
	
	end process;
end behave;
