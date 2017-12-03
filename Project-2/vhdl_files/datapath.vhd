library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

--library work;
--use work.pipeline_registers.all;

entity datapath is
	port(
		reset, clk : in std_logic);
end datapath;

architecture behave of datapath is

-------------------------------LM SM Block--------------------------------------
	component lsm_block is
	    port(SM,LM : in std_logic;
				clk : in std_logic;
				lm_sm_stall : in std_logic;
				flush_bit_pipe1 : in std_logic;
				ir8_IF : in std_logic_vector(7 downto 0);
				----------------------------------------------------------------------
				lm_sm_halt : out std_logic;
				lm_sm_nop : out std_logic;
				lm_sm_start : out std_logic;
				LM_address : out std_logic_vector(2 downto 0);
				SM_address : out std_logic_vector(2 downto 0);
				op2 : out std_logic_vector(15 downto 0)
          );
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
            op2_check, p5_dest, p4_dest, p3_dest, p4_valid, p5_valid, p3_valid : in std_logic;
            A1, A2, p3_a3, p4_a3, p5_a3 : in std_logic_vector(2 downto 0);
            source1_cycle, source2_cycle : in std_logic_vector(1 downto 0);
            -----------------------------------------------------------------
            mux_memd, mux_dr, stall_bit : out std_logic;
            mux_op1, mux_op2, mux_d1, mux_d2 : out std_logic_vector(1 downto 0)
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
		    wr_rf_in : in std_logic;
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
	      wr_rf 	    : in  std_logic;    							----- Writing into a register
	      a1,a2,a3    : in  std_logic_vector(2 downto 0);			----- Addresses
	      reset      	: in  std_logic;
	      flush_bit_rf : in std_logic;
	      clk         : in  std_logic );
	end component;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
	component EX_MA is
		generic( control_length : integer := 3);
		port(	IR_in: in std_logic_vector(15 downto 0);
				PC_in: in std_logic_vector(15 downto 0);
				CS3_in: in std_logic_vector(control_length-1 downto 0);           --control signals
				A3_in: in std_logic_vector(2 downto 0);
				CZ_in: in std_logic_vector(1 downto 0);   --updated by alu
				AO_in: in std_logic_vector(15 downto 0);   --alu out
				DR_in: in std_logic_vector(15 downto 0);    --forwarding D1 to mem_d in store type instruc.
				----------------------------------------
				IR_out: out std_logic_vector(15 downto 0);
				PC_out: out std_logic_vector(15 downto 0);
				CS3_out: out std_logic_vector(control_length-1 downto 0);          
				A3_out: out std_logic_vector(2 downto 0);
				CZ_out: out std_logic_vector(1 downto 0);
				AO_out: out std_logic_vector(15 downto 0);
				DR_out: out std_logic_vector(15 downto 0);
				----------------------------------------
				clk, flush, enable, flush_prev, lm_sm_bit_in : in std_logic;
				flush_out, lm_sm_bit_out : out std_logic);
	end component;
	
	component MA_WB is
		generic( control_length : integer := 3);
		port(	PC_in : in std_logic_vector(15 downto 0);
				CS4_in: in std_logic_vector(control_length-1 downto 0);           --control signals
				A3_in: in std_logic_vector(2 downto 0);
				RFD_in: in std_logic_vector(15 downto 0);   --register file input data register
				----------------------------------------
				PC_out : out std_logic_vector(15 downto 0);
				CS4_out: out std_logic_vector(control_length-1 downto 0);          
				A3_out: out std_logic_vector(2 downto 0);
				RFD_out: out std_logic_vector(15 downto 0);
				----------------------------------------
				clk, flush, enable, flush_prev, lm_sm_bit_in : in std_logic;
				flush_out, lm_sm_bit_out : out std_logic);
	end component;

	
	
	
	
	
	component RR_EX is
		generic( control_length : integer := 3);
		port(	IR_in: in std_logic_vector(15 downto 0);
				PC_in: in std_logic_vector(15 downto 0);
				CS2_in: in std_logic_vector(control_length-1 downto 0);           --control signals
				A3_in: in std_logic_vector(2 downto 0);
				D1_in: in std_logic_vector(15 downto 0);
				D2_in: in std_logic_vector(15 downto 0);
				SE6_in: in std_logic_vector(15 downto 0);
				SH7_in: in std_logic_vector(15 downto 0);
				OP2_in: in std_logic_vector(15 downto 0);	--from LM/SM block
				----------------------------------------
				IR_out: out std_logic_vector(15 downto 0);
				PC_out: out std_logic_vector(15 downto 0);
				CS2_out: out std_logic_vector(control_length-1 downto 0);          
				A3_out: out std_logic_vector(2 downto 0);
				D1_out: out std_logic_vector(15 downto 0);
				D2_out: out std_logic_vector(15 downto 0);
				SE6_out: out std_logic_vector(15 downto 0);
				SH7_out: out std_logic_vector(15 downto 0);
				OP2_out: out std_logic_vector(15 downto 0);
				----------------------------------------
				clk, flush, enable, flush_prev, lm_sm_bit_in : in std_logic;
				flush_out, lm_sm_bit_out : out std_logic);
	end component;


	component ID_RR is
		generic( control_length : integer := 3);
		port(	IR_in: in std_logic_vector(15 downto 0);
				PC_in: in std_logic_vector(15 downto 0);
				CS1_in: in std_logic_vector(control_length-1 downto 0);           --control signals
				A1_in: in std_logic_vector(2 downto 0);
				A2_in: in std_logic_vector(2 downto 0);
				A3_in: in std_logic_vector(2 downto 0);		--write address in RF(carried till last stage)
				SE6_in: in std_logic_vector(15 downto 0);
--				SE9_in: in std_logic_vector(15 downto 0);
				SH7_in: in std_logic_vector(15 downto 0);
				OP2_in: in std_logic_vector(15 downto 0);	--from LM/SM block
				PC_im_in: in std_logic_vector(15 downto 0);	--pc+imm
				----------------------------------------
				IR_out: out std_logic_vector(15 downto 0);
				PC_out: out std_logic_vector(15 downto 0);
				CS1_out: out std_logic_vector(control_length-1 downto 0);          
				A1_out: out std_logic_vector(2 downto 0);
				A2_out: out std_logic_vector(2 downto 0);
				A3_out: out std_logic_vector(2 downto 0);
				SE6_out: out std_logic_vector(15 downto 0);
--				SE9_out: out std_logic_vector(15 downto 0);
				SH7_out: out std_logic_vector(15 downto 0);
				OP2_out: out std_logic_vector(15 downto 0);
				PC_im_out: out std_logic_vector(15 downto 0);
				----------------------------------------
				clk, flush, enable, flush_prev, lm_sm_bit_in : in std_logic;
				flush_out, lm_sm_bit_out : out std_logic);
	end component;


	component IF_ID is
		port(	PC_in: in std_logic_vector(15 downto 0);
				nPC_in: in std_logic_vector(15 downto 0);
				IR_in: in std_logic_vector(15 downto 0);
				----------------------------------------
				PC_out: out std_logic_vector(15 downto 0);
				nPC_out: out std_logic_vector(15 downto 0);
				IR_out: out std_logic_vector(15 downto 0);
				----------------------------------------
				clk, flush, enable, lm_sm_bit_in : in std_logic;
				flush_out, lm_sm_bit_out : out std_logic);
	end component;	
