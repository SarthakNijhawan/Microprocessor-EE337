library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity lsm_block is
    port(SM,LM : in std_logic;
         clk : in std_logic;
         lm_sm_stall : in std_logic;
         flush_bit_pipe1 : in std_logic;
         ir8_IF : in std_logic_vector(7 downto 0);
         lm_sm_halt : out std_logic;
         lm_sm_nop : out std_logic;
         lm_sm_start : out std_logic;
         LM_address : out std_logic_vector(2 downto 0);
         SM_address : out std_logic_vector(2 downto 0);
         op2 : out std_logic_vector(15 downto 0)
          );

end lsm_block;

architecture behave of lsm_block is
    signal ir8_out,mux_ir8_out : std_logic_vector(7 downto 0);
    signal en_ir8, mux_ir8,lm_sm_start_1,rst_counter, en_counter, pe_done : std_logic;
    signal ir8_in : std_logic_vector(7 downto 0);
    signal counter_in,pe_out : std_logic_vector(2 downto 0);
--------------------------------------------------------------------------------
    component lsm_logic_block is
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
    end component;
--------------------------------------------------------------------------------
    begin
          mux_1 : mux_2to1_nbits
              generic map(8)
              port map(s0 => mux_ir8, input0 => ir8_IF, input1 => ir8_in, output => mux_ir8_out);

          ir8_reg : dregister
          	  generic map(8)
          	  port map(reset => '0', din => mux_ir8_out, dout => ir8_out, enable => en_ir8, clk => clk );

          counter1 : counter
              port map(clk => clk, reset => rst_counter, enable => en_counter, A => counter_in);

          pe: PriorityEncoder
     		  port map(input => ir8_out , output => pe_out , invalid => pe_done);

          mux2 : mux_2to1_nbits
              generic map(16)
              port map(s0 => lm_sm_start_1, input0 => "0000000000000001", input1 => "0000000000000000", output => op2);

          lsm_block1 : lsm_logic_block
              port map(SM => SM,
                       LM => LM,
                       ir8_out => ir8_out,
                       lm_sm_stall => lm_sm_stall,
                       flush_bit_pipe1 => flush_bit_pipe1,
                       en_ir8 => en_ir8,
                       mux_ir8 => mux_ir8,
                       lm_sm_halt => lm_sm_halt,
                       lm_sm_nop => lm_sm_nop,
                       lm_sm_start => lm_sm_start_1,
                       ir8_in => ir8_in,
                       counter_in => counter_in,
                       rst_counter => rst_counter,
                       en_counter => en_counter,
                       pe_done => pe_done,
                       pe_out => pe_out);

            LM_address <= pe_out;
            SM_address <= pe_out;
            lm_sm_start <= lm_sm_start_1;
end behave;
