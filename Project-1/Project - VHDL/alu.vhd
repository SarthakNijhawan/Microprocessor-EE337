library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity alu is
 Port ( 
	 inp1 : in std_logic_vector(15 downto 0);
	 inp2 : in std_logic_vector(15 downto 0); 
	 op_sel : in std_logic;
	 output : out std_logic_vector(15 downto 0);
	 c : out std_logic;                             ---overflow flag
	 z : out std_logic
);
end alu;

architecture Behavioral of alu is
	signal temp_out : std_logic_vector(15 downto 0);
begin
	process(inp1,inp2,op_sel,temp_out)
		begin
			case op_sel is
				when '0' =>
					temp_out <= std_logic_vector(signed(inp1) + signed(inp2));
					output <= temp_out;
					-------overflow logic-------------------
					if(inp1(15) = inp2(15)) then
						if(temp_out(15) = inp1(15)) then
							c <= '0';
						else
							c <= '1';
						end if;
					else
						c <= '0';
					end if;
					--------zero flag-----------------------
					if(temp_out = x"0000") then
						z <= '1';
					else
						z <= '0';
					end if;					
				when '1' =>
					temp_out <= inp1 nand inp2;
					output <= temp_out;
					c <= '0';
					--------zero flag-----------------------
					if(temp_out = x"0000") then
						z <= '1';
					else
						z <= '0';
					end if;	
				when others =>
					NULL;
			end case;
		end process;
 
end Behavioral;

