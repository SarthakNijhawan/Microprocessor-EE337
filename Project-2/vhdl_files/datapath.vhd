library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

library work;
use work.pipeline_registers.all;

entity datapath is
	port(
		reset, clk : in std_logic);
end datapath;

architecture behave of datapath is

	signal
-------------------------------LM SM Block--------------------------------------
	component lsm_block is
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
	         op2 : out std_logic_vector(15 downto 0));
	end component;
--------------------------------------------------------------------------------

----------------------------------IDU-------------------------------------------
	component decoder is
		port(
			IR : in std_logic_vector(15 downto 0);
			sm_address : in std_logic_vector(2 downto 0);
			lm_sm_start : in std_logic;
			lm_detected, sm_detected : out std_logic;
			mux_add2,mux_7sh,mux_a2,mux_d1,mux_d2,mux_dr,mux_rfd,mux_z2,alu_op_sel,wr_mem,wr_rf,op1_check,op2_check,dest_cycle,mux_ao,valid_dest : out std_logic;
			mux_a3,mux_op1,mux_op2,source1_cycle,source2_cycle : out std_logic_vector(1 downto 0)
			);
	end component;
--------------------------------------------------------------------------------
-------------------------------Forwarding Unit----------------------------------
	component FU is
		port(   p3_lm_sm_bit, p4_lm_sm_bit, p5_lm_sm_bit, lm_sm_bit, op1_check,
	            op2_check, p5_dest, p4_dest, p3_dest, p4_valid, p5_valid, p3_valid, flush_bit_pipe2 : in std_logic;
	            A1,A2,p3_a3,p4_a3,p5_a3 : in std_logic_vector(2 downto 0);
	            source1_cycle,source2_cycle : in std_logic_vector(1 downto 0);
	            mux_memd,mux_dr,stall_bit : out std_logic;
	            mux_op1,mux_op2,mux_d1,mux_d2 : out std_logic_vector(1 downto 0)
	            );
	end component;
--------------------------------------------------------------------------------
------------------------------------HMU-----------------------------------------
	component HazardMitigationUnit is
		port(
			reset, flush_2_pipes, lm_sm_halt, lm_sm_nop, fu_stall, p5_dest_valid : in std_logic;
			p5_rfd, pcl_out, ir : in std_logic_vector(15 downto 0);
			p5_a3 : in std_logic_vector(2 downto 0);
			lm_sm_bits : in std_logic_vector(4 downto 0);
			---------------------------------------------------------------
			flush_bits, pipe_en_bits : out std_logic_vector(4 downto 0);
			pc_in : out std_logic_vector(15 downto 0);
			en_pc, lm_sm_stall, wr_mem_mux : out std_logic);

	end component;
--------------------------------------------------------------------------------
--------------------------PC Control Logic -------------------------------------
	component PC_Control_Block is
	  port( IR : in std_logic_vector(15 downto 0);
	        flush_bit_pipe2 : in std_logic;
	        add1 : in std_logic_vector(15 downto 0);
	        PC_Imm : in std_logic_vector(15 downto 0);
	        comp2_beq : in std_logic;
	        D2_in : in std_logic_vector(15 downto 0);
	        PCL_out : out std_logic_vector(15 downto 0);
	        flush_2_pipe : out std_logic);
	end component;
--------------------------------------------------------------------------------
-------------------------------Flag Unit----------------------------------------
	component flag_unit is
	  port (IR : in std_logic_vector(15 downto 0); --
		    --ari_bits : in std_logic_vector(1 downto 0);
		    c_2 : in std_logic;
		    z_2 : in std_logic;
		    wr_rf_in : in std_logic
		    flush_bit_flag_unit : in std_logic;
		    p5_a3 : in std_logic_vector(2 downto 0);
		    en_c2 : out std_logic;
		    en_z2 : out std_logic;
		    wr_rf :out std_logic);
	end component;
--------------------------------------------------------------------------------
-------------------------------Comparator 1-------------------------------------
	component comp1 is
	  port(mem_out : in std_logic_vector(15 downto 0);
		   comp1 : out std_logic
		  );
	end component;
--------------------------------------------------------------------------------
-------------------------------Comparator 2-------------------------------------
	component comp2 is
		port(d1_in,d2_in : in std_logic_vector(15 downto 0);
  	       comp2 : out std_logic
  	      );
	end component;
--------------------------------------------------------------------------------
-------------------------------Flag Reg Unit------------------------------------
	component flag_reg is
		port(en_carry : in std_logic;
		     en_zero : in std_logic;
		     clk : in std_logic;
		     reset : in std_logic;
		     op_code : in std_logic_vector(3 downto 0);
		     carry_in,zero_in : in std_logic;
		     comp1 : in std_logic;
		     carry_flag,zero_flag : out std_logic
		    );
	end component;
--------------------------------------------------------------------------------
-------------------------------I-RAM--------------------------------------------
	component i_memory is
		generic(num_words: integer := 256);
		port(
			imem_a: in std_logic_vector(15 downto 0);
			imem_out: out std_logic_vector(15 downto 0);
			rd_imem ,clk : in std_logic);
	end component;
--------------------------------------------------------------------------------
--------------------------------DRAM--------------------------------------------
component d_memory is
	generic(num_words: integer := 256);
	port(
		dmem_d: in std_logic_vector(15 downto 0);
		dmem_a: in std_logic_vector(15 downto 0);
		dmem_out: out std_logic_vector(15 downto 0);
		wr_dmem,clk : in std_logic);
end component;
--------------------------------------------------------------------------------
-------------------------------------RF-----------------------------------------
	component RF is
	    port
	    ( d1,d2       : out std_logic_vector(15 downto 0);		----- Read outputs bus
	      d3,d4       : in  std_logic_vector(15 downto 0);		----- Write Input bus
	      wr_rf 	    : in  std_logic;    ----- Writing into a register
	      a1,a2,a3    : in  std_logic_vector(2 downto 0);			----- Addresses
	      reset      	: in  std_logic;
	      flush_bit_rf : in std_logic;
	      clk         : in  std_logic );
	end component;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

begin

end architecture ; -- behave
