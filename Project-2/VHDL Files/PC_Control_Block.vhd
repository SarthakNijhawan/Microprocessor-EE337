library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_Control_Block is
  port
    (op_code : in std_logic_vector(3 downto 0);
     reset : in std_logic;
     PC_1 : in std_logic_vector(15 downto 0);
     PC_Imm : in std_logic_vector(15 downto 0);
     comp2_beq : in std_logic;
     D2_in : in std_logic_vector(15 downto 0);
     PC_out : out std_logic_vector(15 downto 0));
end PC_Control_Block;

architecture behave of PC_Control_Block is
  begin
    process(op_code,reset,PC_1,PC_Imm,comp2_beq,D2_in)
    begin
      if(reset = '1') then
        PC_out <= PC_1;
      else
        if(op_code = "1100" and comp2_beq = '1') then
          PC_out <= PC_Imm;
        elsif(op_code = "1000") then
          PC_out <= PC_Imm;
        elsif(op_code = "1001") then
          PC_out <= D2_in;
        else
          PC_out <= PC_1;
        end if;
      end if;
    end process;
end behave;
