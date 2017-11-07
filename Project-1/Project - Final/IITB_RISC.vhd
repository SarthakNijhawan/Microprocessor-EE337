library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library work;
use work.basic.all;

entity IITB_RISC is
	port(clk,reset: in std_logic;
			clock_50: in bit);
end entity;

architecture behave of IITB_RISC is
	signal	m_mem_a       :   std_logic;
	signal	m_mem_a_1     :   std_logic;
	signal	m_A           :   std_logic;
	signal	m_a1_01       :   std_logic;
	signal	m_a1_0,m_a1_1 :   std_logic;
	signal	m_a3_00       :   std_logic;
	signal	m_a3_0,m_a3_1 :   std_logic;
	signal	m_d3_0,m_d3_1 :   std_logic;
	signal	m_b_00_10     :   std_logic;
	signal	m_b_0,m_b_1   :   std_logic;
	signal	m_z           :   std_logic;
	signal	m_op2	        :   std_logic;
	signal	wr_mem        :   std_logic;   --write on memory
	signal	rd_mem        :   std_logic;   --read memory
	signal	wr_rf         :   std_logic;   --write on register file
	signal   m_a1			  :  std_logic;
	signal   m_op1         :  std_logic;
	-----enable---------------------
	signal	en_ir         :   std_logic;  --enable instruction register
	signal	en_ir_low     :   std_logic;	--enable of last 8bits of IR used as register for LM/SM
	signal	en_a,en_b     :   std_logic;   --enable of input registers to alu
	signal	en_c,en_z     :   std_logic;
	signal	op_sel        :   std_logic;   --operation select by alu
	signal	condition_code:  std_logic_vector(1 downto 0);    --last 2 bits of IR
	signal	equ      :  std_logic;  --comparator
	signal	C,Z      :  std_logic;  --carry,zero
	signal	pe_done  :  std_logic;  --multiple load,store done
	signal	op_code  :  std_logic_vector(3 downto 0);  --first 4 bits of IR which is op_code
begin
	datapath_risc : datapath
			port map(
		m_mem_a	       => m_mem_a,
		m_mem_a_1      => m_mem_a_1,
		m_A            => m_A,
		m_a1_01        => m_a1_01,
		m_a1_0         => m_a1_0,
		m_a1_1	       => m_a1_1,
		m_a3_00        => m_a3_00,
		m_a3_0         => m_a3_0,
		m_a3_1 	       => m_a3_1,
		m_d3_0         => m_d3_0,
		m_d3_1 	       => m_d3_1,
		m_b_00_10      => m_b_00_10,
		m_b_0          => m_b_0,
		m_b_1          => m_b_1,
		m_z            => m_z,
		m_op2	       => m_op2,
		m_a1           => m_a1,
		m_op1          => m_op1,
		wr_mem         => wr_mem,  
		rd_mem         => rd_mem,  
		wr_rf          => wr_rf,   
		en_ir          => en_ir,   
		en_ir_low      => en_ir_low, 
		en_a           => en_a,
		en_b           => en_b,   
		en_c           => en_c,
		en_z           => en_z,
		op_sel         => op_sel,   
		equ            => equ,    
		C              => C,
		Z              => Z, 
		pe_done        => pe_done,  
		op_code        => op_code,
		condition_code => condition_code,
		clk            => clk,
		reset          => reset
	    );
	
	controlpath_risc : controlpath
			port map(
		m_mem_a	       => m_mem_a,
		m_mem_a_1      => m_mem_a_1,
		m_A            => m_A,
		m_a1_01        => m_a1_01,
		m_a1_0         => m_a1_0,
		m_a1_1	       => m_a1_1,
		m_a3_00        => m_a3_00,
		m_a3_0         => m_a3_0,
		m_a3_1 	       => m_a3_1,
		m_d3_0         => m_d3_0,
		m_d3_1 	       => m_d3_1,
		m_b_00_10      => m_b_00_10,
		m_b_0          => m_b_0,
		m_b_1          => m_b_1,
		m_z            => m_z,
		m_op2	       => m_op2,
		m_a1           => m_a1,
		m_op1          => m_op1,
		wr_mem         => wr_mem,  
		rd_mem         => rd_mem,  
		wr_rf          => wr_rf,   
		en_ir          => en_ir,   
		en_ir_low      => en_ir_low, 
		en_a           => en_a,
		en_b           => en_b,   
		en_c           => en_c,
		en_z           => en_z,
		op_sel         => op_sel,   
		equ            => equ,    
		C              => C,
		Z              => Z, 
		pe_done        => pe_done,  
		op_code        => op_code,
		condition_code => condition_code,
		clk            => clk,
		reset          => reset
	    );
end behave;
