library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LM_SM_Block is
  port
    (reset : in std_logic;
     clk : in std_logic;
     op_code : in std_logic_vector(3 downto 0);
     ir8_out : in std_logic_vector(7 downto 0);
     ir8_in : out std_logic_vector(7 downto 0);
     LM_address : out std_logic_vector(2 downto 0);
     SM_address : out std_logic_vector(2 downto 0);
     mux_select : out std_logic;
     pe_done : out std_logic;
     op2 : out std_logic_vector(15 downto 0)
    );
end LM_SM_Block;

architecture behave of LM_SM_Block is


  begin

end behave;
