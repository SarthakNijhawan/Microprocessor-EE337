library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity lsm_block is
  port(SM,LM : in std_logic;
       clk : in std_logic;
       ir8_out : in std_logic_vector(7 downto 0);
       lm_sm_stall : in std_logic;
       flush_bit_pipe1 : in std_logic;
       en_ir8, mux_ir8 : out std_logic;
       lm_sm_halt : out std_logic;
       lm_sm_nop : out std_logic;
       lm_sm_start : out std_logic;
       ir8_in : out std_logic_vector(7 downto 0);
       LM_address : out std_logic_vector(2 downto 0);
       SM_address : out std_logic_vector(2 downto 0)
       --mux_op2 : out std_logic
        );
end entity;

architecture behave of lsm_block is
    signal pe_out : std_logic_vector(2 downto 0);
    signal pe_done : std_logic;
    signal ir8_in_sig : std_logic(7 downto 0);
    --signal en_counter : std_logic;
    begin
        pe: PriorityEncoder
   			port map(input => ir8_out , output => pe_out , invalid => pe_done);
        process(SM,LM,ir8_out,clk,lm_sm_stall,flush_bit_pipe1,pe_out,pe_done,ir8_in_sig)
        variable counter : integer := 0;
        begin
            if(flush_bit_pipe1 = '1') then
                lm_sm_halt <= '0';
                counter := 0;
                lm_sm_nop <= '0';
            else
                if(SM = '0' and LM = '0') then
                    lm_sm_halt <= '0';
                    en_ir8 <= '1';
                    counter := 0;
                    mux_ir8 <= '0';
                    lm_sm_nop <= '0';
                else
                    if(lm_sm_stall = '1') then
                        en_ir8 <= '0';
                        lm_sm_halt <= '0';
                        lm_sm_nop <= '0';
                    else
                        if(counter = 0 and pe_done = '1') then
                            lm_sm_nop <= '1';
                            lm_sm_halt <= '0';
                            en_ir8 <= '1';
                            counter := 0;

                        else
                            lm_sm_nop <= '0';
                            if(counter = 0) then
                                lm_sm_start <= '1';
                            else
                                lm_sm_start <= '0';
                            end if;
                            en_ir8 <= '1';
                            mux_ir8 <= '1';
                            ir8_in_sig <= ir8_out;
                            ir8_in_sig(to_integer(unsigned(pe_out))) <= '0';
                            ir8_in <= ir8_in_sig;
                            if(ir8_in_sig = "00000000") then
                                lm_sm_halt <= '0';
                            else
                                lm_sm_halt <= '1';
                            end if;
                            if(clk'event and clk = '1') then counter := counter + 1;
                            end if;
                        end if;
                    end if;
                end if;
            end if;
        end process;
end behave;
