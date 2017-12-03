library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity lsm_block is
  port(SM,LM : in std_logic;
       clk : in std_logic;
       en_ir8, mux_ir8 : in std_logic;
       ir8_out
        );
end entity;
