library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library work;
use work.basic.all;

entity datapath is
	port(  -----mux signals-----------------
		m_mem_a       : in std_logic;
		m_mem_a_1     : in std_logic; 
		m_A           : in std_logic;  
		m_a1_01       : in std_logic;
		m_a1_0,m_a1_1 : in std_logic;
		m_a3_00       : in std_logic;
		m_a3_0,m_a3_1 : in std_logic;
		m_d3_0,m_d3_1 : in std_logic;
		m_b_00_10     : in std_logic;
		m_b_0,m_b_1   : in std_logic;
		m_z           : in std_logic;
		m_op2	      : in std_logic;
		wr_mem        : in std_logic;   --write on memory
		rd_mem        : in std_logic;   --read memory
		wr_rf         : in std_logic;   --write on register file
		-----enable---------------------
		en_ir         : in std_logic;   --enable instruction register
		en_ir_low     : in std_logic;	--enable of last 8bits of IR used as register for LM/SM 
		en_a,en_b     : in std_logic;   --enable of input registers to alu
		en_c,en_z     : in std_logic;
		-----------------------------------------------------------------------------en_counter,rst_counter: in std_logic;
		op_sel        : in std_logic;   --operation select by alu

		equ      : out std_logic;  --comparator
		C,Z      : out std_logic;  --carry,zero
		-----------------------------------------------------------------------------ov_flag  : out std_logic;  --overflow flag
		pe_done  : out std_logic;  --multiple load,store done
		-----------------------------------------------------------------------------load     : out std_logic;
		op_code  : out std_logic_vector(3 downto 0);  --first 4 bits of IR which is op_code

		clk,reset: in std_logic
	    );
end entity;

architecture behave of datapath is
	signal mem_a,mem_out   : std_logic_vector(15 downto 0);
	signal mem_a_1         : std_logic_vector(15 downto 0);
	signal op1,op2         : std_logic_vector(15 downto 0);
	signal D1,D2,D3        : std_logic_vector(15 downto 0);	
	signal A1,A3           : std_logic_vector(2 downto 0);
	signal ir              : std_logic_vector(15 downto 0);
	signal a1_01,a3_00     : std_logic_vector(2 downto 0);
	signal b_00,b_10       : std_logic_vector(15 downto 0);
	signal A_in,B_in,B_out : std_logic_vector(15 downto 0);
	signal pe_out          : std_logic_vector(2 downto 0);
	signal pe_decoder_out  : std_logic_vector(7 downto 0);
	signal alu_out         : std_logic_vector(15 downto 0);
	signal shift_out       : std_logic_vector(15 downto 0);
	signal se6_out,se9_out : std_logic_vector(15 downto 0);
	signal less,greater    : std_logic; 
	signal z_0,z_1         : std_logic; 
	signal cin,zin         : std_logic;
	signal ir_low          : std_logic_vector(7 downto 0);

begin
-------------------------------------------------------------------------------------------------------
	RAM: memory
		port map(mem_a => mem_a, mem_d => D1, mem_out => mem_out, clk => clk, wr_mem => wr_mem, rd_mem => rd_mem);
------------------------------------------
	Inst_reg: instruction_register
		port map(din => mem_out, din_low => ir_low, en_ir => en_ir, en_ir_low => en_ir_low,
			 reset => reset, clk => clk, dout => ir);
	op_code <= ir(15 downto 12);     --to control path for instruction decoder
--------------------------------------------
	mux_a1_01: mux_2to1_nbits
		generic map(3)
		port map(s0 => m_a1_01, input0 => ir(11 downto 9), input1 => ir(8 downto 6), output => a1_01);
--------------------------------------------
	mux_a3_00: mux_2to1_nbits
		generic map(3)
		port map(s0 => m_a3_00, input0 => ir(8 downto 6), input1 => ir(5 downto 3), output => a3_00);
--------------------------------------------
	mux_a1: mux_4to1_nbits
		generic map(3)
		port map(s0 => m_a1_0, s1 => m_a1_1,
		         input0 => ir(11 downto 9), input1 => a1_01, input2 => pe_out, input3 => "111", output => A1);
