library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
   port ( mem_a,mem_d: in std_logic_vector(15 downto 0);
	  mem_out: out std_logic_vector(15 downto 0);
 	 clk,wr_mem: in std_logic);
end entity;

architecture Behave of memory is

type mem is array (0 to 15) of std_logic_vector(15 downto 0);
signal memory:mem;
signal addr: integer range 0 to 65535;

begin

process (clk)
begin
	addr<= to_integer(unsigned(mem_a));

	if( clk'event and clk = '1') then
		if (wr_mem = '0') then
			mem_out<=memory(addr);

		elsif (wr_mem = '1')then
   			memory(addr)<= mem_d;
		end if;
	end if;
end process;

end architecture Behave;
