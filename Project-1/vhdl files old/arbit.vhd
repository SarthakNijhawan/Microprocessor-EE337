library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm is
	port (clk,reset : in std_logic
	    );
end fsm;

architecture behave of fsm is
	type state is (S0,S1);
	signal Q,nQ : state ;
begin
		
	delay: process(clk)
	begin
		if(clk='1' and clk'event) then
			Q <= nQ;
		end if;
	end process delay;
	
	main: process (clk,reset,Q)	--main process
	begin
		if reset='1' then
			nQ <= S0;
		else
			case Q is
				when S0 => nQ <= S1;
				when S1 => nQ <= S0;
			end case;
		end if;
		
	end process;		
end behave;
