library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity memory is
   port ( address,data: in std_logic_vector(15 downto 0);
	  dout: out std_logic_vector(15 downto 0);
 	 clk,write_en: in std_logic);
end entity;

architecture Behave of memory is

type mem is array (0 to 65535) of std_logic_vector(15 downto 0);
signal memory:mem;
signal addr: integer range 0 to 65535;

begin

process (write_en,address,clk)
begin
addr<= to_integer(unsigned(address));

if (write_en = '0') then 
	dout<=memory(addr);
	
elsif (write_en = '1')then 
	if( clk'event and clk = '1') then 
   		memory(addr)<= data;
	end if;
end if;
end process; 

end architecture Behave;