--------------------------------------------
	mux_a3: mux_4to1_nbits
		generic map(3)
		port map(s0 => m_a3_0, s1 => m_a3_1,
		         input0 => a3_00, input1 => pe_out, input2 => ir(11 downto 9), input3 => "111", output => A3);
--------------------------------------------
	mux_d3: mux_4to1_nbits
		generic map(16)
		port map(s0 => m_d3_0, s1 => m_d3_1,
		         input0 => alu_out, input1 => "0000000000000000", input2 => shift_out, input3 => mem_out, output => D3);
--------------------------------------------
	mux_A: mux_2to1_nbits
		generic map(16)
		port map(s0 => m_A, input0 => D1, input1 => alu_out, output => A_in);
--------------------------------------------
	mux_b_00: mux_2to1_nbits
		generic map(16)
		port map(s0 => m_b_00_10, input0 => D2, input1 => se6_out, output => b_00);
--------------------------------------------
	mux_b_10: mux_2to1_nbits
		generic map(16)
		port map(s0 => m_b_00_10, input0 => se9_out, input1 => se6_out, output => b_10);
--------------------------------------------
	mux_B: mux_4to1_nbits
		generic map(16)
		port map(s0 => m_b_0, s1 => m_b_1,
		         input0 => b_00, input1 => se6_out, input2 => b_10, input3 => "0000000000000000", output => B_in);
--------------------------------------------
	mux_op2: mux_2to1_nbits
		generic map(16)
		port map(s0 => m_op2, input0 => B_out, input1 => "0000000000000001", output => op2);
--------------------------------------------
	mux_mem_a_1: mux_2to1_nbits
		generic map(16)
		port map(s0 => m_mem_a_1, input0 => op1, input1 => alu_out, output => mem_a_1);
--------------------------------------------
	mux_mem_a: mux_2to1_nbits
		generic map(16)
		port map(s0 => m_mem_a, input0 => D1, input1 => mem_a_1, output => mem_a);
--------------------------------------------
	shifter: left7_shifter
		generic map(input_width => 9, output_width => 16)
		port map (input => ir(8 downto 0), output => shift_out);
--------------------------------------------
	se6: sign_extend
		generic map(input_width => 6, output_width => 16)
		port map (input => ir(5 downto 0), output => se6_out);
--------------------------------------------
	se9: sign_extend
		generic map(input_width => 9, output_width => 16)
		port map (input => ir(8 downto 0), output => se9_out);
--------------------------------------------
	regA: dregister
		generic map(16)
		port map(reset => reset, din => A_in, dout => op1, enable => en_A, clk => clk);
--------------------------------------------
	regB: dregister
		generic map(16)
		port map(reset => reset, din => B_in, dout => B_out, enable => en_B, clk => clk);
--------------------------------------------
	nanding: nand_box
		generic map(16)
		port map(input => mem_out, output => z_1);
--------------------------------------------
	compare: unsigned_comparator
		generic map(16)
		port map(a => D1, b => D2, a_lt_b => less, a_eq_b => equ, a_gt_b => greater);
--------------------------------------------
	carryFF: dff
		port map(reset => reset, din => cin, dout => C, enable => en_c, clk => clk);
--------------------------------------------
	mux_z: mux_2to1
		port map(s => m_z, input0 => z_0, input1 => z_1, output => zin);
--------------------------------------------
	zeroFF: dff
		port map(reset => reset, din => zin, dout => Z, enable => en_z, clk => clk);
--------------------------------------------
	alu_unit: alu
		port map(inp1 => op1, inp2 => op2, op_sel => op_sel, output => alu_out, c => cin, z => z_0);
--------------------------------------------
	RF: register_file
		port map(d1 => D1, d2 => D2, d3 => D3, write_en => wr_rf, read_en => '1',
			 a1 => A1, a2 => ir(8 downto 6), a3 => A3, clk => clk);
--------------------------------------------
	pe: PriorityEncoder
		port map(input => ir(7 downto 0), output => pe_out, invalid => pe_done);
--------------------------------------------
	pedecoder: PE_decoder                                          
		port map(input => pe_out, output => pe_decoder_out);
--------------------------------------------
	ir_low <= pe_decoder_out and ir(7 downto 0);  ---logic for load/store multiple
--------------------------------------------

end behave;
		 
		 