---------------------------------------------------------------------------------------------
											-----SIGNALS-----
---------------------------------------------------------------------------------------------
signal 	hmu_pc, pc_out, imem_out_sig, add1_out, id_pc, id_npc, id_ir, lsm_op2, id_se6, id_se9, id_7sh,
			add2_out, mux_add2_out, mux_7sh_out, rr_ir, rr_pc, rr_op2, rr_se6, rr_sh7,
			rr_pc_im : std_logic_vector(15 downto 0);

signal 	hmu_pc_en, lm_sm_check_sig, lsm_start, lsm_lm, lsm_sm, id_mux_add2, id_mux_7sh, id_mux_a2, id_mux_d1, id_mux_d2,
			id_mux_dr, id_mux_rfd, id_mux_z2, id_alu_op_sel, id_wr_mem, id_wr_rf, id_op1_check, id_op2_check, id_dest_cycle, 
			id_mux_ao, id_valid_dest, hmu_lsm_stall, lsm_halt, lsm_nop : std_logic;

			
signal 	id_mux_a3, id_mux_op1, id_mux_op2, id_source1_cycle, id_source2_cycle  : std_logic_vector(1 downto 0);
			
signal 	id_sm_addr, id_lm_addr, rr_a1_out, rr_a2_out, rr_a3_out, mux_a3_out, mux_a2_out : std_logic_vector(2 downto 0);

