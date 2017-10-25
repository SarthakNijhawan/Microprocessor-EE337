library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter is
	port(	reset,enable: in std_logic;
		A : out std_logic_vector(2 downto 0));
end entity;

architecture behave of counter is

begin
	process(reset,enable)
		variable temp: std_logic_vector(2 downto 0):="000" ;
		begin
			if(reset = '0') then
			    if enable = '1' then
			      temp := temp + "001";
			    end if;
			else temp := "000";
			end if;
			A <= temp;
	end process;
	
	

end behave;	
	
