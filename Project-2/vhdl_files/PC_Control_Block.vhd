library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_Control_Block is
  port
    (IR : in std_logic_vector(15 downto 0);
     flush_bit_pipe2 : in std_logic;
     add1 : in std_logic_vector(15 downto 0);
     PC_Imm : in std_logic_vector(15 downto 0);
     comp2_beq : in std_logic;
     D2_in : in std_logic_vector(15 downto 0);
     PCL_out : out std_logic_vector(15 downto 0);
     flush_2_pipe : out std_logic);
end PC_Control_Block;

architecture behave of PC_Control_Block is
  begin
    process(IR,add1,PC_Imm,comp2_beq,D2_in,flush_bit_pipe2)
    begin
        if(flush_bit_pipe2 = '1') then
            PCL_out <= add1;
            flush_2_pipe <= '0';
        else
            if(IR(15 downto 12) = "1000") then
                PCL_out <= PC_Imm;
                flush_2_pipe <= '1';
            elsif(IR(15 downto 12) = "1001") then
                PCL_out <= D2_in;
                flush_2_pipe <= '1';
            elsif(IR(15 downto 12) = "1100" and comp2_beq = '1') then
                PCL_out <= PC_Imm;
                flush_2_pipe <= '1';
            else
                PCL_out <= add1;
                flush_2_pipe <= '0';
            end if;
        end if;
    end process;
end behave;
