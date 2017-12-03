library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity lsm_logic_block is
  port(SM,LM : in std_logic;
       ir8_out : in std_logic_vector(7 downto 0);
       lm_sm_stall : in std_logic;
       flush_bit_pipe1 : in std_logic;
       en_ir8, mux_ir8 : out std_logic;
       lm_sm_halt : out std_logic;
       lm_sm_nop : out std_logic;
       lm_sm_start : out std_logic;
       ir8_in : out std_logic_vector(7 downto 0);
       -----------------counter-------------------------
       counter_in : in std_logic_vector(2 downto 0);
       rst_counter, en_counter : out std_logic;
       -----------------PE-----------------------------
       pe_done : in std_logic;
       pe_out : in std_logic_vector(2 downto 0)
        );
end entity;

architecture behave of lsm_logic_block is
    signal ir8_in_sig : std_logic_vector(7 downto 0);
    begin
        -- pe: PriorityEncoder
   		-- 	port map(input => ir8_out , output => pe_out , invalid => pe_done);
        process(SM,LM,ir8_out,lm_sm_stall,flush_bit_pipe1,pe_out,pe_done,ir8_in_sig,counter_in)
        begin
            if(flush_bit_pipe1 = '1') then
                lm_sm_halt <= '0';
                lm_sm_nop <= '0';
                lm_sm_start <= '0';
                rst_counter <= '1';
            else
                if(SM = '0' and LM = '0') then
                    lm_sm_halt <= '0';
                    en_ir8 <= '1';
                    mux_ir8 <= '0';
                    lm_sm_nop <= '0';
                    rst_counter <= '1';
                else
                    if(lm_sm_stall = '1') then
                        en_ir8 <= '0';
                        lm_sm_halt <= '0';
                        lm_sm_nop <= '0';
                        rst_counter <= '0';
                        en_counter <= '0';
                    else
                        if(counter_in = "000" and pe_done = '1') then
                            lm_sm_nop <= '1';
                            lm_sm_halt <= '0';
                            en_ir8 <= '1';
                            rst_counter <= '1';
                            mux_ir8 <= '0';
                        else
                            lm_sm_nop <= '0';
                            if(counter_in = "000") then
                                lm_sm_start <= '1';
                            else
                                lm_sm_start <= '0';
                            end if;
                            en_ir8 <= '1';
                            mux_ir8 <= '1';
                            rst_counter <= '0';
                            en_counter <= '1';
                            ir8_in_sig <= ir8_out;
                            ir8_in_sig(to_integer(unsigned(pe_out))) <= '0';
                            ir8_in <= ir8_in_sig;
                            if(ir8_in_sig = "00000000") then
                                lm_sm_halt <= '0';
                            else
                                lm_sm_halt <= '1';
                            end if;
                        end if;
                    end if;
                end if;
            end if;
        end process;
end behave;
