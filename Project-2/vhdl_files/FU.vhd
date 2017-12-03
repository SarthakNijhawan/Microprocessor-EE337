library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FU is
    port(p3_lm_sm_bit,p4_lm_sm_bit,p5_lm_sm_bit,lm_sm_bit,op1_check,op2_check,p5_dest,p4_dest,p3_dest,p4_valid,p5_valid,p3_valid : in std_logic;
         A1,A2,p3_a3,p4_a3,p5_a3 : in std_logic_vector(2 downto 0);
         source1_cycle,source2_cycle : in std_logic_vector(1 downto 0);
         mux_memd,mux_op1,mux_op2,mux_d1,mux_d2,mux_dr,stall_bit : out std_logic;
         nstalls : out std_logic_vector(2 downto 0)
        );
end FU;

architecture behave of FU is
    
end behave;
