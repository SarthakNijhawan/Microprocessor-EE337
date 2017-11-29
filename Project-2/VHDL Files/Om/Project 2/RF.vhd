library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- library work;
-- USE work.components.all;
entity arbit is
  TYPE matrix16 IS ARRAY (NATURAL RANGE <>) OF std_logic_vector(15 downto 0);
end arbit;

entity RF is
    port
    ( d1,d2       : out std_logic_vector(15 downto 0);		----- Read outputs bus
      d3,d4       : in  std_logic_vector(15 downto 0);		----- Write Input bus
      wr_rf 	    : in  std_logic;    ----- Writing into a register
      wr_mul_rf  	: in  std_logic;		----- Writing into multiple registers
      a1,a2,a3    : in  std_logic_vector(2 downto 0);			----- Addresses
      reset      	: in  std_logic;
      reg_select  : in std_logic_vector(7 downto 0);  ----- Select bits for LM and SM
      din_rf    : in matrix16(6 downto 0);
      dout_rf   : out matrix16(7 downto 0);
      clk         : in  std_logic );
end RF;

architecture behave of RF is
  type regFile is array(0 downto 7) of std_logic_vector(15 downto 0);
  signal registers : regFile;

  begin

    d1 <= registers(to_integer(unsigned(a1)));
    d2 <= registers(to_integer(unsigned(a2)));

    dout_rf(0) <= registers(0);
    dout_rf(1) <= registers(1);
    dout_rf(2) <= registers(2);
    dout_rf(3) <= registers(3);
    dout_rf(4) <= registers(4);
    dout_rf(5) <= registers(5);
    dout_rf(6) <= registers(6);

    process(clk,reset)
    begin
      if(reset = '1') then
        registers <= (others => (others => '0'));
      else
        if(clk'event and clk = '1') then
          if(wr_mul_rf = '1' and reg_select(7) = '1') then
            registers(7) <= din_rf(7);
          end if;
          if(wr_rf  = '1' and to_integer(unsigned(a3)) /= 7) then
            registers(7) <= d4;
          end if;
          if(wr_mul_rf = '0' and wr_rf = '0') then
            registers(7) <= d4;
          end if;
          if(wr_rf = '1') then
            registers(to_integer(unsigned(a3))) <= d3;
          end if;
          if(reg_select(0) = '1' and wr_mul_rf = '1') then
            registers(0) <= din_rf(0);
          end if;
          if(reg_select(1) = '1' and wr_mul_rf = '1') then
            registers(1) <= din_rf(1);
          end if;
          if(reg_select(2) = '1' and wr_mul_rf = '1') then
            registers(2) <= din_rf(2);
          end if;
          if(reg_select(3) = '1' and wr_mul_rf = '1') then
            registers(3) <= din_rf(3);
          end if;
          if(reg_select(4) = '1' and wr_mul_rf = '1') then
            registers(4) <= din_rf(4);
          end if;
          if(reg_select(5) = '1' and wr_mul_rf = '1') then
            registers(5) <= din_rf(5);
          end if;
          if(reg_select(6) = '1' and wr_mul_rf = '1') then
            registers(6) <= din_rf(6);
          end if;
        end if;
      end if;
    end process;

  end behave;
