library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity LM_SM_logic is
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
end LM_SM_logic;

architecture behave of LM_SM_logic is
	signal start : std_logic := '0';
	signal pe_done : std_logic := '0';
	signal LSM : std_logic_vector(2 downto 0);
  begin
	 pe: PriorityEncoder
			port map(input => ir8_out , output => LSM , invalid => pe_done);

	 op2(15 downto 3) <= "0000000000000";
	process(clk)
 		 variable counter : integer := 0;
	begin
		if(clk'event and clk = '1') then
		      if(reset = '1') then
				mux_select <= '0';
				en_PC <= '1';
				en_IFID <= '1';
		      else
	  			if((op_code = "0110" or op_code ="0111") and start = '0' and pe_done = '0') then
	  				start <= '1';
	  				counter := 0;
	  				en_IFID <= '0';
					ir8_in <= ir8_out;
					en_PC <= '0';
					en_IFID <= '0';
					mux_select <= '1';
	  			end if;

	  			if(start = '1' and pe_done = '0' and op_code = "0110") then
	  				LM_address <= LSM;
	  				op2(2 downto 0) <= std_logic_vector(to_unsigned(counter,3));
					ir8_in(counter) <= '0';
					counter := counter + 1;
				end if;

				if(start = '1' and pe_done = '0' and op_code = "0111") then
		  			SM_address <= LSM;
					op2(2 downto 0) <= std_logic_vector(to_unsigned(counter,3));
					ir8_in(counter) <= '0';
					counter := counter + 1;
				end if;

				if(ir8_in = "00000000" and start = '1') then
				  en_PC <= '1';
				  en_IFID <= '1';
				  mux_select <= '0';
				  start <= '0';
				end if;
		      end if;
		end if;
	end process;
end behave;
