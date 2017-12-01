library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity flag_reg is
port(en_carry : in std_logic;
     en_zero : in std_logic;
     clk : in std_logic;
     reset : in std_logic;
     op_code : in std_logic_vector(3 downto 0);
     carry_in,zero_in : in std_logic;
     comp1 : in std_logic;
     carry_flag,zero_flag : out std_logic
    );
end flag_reg;

architecture behave of flag_reg is
  signal input_zero : std_logic;
  begin
    process(clk,reset,op_code,en_carry,en_zero,comp1)
    begin
      if(op_code = "0100") then
        input_zero <= comp1;
      else
        input_zero <= zero_in;
      end if;
    end process;

  zero_reg : dflipflop
    port map( reset => reset, din => input_zero, dout => zero_flag, enable => en_zero, clk => clk);

  carry_reg : dflipflop
    port map( reset => reset, din => carry_in, dout => carry_flag, enable => en_carry, clk => clk);
end behave;
