library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package basic is
---------------------------------------------------------------------------------------------------------
	component mux_2to1 is  -----checked
	port(
		s, input0, input1 : in std_logic;
		output : out std_logic);
	end component;
---------------------------------------------------------------------------------------------------------
	component mux_2to1_nbits is -----checked
		generic ( nbits : integer);
		port(
			s0 : in std_logic;
			input0, input1 : in std_logic_vector(nbits-1 downto 0);
			output : out std_logic_vector(nbits-1 downto 0));
	end component;
---------------------------------------------------------------------------------------------------------
	component mux_4to1 is -----checked
	port(
		s0, s1, input0, input1, input2, input3 : in std_logic;
		output : out std_logic);
	end component;
---------------------------------------------------------------------------------------------------------
	component mux_4to1_nbits is -----checked
	generic ( nbits : integer);
	port(
		s0, s1 : in std_logic;
		input0, input1, input2, input3 : in std_logic_vector(nbits-1 downto 0);
		output : out std_logic_vector(nbits-1 downto 0));
	end component;

---------------------------------------------------------------------------------------------------------
	component sign_extend is -----checked
		generic(input_width: integer := 6;
			output_width: integer := 16);
		port(
			input: in std_logic_vector(input_width-1 downto 0);
			output: out std_logic_vector(output_width-1 downto 0));
	end component;
---------------------------------------------------------------------------------------------------------
	component nor_box is
		generic(input_width: integer := 16);
		port(
			input: in std_logic_vector(input_width-1 downto 0);
			output: out std_logic);
	end component;
---------------------------------------------------------------------------------------------------------
	component unsigned_comparator is
	  	generic (nbits : integer);
	  	port (
	    		a      : in  std_logic_vector(nbits-1 downto 0);
	    		b      : in  std_logic_vector(nbits-1 downto 0);
	    		a_lt_b : out std_logic;
	    		a_eq_b : out std_logic;
	    		a_gt_b : out std_logic);
	end component;
---------------------------------------------------------------------------------------------------------
	component left7_shifter is
		generic(input_width: integer := 9;
			output_width: integer := 16);
		port(
			input: in std_logic_vector(input_width-1 downto 0);
			output: out std_logic_vector(output_width-1 downto 0));
	end component;
---------------------------------------------------------------------------------------------------------
	component alu is
	 	Port (
		 inp1 : in std_logic_vector(15 downto 0);
		 inp2 : in std_logic_vector(15 downto 0);
		 op_sel : in std_logic;
		 output : out std_logic_vector(15 downto 0);
		 c : out std_logic;
		 z : out std_logic);
	end component;
---------------------------------------------------------------------------------------------------------
	component dregister is
	  	generic (nbits : integer:=16);                    -- no. of bits
	  	port (
	    		reset: in std_logic;
	   		 din  : in  std_logic_vector(nbits-1 downto 0);
	    		dout : out std_logic_vector(nbits-1 downto 0);
	    		enable: in std_logic;
	    		clk     : in  std_logic);
	end component;
---------------------------------------------------------------------------------------------------------
	component dflipflop is
	  port (
	    reset: in std_logic;
	    din  : in  std_logic;
	    dout : out std_logic;
	    enable: in std_logic;
	    clk     : in  std_logic);
	end component;
---------------------------------------------------------------------------------------------------------
	component register_file is
	    port
	    ( d1,d2       : out std_logic_vector(15 downto 0);
	      d3          : in  std_logic_vector(15 downto 0);
	      write_en : in  std_logic;
	      read_en  : in  std_logic;
	      reset    : in  std_logic;
	      a1,a2,a3    : in  std_logic_vector(2 downto 0);
	      clk         : in  std_logic );
	end component;
---------------------------------------------------------------------------------------------------------
	component memory is
	   port ( mem_a,mem_d: in std_logic_vector(15 downto 0);
		  mem_out: out std_logic_vector(15 downto 0);
	 	 clk,wr_mem,rd_mem: in std_logic);
	end component;
---------------------------------------------------------------------------------------------------------
	component PriorityEncoder is
	port(
		input : in std_logic_vector(7 downto 0);
		output : out std_logic_vector(2 downto 0);
		invalid : out std_logic
	       );
	end component;
---------------------------------------------------------------------------------------------------------
	component PE_decoder is
		port(
			input : in std_logic_vector(2 downto 0);
			output : out std_logic_vector(7 downto 0)
		);
	end component;
---------------------------------------------------------------------------------------------------------
	component instruction_register is
	     port(
		    din     : in std_logic_vector(15 downto 0);
		    din_low : in std_logic_vector(7 downto 0);
		    en_ir   : in std_logic;
		    en_ir_low : in std_logic;
		    clk,reset : in std_logic;
		    dout: out std_logic_vector(15 downto 0)
		 );
	end component;
---------------------------------------------------------------------------------------------------------
	component controlpath is
	port(  -----mux signals-----------------
		m_mem_a       : out std_logic;
		m_mem_a_1     : out std_logic;
		m_A           : out std_logic;
		m_a1_01       : out std_logic;
		m_a1_0,m_a1_1 : out std_logic;
		m_a3_00       : out std_logic;
		m_a3_0,m_a3_1 : out std_logic;
		m_d3_0,m_d3_1 : out std_logic;
		m_b_00_10     : out std_logic;
		m_b_0,m_b_1   : out std_logic;
		m_z           : out std_logic;
		m_op2	      : out std_logic;
		wr_mem        : out std_logic;   --write on memory
		rd_mem        : out std_logic;   --read memory
		wr_rf         : out std_logic;   --write on register file
		-----enable---------------------
		en_ir         : out std_logic;  --enable instruction register
		en_ir_low     : out std_logic;	--enable of last 8bits of IR used as register for LM/SM
		en_a,en_b     : out std_logic;   --enable of input registers to alu
		en_c,en_z     : out std_logic;
		op_sel        : out std_logic;   --operation select by alu
		condition_code: in std_logic_vector(1 downto 0);    --last 2 bits of IR
		equ      : in std_logic;  --comparator
		C,Z      : in std_logic;  --carry,zero
		pe_done  : in std_logic;  --multiple load,store done
		op_code  : in std_logic_vector(3 downto 0);  --first 4 bits of IR which is op_code

		clk,reset: in std_logic
	    );
	end component;
---------------------------------------------------------------------------------------------------------
	component datapath is
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
		condition_code: out std_logic_vector(1 downto 0);    --last 2 bits of IR

		clk,reset: in std_logic
	    );
	end component;
---------------------------------------------------------------------------------------------------------
end package;
