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
	component full1bit_adder is
		port (cin, x, y   :in std_logic;
		      sum, cout   :out std_logic
		);
	end component;
---------------------------------------------------------------------------------------------------------
	component n_adder is
		generic (n_bits : positive range 2 to positive'right := 16);

		port(op1,op2 : in std_logic_vector(n_bits-1 downto 0);
			sum  : out std_logic_vector(n_bits-1 downto 0);
			cz : out std_logic);
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
	component counter is
		port(	clk,reset,enable: in std_logic;
			overflow: out std_logic;
			A : out std_logic_vector(2 downto 0));
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
end package;
