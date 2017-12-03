library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter is
	port(	clk,reset,enable: in std_logic;
		overflow: out std_logic;
		A : out std_logic_vector(2 downto 0));
end entity;

architecture behave of counter is
	signal copy_A: std_logic_vector(2 downto 0);
begin
	process(clk)
		variable temp: std_logic_vector(2 downto 0):="000" ;
		begin
			if( clk'event and clk = '1') then
				if(reset = '0') then
				    if enable = '1' then
				      temp := temp + "001";
				    end if;
				else temp := "000";
				end if;
			end if;
			copy_A <= temp;
			A <= temp;
	end process;
	
	process(copy_A)
		begin
			if(copy_A = "000" and reset = '0') then
				overflow <= '1';
			else
				overflow <= '0';
			end if;
		end process;
end behave;	
	
