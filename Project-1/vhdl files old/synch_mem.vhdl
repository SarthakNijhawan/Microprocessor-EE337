-- author: Madhav Desai
-- synchronous memory model (single cycle read/write delay).
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity synch_mem is
   generic (data_width: integer:= 8; addr_width: integer := 8);
   port(din: in std_logic_vector(data_width-1 downto 0);
        dout: out std_logic_vector(data_width-1 downto 0);
        en: in std_logic;
        wrbar: in std_logic;
        addrin: in std_logic_vector(addr_width-1 downto 0);
        clk: in std_logic);
end entity;
architecture behave of synch_mem is
   type MemArray is array(natural range <>) of std_logic_vector(data_width-1 downto 0);
   signal marray: MemArray(0 to ((2**addr_width)-1));
   
   function To_Integer(x: std_logic_vector) return integer is
      variable xu: unsigned(x'range);
   begin
      for I in x'range loop
         xu(I) := x(I);
      end loop;
      return(To_Integer(xu));
   end To_Integer;

begin

   -- there is only one state..
   process(clk)
      variable addr_var: integer range 0 to (2**addr_width)-1;
   begin
      addr_var := To_Integer(addrin);
      if(clk'event and clk = '1') then
         if(en = '1' and wrbar = '1') then
            dout <= marray(addr_var);
         elsif (en = '1') then
            marray(addr_var) <= din;
	end if;
      end if;        
   end process;

end behave;
