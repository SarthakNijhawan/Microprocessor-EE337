library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--USE work.components.all;

entity RF is
    port
    ( d1,d2       : out std_logic_vector(15 downto 0);		----- Read outputs bus
      d3,d4       : in  std_logic_vector(15 downto 0);		----- Write Input bus
      wr_rf 	    : in  std_logic;    ----- Writing into a register
      a1,a2,a3    : in  std_logic_vector(2 downto 0);			----- Addresses
      reset      	: in  std_logic;
      clk         : in  std_logic );
end RF;

architecture behave of RF is
  type regFile is array(7 downto 0) of std_logic_vector(15 downto 0);
  signal registers : regFile;

  begin

    d1 <= registers(to_integer(unsigned(a1)));
    d2 <= registers(to_integer(unsigned(a2)));

    process(clk,reset)
    begin
      if(reset = '1') then
        registers <= (others => (others => '0'));
      else
        if(clk'event and clk = '1') then
			if(wr_rf = '1') then
				if( to_integer(unsigned(a3)) = 7) then	
					registers(7) <= d3;
				else
					registers(to_integer(unsigned(a3))) <= d3;
					registers(7) <= d4;
				end if;
			else
				registers(7) <= d4;
			end if;
        end if;
		end if;
    end process;

  end behave;
