library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity RF is
    port
    ( d1,d2       : out std_logic_vector(15 downto 0);		----- Read outputs bus
      d3,d4       : in  std_logic_vector(15 downto 0);		----- Write Input bus
      wr_rf 	    : in  std_logic;    ----- Writing into a register
      wr_mul_rf  	: in  std_logic;		----- Writing into multiple registers
      a1,a2,a3    : in  std_logic_vector(2 downto 0);			----- Addresses
      reset      	: in  std_logic;
      reg_select : in std_logic_vector(7 downto 0);  ----- Select bits for LM and SM
      din_8x16    : in 2darray(7 downto 0);
      dout_8x16   : out 2darray(7 downto 0);
      clk         : in  std_logic );
end RF;
