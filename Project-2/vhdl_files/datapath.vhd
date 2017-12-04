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
			rr_pc_im, rr_d1_out,rr_d2_out, rw_rfd_out, rw_pc_out, rr_mux_d1_out, rr_mux_d2_out, pcl_out,
			stat_mux_d1_out, stat_mux_d2_out, ma_ao_out, ex_ir, ex_se6, ex_sh7,ex_op2, ex_d1_out, ex_d2_out, ex_pc,
			ex_mux_op1_out, ex_mux_op2_out, alu_out, ex_stat_mux_op1, ex_stat_mux_op2, ex_mux_ao_out,
			stat_mux_dr_out, ex_mux_dr_out, ma_ir, ma_pc, ma_dr_out, dmem_out, ma_mux_memd_out, ma_mux_rfd_out : std_logic_vector(15 downto 0);

signal 	hmu_pc_en, lm_sm_check_sig, lsm_start, lsm_lm, lsm_sm, id_mux_add2, id_mux_7sh, id_mux_a2, id_mux_d1, id_mux_d2,
			id_mux_dr, id_mux_rfd, id_mux_z2, id_alu_op_sel, id_wr_mem, id_wr_rf, id_op1_check, id_op2_check, id_dest_cycle, 
			id_mux_ao, id_valid_dest, hmu_stall, lsm_halt, lsm_nop, rw_wr_rf, comp2_beq_out, pcl_flush_2_pipe,
			ma_wr_mem_mux , ex_mux_dr, ex_mux_rfd, ex_mux_z2, ex_alu_op_sel, ex_wr_mem, ex_wr_rf, ex_dest_cycle, ex_mux_ao, ex_valid_dest,
			rw_dest_cycle, rw_valid_dest, rr_mux_memd, fu_stall, rr_mux_dr,
			fu_mux_dr, fu_mux_memd, c_out, z_out, ma_mux_rfd, ma_mux_z2, ma_wr_mem, ma_wr_rf, ma_dest_cycle, ma_valid_dest, fu_ma_mux_memd,
			comp1_out, c_2_out, z_2_out, flag_unit_en_c2, flag_unit_en_z2, flag_unit_rf, ma_wr_mem_mux_out: std_logic;

			
signal 	id_mux_a3, id_mux_op1, id_mux_op2, id_source1_cycle, id_source2_cycle, ex_mux_op1, ex_mux_op2, rr_mux_op1, rr_mux_op2, rr_mux_d1,
			rr_mux_d2, fu_mux_op1, fu_mux_op2, ma_cz_out : std_logic_vector(1 downto 0);
			