signal 	hmu_flush_bits, hmu_pipe_en_bits, pipe_lm_sm_bits_out, pipe_flush_out_bits: std_logic_vector(4 downto 0);


signal RA,RB,RC : std_logic_vector(2 downto 0);

signal rr_cs1_out : std_logic_vector(20 downto 0);

begin

	RA <= id_ir(11 downto 9);
	RB <= id_ir(8 downto 6);
	RC <= id_ir(5 downto 3);

---------------------------------------------IF Stage----------------------------------------
	
	lm_sm_check:
			process(imem_out_sig)
			begin
				if (imem_out_sig(15 downto 12) = "0110" or imem_out_sig(15 downto 12) = "0111") then
					lm_sm_check_sig <= '1';
				else
					lm_sm_check_sig <= '0';
				end if;
			end process;
	
	PC_REG: dregister
					generic map(16)
					port map(reset => reset, din => hmu_pc, dout => pc_out, enable => hmu_pc_en, clk => clk);
	
	IRAM: i_memory
					generic map(32)
					port map (imem_a => pc_out, imem_out => imem_out_sig, rd_imem => '1', clk => clk);
	
	ADD1: alu
					port map(inp1 => pc_out, inp2 => x"0001", op_sel => '0', output => add1_out);
							 
							 
	pipe1: IF_ID port map(	PC_in => pc_out, nPC_in => add1_out, IR_in => imem_out_sig, lm_sm_bit_in => lm_sm_check_sig, 
									clk => clk, flush => hmu_flush_bits(0), enable => hmu_pipe_en_bits(0),
									PC_out => id_pc, npc_out => id_npc, ir_out => id_ir, flush_out => pipe_flush_out_bits(0), lm_sm_bit_out => pipe_lm_sm_bits_out(0)
								);
	