signal 	id_sm_addr, id_lm_addr, rr_a1_out, rr_a2_out, rr_a3_out, mux_a3_out, mux_a2_out, ex_a3_out, rw_a3_out, ma_a3_out: std_logic_vector(2 downto 0);

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
					generic map(64)
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
				port map(	SM => lsm_sm, LM => lsm_lm, clk => clk, lm_sm_stall => hmu_stall, 
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
	aRF : RF
		port map(d1 => rr_d1_out,
					d2 => rr_d2_out,    
					d3 => rw_rfd_out,
					d4 => rw_pc_out,			
					wr_rf => rw_wr_rf,			
					a1 => rr_a1_out,
					a2 => rr_a2_out,
					a3 => rw_a3_out,    
					reset => reset,      	
					clk => clk );
			
	aFU : FU
		port map(p3_lm_sm_bit => pipe_lm_sm_bits_out(2),
					p4_lm_sm_bit => pipe_lm_sm_bits_out(3) , 
					p5_lm_sm_bit => pipe_lm_sm_bits_out(4), 
					lm_sm_bit => pipe_lm_sm_bits_out(1),		-- pipe2 ka out 
					op1_check => rr_cs1_out(12), 
					op2_check => rr_cs1_out(13), 
					p5_dest => rw_dest_cycle,
					p4_dest => ma_dest_cycle, 
					p3_dest => ex_dest_cycle, 
					p4_valid => rw_valid_dest,
					p5_valid => ma_valid_dest,
					p3_valid => ex_valid_dest,
					A1 => rr_a1_out,
					A2 => rr_a2_out, 
					p3_a3 => ex_a3_out,
					p4_a3 => ma_a3_out,
					p5_a3 => rw_a3_out,
					source1_cycle => rr_cs1_out(16 downto 15), source2_cycle => rr_cs1_out(18 downto 17),
					mux_memd => rr_mux_memd, mux_dr => rr_mux_dr, stall_bit => fu_stall,									-- dynamic muxes
					mux_op1 => rr_mux_op1, mux_op2 => rr_mux_op2, mux_d1 => rr_mux_d1, mux_d2 => rr_mux_d2			-- dynamic muxes
					);
				
	 PCL : PC_Control_Block
		port map(  IR => rr_ir,
					  flush_bit_pipe2 => pipe_flush_out_bits(1),
					  add1 => add1_out,
					  PC_Imm => rr_pc_im,
					  comp2_beq => comp2_beq_out,
					  D2_in => rr_mux_d2_out,
					  PCL_out => pcl_out,
					  flush_2_pipe => pcl_flush_2_pipe);
					  
	 HMU : HazardMitigationUnit
		port map(
						reset => reset, flush_2_pipes => pcl_flush_2_pipe, lm_sm_halt => lsm_halt, lm_sm_nop => lsm_nop,
						fu_stall => fu_stall, p5_dest_valid => rw_valid_dest, 
						p5_rfd => rw_rfd_out, pcl_out => pcl_out, ir => rr_ir, 
						p5_a3 => rw_a3_out,
						lm_sm_bits => pipe_lm_sm_bits_out,
						flush_bits => hmu_flush_bits, pipe_en_bits => hmu_pipe_en_bits,
						pc_in => hmu_pc,
						en_pc => hmu_pc_en, lm_sm_stall => hmu_stall, wr_mem_mux => ma_wr_mem_mux);
					
	static_mux_dr1 : mux_2to1_nbits
		generic map(16)
		port map(s0 => rr_cs1_out(0), input0 => rr_d1_out, input1 => rr_pc, output => stat_mux_d1_out);
		
	static_mux_dr2 : mux_2to1_nbits
		generic map(16)
		port map(s0 => rr_cs1_out(1), input0 => rr_d2_out, input1 => rr_pc, output => stat_mux_d2_out);
	
	dynamic_mux_dr1 : mux_4to1_nbits
		generic map(16)
		port map(	s0 => rr_mux_d1(0), s1 => rr_mux_d1(1), input0 => stat_mux_d1_out, input1 => ma_ao_out, input2 => rw_rfd_out, input3 => (others => '0'), output => rr_mux_d1_out);		
	
	dynamic_mux_dr2 : mux_4to1_nbits
		generic map(16)
		port map(	s0 => rr_mux_d2(0), s1 => rr_mux_d2(1), input0 => stat_mux_d2_out, input1 => ma_ao_out, input2 => rw_rfd_out, input3 => (others => '0'), output => rr_mux_d2_out);		
		
	comp2beq : comp2
		port map(d1_in => rr_mux_d1_out ,d2_in => rr_mux_d2_out,
  	       comp2 => comp2_beq_out);
			 
	pipe3 : RR_EX
		generic map(19)
		port map(	IR_in => rr_ir,
						PC_in => rr_pc,
						A3_in => rr_a3_out,
						D1_in => rr_mux_d1_out,
						D2_in => rr_mux_d2_out,
						SE6_in => rr_se6,
						SH7_in => rr_sh7,
						OP2_in => rr_op2,
						IR_out => ex_ir,
						PC_out => ex_pc,
						A3_out => ex_a3_out,
						D1_out => ex_d1_out,
						D2_out => ex_d2_out,
						SE6_out => ex_se6,
						SH7_out => ex_sh7,
						OP2_out => ex_op2,
						clk => clk, flush => hmu_flush_bits(2), enable => hmu_pipe_en_bits(2), flush_prev => pipe_flush_out_bits(1),
						lm_sm_bit_in => pipe_lm_sm_bits_out(1),
						flush_out => pipe_flush_out_bits(2), lm_sm_bit_out => pipe_lm_sm_bits_out(2),
						-------- CS in Static------
						CS2_in(0) => rr_cs1_out(2), CS2_in(1) => rr_cs1_out(3), 
						CS2_in(2) => rr_cs1_out(4), CS2_in(3) => rr_cs1_out(5),
						CS2_in(4) => rr_cs1_out(6), CS2_in(5) => rr_cs1_out(7),
						CS2_in(6) => rr_cs1_out(8), CS2_in(7) => rr_cs1_out(9), 
						CS2_in(8) => rr_cs1_out(10), CS2_in(9) => rr_cs1_out(11),
						CS2_in(10) => rr_cs1_out(14), CS2_in(11) => rr_cs1_out(19),
						CS2_in(12) => rr_cs1_out(20),
						-------- CS in Dynamic----
						CS2_in(14 downto 13) => rr_mux_op1, CS2_in(16 downto 15) => rr_mux_op2,
						CS2_in(17) => rr_mux_dr, CS2_in(18) => rr_mux_memd,
						---------CS out Static------
						CS2_out(1 downto 0) => ex_mux_op1, CS2_out(3 downto 2) => ex_mux_op2, 
						CS2_out(4) => ex_mux_dr, CS2_out(5) => ex_mux_rfd, CS2_out(6) => ex_mux_z2,
						CS2_out(7) => ex_alu_op_sel, CS2_out(8) => ex_wr_mem, CS2_out(9) => ex_wr_rf, 
						CS2_out(10) => ex_dest_cycle, CS2_out(11) => ex_mux_ao, CS2_out(12) => ex_valid_dest,
						--------CS our Dynamic------
						CS2_out(14 downto 13) => fu_mux_op1, CS2_out(16 downto 15) => fu_mux_op2,
						CS2_out(17) => fu_mux_dr, CS2_out(18) => fu_mux_memd
						);
						
----------------------------------------------EX Stage---------------------------------------------
		
	ALU_main: alu
		port map( inp1 => ex_mux_op1_out, inp2 => ex_mux_op2_out, op_sel => ex_alu_op_sel, output => alu_out, c => c_out, z => z_out);
		
	static_mux_op1 : mux_4to1_nbits
		generic map(16)
		port map(s0 => ex_mux_op1(0), s1 => ex_mux_op1(1), input0 => ex_d1_out, input1 => ex_se6, input2 => ma_ao_out, 
					input3 => (others => '0'), output => ex_stat_mux_op1);		
	
	static_mux_op2 : mux_4to1_nbits
		generic map(16)
		port map(s0 => ex_mux_op2(0), s1 => ex_mux_op2(1), input0 => ex_d2_out, input1 => ex_op2, input2 => ma_ao_out, 
					input3 => (others => '0'), output => ex_stat_mux_op2);	
	
	dynamic_mux_op1 : mux_4to1_nbits
		generic map(16)
		port map(s0 => fu_mux_op1(0), s1 => fu_mux_op1(1), input0 => ex_stat_mux_op1, input1 => ma_ao_out, input2 => rw_rfd_out, 
					input3 => (others => '0'), output => ex_mux_op1_out);		
	
	dynamic_mux_op2 : mux_4to1_nbits
		generic map(16)
		port map(s0 => fu_mux_op2(0), s1 => fu_mux_op2(1), input0 => ex_stat_mux_op2, input1 => ma_ao_out, input2 => rw_rfd_out, 
					input3 => (others => '0'), output => ex_mux_op2_out);
					
	static_mux_a0 : mux_2to1_nbits
		generic map(16)
		port map(s0 => ex_mux_ao, input0 => alu_out, input1 => ex_sh7, output => ex_mux_ao_out);
		
	static_mux_dr : mux_2to1_nbits
		generic map(16)
		port map(s0 => ex_mux_dr, input0 => ex_d2_out, input1 => ex_d1_out, output => stat_mux_dr_out);
		
	dynamic_mux_dr : mux_2to1_nbits
		generic map(16)
		port map(s0 => fu_mux_dr, input0 => stat_mux_dr_out, input1 => rw_rfd_out, output => ex_mux_dr_out);
		
	pipe4: EX_MA
		generic map(7)
		port map(IR_in => ex_ir,
					PC_in => ex_pc,
					A3_in => ex_a3_out,
					cz_in(1) => c_out, cz_in(0) => z_out,
					AO_in => ex_mux_ao_out,
					DR_in => ex_mux_dr_out,
					--------- out -------
					IR_out => ma_ir,
					PC_out => ma_pc,
					A3_out => ma_a3_out,
					cz_out => ma_cz_out,				-- carry is MSB
					Ao_out => ma_ao_out,
					DR_out => ma_dr_out,
					---------------------
					clk => clk, flush => hmu_flush_bits(3), enable => hmu_pipe_en_bits(3), flush_prev => pipe_flush_out_bits(2),
					lm_sm_bit_in => pipe_lm_sm_bits_out(2),
					flush_out => pipe_flush_out_bits(3), lm_sm_bit_out => pipe_lm_sm_bits_out(3),
					--------- CS in -------
					CS3_in(0) => ex_mux_rfd, CS3_in(1) => ex_mux_z2,
					CS3_in(2) => ex_wr_mem, CS3_in(3) => ex_wr_rf,
					CS3_in(4) => ex_dest_cycle, CS3_in(5) => ex_valid_dest,
					CS3_in(6) => fu_mux_memd,
					--------- CS out ------
					CS3_out(0) => ma_mux_rfd, CS3_out(1) => ma_mux_z2,
					CS3_out(2) => ma_wr_mem, CS3_out(3) => ma_wr_rf,
					CS3_out(4) => ma_dest_cycle, CS3_out(5) => ma_valid_dest,
					CS3_out(6) => fu_ma_mux_memd
					);
		
----------------------------------------------MA Stage---------------------------------------------
	comparator1: comp1
		port map(mem_out => dmem_out,
					comp1 => comp1_out);
	
	flagunit: flag_unit 
		port map(IR => ma_ir,
					c_2 => c_2_out,
					z_2 => z_2_out,
					wr_rf_in => ma_wr_rf,
					flush_bit_flag_unit=> pipe_flush_out_bits(3),
					p5_a3 => rw_a3_out,
					en_c2 => flag_unit_en_c2,
					en_z2 => flag_unit_en_z2,
					wr_rf => flag_unit_rf
					);
				
	dram:	d_memory
		generic map(16)
		port map(dmem_d => ma_mux_memd_out,
					dmem_a => ma_ao_out,
					dmem_out => dmem_out,
					clk => clk,
					wr_dmem => ma_wr_mem_mux_out
					);
	
	flagreg: flag_reg
		port map(en_carry => flag_unit_en_c2,
					en_zero => flag_unit_en_z2,
					clk => clk,
					reset => reset,
					op_code => ma_ir(15 downto 12),
					carry_in => ma_cz_out(1),
					zero_in =>	ma_cz_out(0),
					carry_flag => c_2_out,
					zero_flag => z_2_out,
					comp1 => comp1_out
					);

	
	static_mux_rfd: mux_2to1_nbits
		generic map(16)
		port map(s0 => ma_mux_rfd, input0 => dmem_out, input1 => ma_ao_out, output => ma_mux_rfd_out);
		
	dynamic_mux_memd: mux_2to1_nbits
		generic map(16)
		port map(s0 => fu_ma_mux_memd, input0 => ma_dr_out, input1 => rw_rfd_out, output => ma_mux_memd_out);
	
	dynamic_wr_mem_mux: mux_2to1
		port map(s => ma_wr_mem_mux, input0 => ma_wr_mem, input1 => '0', output => ma_wr_mem_mux_out);
	
	pipe5: MA_WB 
		generic map(3)
		port map(PC_in => ma_ir,
					A3_in => ma_a3_out,
					RFD_in => ma_mux_rfd_out,
					----------out----------
					PC_out => rw_pc_out,
					RFD_out => rw_rfd_out,
					A3_out => rw_a3_out,
					------------------------
					clk => clk, flush => hmu_flush_bits(4), enable => hmu_pipe_en_bits(4), flush_prev => pipe_flush_out_bits(3),
					lm_sm_bit_in => pipe_lm_sm_bits_out(3),
					flush_out => pipe_flush_out_bits(4), lm_sm_bit_out => pipe_lm_sm_bits_out(4),
					----------CS in ----------
					CS4_in(0) => flag_unit_rf, CS4_in(1) => ma_dest_cycle, CS4_in(2) => ma_valid_dest,
					----------CS out ----------
					CS4_out(0) => rw_wr_rf, CS4_out(1) => rw_dest_cycle, CS4_out(2) => rw_valid_dest
					);

----------------------------------------------RW Stage---------------------------------------------
		
end architecture ; -- behave