----------------------------------------------ID Stage---------------------------------------------
	IDU: decoder
				port map (	IR => id_ir, sm_address => id_sm_addr,  lm_sm_start => lsm_start, 
								lm_detected => lsm_lm, sm_detected => lsm_sm, mux_add2 => id_mux_add2, 
								mux_7sh => id_mux_7sh, mux_a2 => id_mux_a2, mux_d1 => id_mux_d1, mux_d2 => id_mux_d2,
								mux_dr => id_mux_dr, mux_rfd => id_mux_rfd, mux_z2 => id_mux_z2, 
								alu_op_sel => id_alu_op_sel, wr_mem => id_wr_mem, wr_rf => id_wr_rf, op1_check => id_op1_check,
								op2_check => id_op2_check, dest_cycle => id_dest_cycle, mux_ao => id_mux_ao, valid_dest => id_valid_dest,
								mux_a3 => id_mux_a3, mux_op1 => id_mux_op1, mux_op2 => id_mux_op2, source1_cycle => id_source1_cycle, 
								source2_cycle => id_source2_cycle );
								
	
	LM_SM_block: lsm_block
				port map(	SM => lsm_sm, LM => lsm_lm, clk => clk, lm_sm_stall => hmu_lsm_stall, 
								flush_bit_pipe1 => pipe_flush_out_bits(0), ir8_IF => imem_out_sig(7 downto 0), lm_sm_halt => lsm_halt, 
								lm_sm_nop => lsm_nop, lm_sm_start => lsm_start, LM_address => id_lm_addr, 
								SM_address => id_sm_addr, op2 => lsm_op2);
					 
			 
	SE6: sign_extend
				generic map(input_width => 6, output_width => 16)
				port map(	input => id_ir(5 downto 0), output => id_se6 );
				
				
	SE9: sign_extend
				generic map(input_width => 9, output_width => 16)
				port map(	input => id_ir(8 downto 0), output => id_se9 );
				
		
	SH7: left7_shifter
				port map(	input => id_ir(8 downto 0), output => id_7sh );
		
		
	ADD2: alu
				port map(	inp1 => id_pc, inp2 => mux_add2_out, op_sel => '0', output => add2_out);
	
	amux_add2: mux_2to1_nbits
				generic map(16)
				port map(	s0 => id_mux_add2, input0 => id_se9, input1 => id_se6, output => mux_add2_out);

	amux_7sh: mux_2to1_nbits
				generic map(16)
				port map(	s0 => id_mux_7sh, input0 => id_7sh, input1 => id_npc, output => mux_7sh_out);
				
	amux_a3: mux_4to1_nbits
				generic map(3)
				port map(	s0 => id_mux_a3(0), s1 => id_mux_a3(1), input0 => id_lm_addr, input1 => RA, input2 => RB, input3 => RC, output => mux_a3_out);
				
	amux_a2: mux_2to1_nbits
				generic map(3)
				port map(	s0 => id_mux_a2, input0 => RB, input1 => id_sm_addr, output => mux_a2_out);
	

	pipe2: ID_RR 
				generic map(21)
				port map(	PC_in => id_pc, IR_in => id_ir, A1_in => RA, A2_in => mux_a2_out, A3_in => mux_a3_out,
								SE6_in => id_se6, sh7_in => id_7sh, op2_in => lsm_op2, PC_im_in => add2_out,
								clk => clk, flush => hmu_flush_bits(1), enable => hmu_pipe_en_bits(1), 
								flush_prev => pipe_flush_out_bits(0), lm_sm_bit_in => pipe_lm_sm_bits_out(0),
								flush_out => pipe_flush_out_bits(1), lm_sm_bit_out => pipe_lm_sm_bits_out(1),
								IR_out => rr_ir, pc_out => rr_pc, A1_out => rr_a1_out, A2_out => rr_a2_out,
								A3_out => rr_a3_out, SE6_out => rr_se6, SH7_out => rr_sh7, op2_out => rr_op2,
								PC_im_out => rr_pc_im, cs1_out => rr_cs1_out, 
								cs1_in(0) => id_mux_d1, cs1_in(1) => id_mux_d2, cs1_in(2) => id_mux_op1(0), cs1_in(3) => id_mux_op1(1),
								cs1_in(4) => id_mux_op2(0), cs1_in(5) => id_mux_op2(1), cs1_in(6) => id_mux_dr, cs1_in(7) => id_mux_rfd,
								cs1_in(8) => id_mux_z2, cs1_in(9) => id_alu_op_sel, cs1_in(10) => id_wr_mem, cs1_in(11) => id_wr_rf, 
								cs1_in(12) => id_op1_check, cs1_in(13) => id_op2_check, cs1_in(14) => id_dest_cycle, cs1_in(15) => id_source1_cycle(0),
								cs1_in(16) => id_source1_cycle(1), cs1_in(17) => id_source2_cycle(0), cs1_in(18) => id_source2_cycle(1), cs1_in(19) => id_mux_ao, 
								cs1_in(20) => id_valid_dest );	------ MSGs of multiple bit CSs are at hiher index
			
----------------------------------------------RR Stage---------------------------------------------
	

		
end architecture ; -- behave
