library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library work;
use work.basic.all;

entity controlpath is
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
end entity;

architecture behave of controlpath is
	type state is ( HKT1, HKT2, AR1, AR2, BEQ, JL1, JL2, LHI, LS, LW, SW, LM, SM);
	signal Q,nQ : state := HKT1;       ---initialised at HKT1
begin
	m_b_00_10 <= op_code(0);        ---static bit
	m_a3_00   <= op_code(0);	---static bit
	m_a1_01   <= op_code(1);	---static bit

	delay: process(clk)
	begin
		if(clk='1' and clk'event) then
			Q <= nQ;           ---state is changed at rising edge
		end if;
	end process delay;

	main: process(clk,Q,reset)
	begin
		if reset='1' then
			nQ <= HKT1;
		else
			case Q is
				when HKT1 =>
					en_z    <= '0';
					en_c    <= '0';
					m_A     <= '0';
					en_a    <= '1';
					en_b    <= '0';
					wr_rf   <= '0';
					m_a1_0  <= '1';
					m_a1_1  <= '1';
					en_ir   <= '1';
					wr_mem  <= '0';
					rd_mem  <= '1';
					m_mem_a <= '0';
		-------------Next State Logic-----------------
		if(op_code(3 downto 0) = "0011") then nQ <= LHI;
		elsif(op_code(3 downto 2) = "01") then nQ <= LS;
		elsif(op_code(3 downto 2) = "11") then nQ <= BEQ;
		elsif(op_code(3 downto 2) = "10") then nQ <= JL1;
		elsif((condition_code(1 downto 0) = "01" and Z = '0') or (condition_code(1 downto 0) = "10" and C = '0')) then nQ <= HKT2;
		else nQ <= AR1;
		end if;
					
				when HKT2 =>
					op_sel  <= '0';  --ADD operation in ALU
					en_z    <= '0';
					en_c    <= '0';
					en_a    <= '0';
					en_b    <= '0';
					m_op2   <= '1';
					m_d3_0  <= '0';
					m_d3_1  <= '0';
					wr_rf   <= '1';
					m_a3_0  <= '1';
					m_a3_1  <= '1';
					en_ir   <= '0';
					wr_mem  <= '0';
					rd_mem  <= '0';
					en_ir_low <= '0';
					-------------Next State Logic-----------------
					nQ <= HKT1;

				when AR1 =>
					op_sel    <= '0';
					en_z      <= '0';
					en_c      <= '0';
					m_A       <= '0';
					en_a      <= '1';
					en_b      <= '1';
					m_b_0     <= '0';
					m_b_1     <= '0';
					m_op2     <= '1';
					m_d3_0    <= '0';
					m_d3_1    <= '0';
					wr_rf     <= '1';
					m_a3_0    <= '1';
					m_a3_1    <= '1';
					m_a1_0    <= '0';
					m_a1_1    <= '0';
					en_ir     <= '0';
					wr_mem    <= '0';
					rd_mem    <= '0';
					en_ir_low <= '0';
					-------------Next State Logic-----------------
					nQ <= AR2;

				when AR2 =>
					op_sel    <= op_code(1);  -------DECODER LOGIC
					en_z      <= '1';
					en_c      <= '1';
					m_z       <= '0';
					en_a      <= '0';
					en_b      <= '0';
					m_op2     <= '0';
					m_d3_0    <= '0';
					m_d3_1    <= '0';
					wr_rf     <= '1';
					m_a3_0    <= '0';
					m_a3_1    <= '0';
					en_ir     <= '0';
					wr_mem    <= '0';
					rd_mem    <= '0';
					en_ir_low <= '0';
					-------------Next State Logic-----------------
					nQ <= HKT1;

				when BEQ =>
					en_z      <= '0';
					en_c      <= '0';
					en_a      <= '0';
					en_b      <= '1';
					m_b_0     <= '0';
					m_b_1     <= '1';
					wr_rf     <= '0';
					m_a1_0    <= '0';
					m_a1_1    <= '0';
					en_ir     <= '0';
					wr_mem    <= '0';
					rd_mem    <= '0';
					en_ir_low <= '0';
					-------------Next State Logic-----------------
					case equ is
						when '0' => nQ <= JL2;
						when others => nQ <= HKT2;
					end case;
					--nQ <= JL2 when equ = '1' else
					--			HKT2 when equ = '0';

				when JL1 =>
					op_sel    <= '0';
					en_z      <= '0';
					en_c      <= '0';
					en_a      <= '0';
					en_b      <= '1';
					m_b_0     <= '1';
					m_b_1     <= '0';
					m_op2     <= '1';
					m_d3_0    <= '0';
					m_d3_1    <= '0';
					wr_rf     <= '1';
					m_a3_0    <= '0';
					m_a3_1    <= '0';
					en_ir     <= '0';
					wr_mem    <= '0';
					rd_mem    <= '0';
					en_ir_low <= '0';
					-------------Next State Logic-----------------
					nQ <= JL2;

				when JL2 =>
					op_sel    <= '0';
					en_z      <= '0';
					en_c      <= '0';
					en_a      <= '0';
					en_b      <= '0';
					m_op2     <= '0';
					m_d3_0    <= '0';
					m_d3_1    <= '0';
					wr_rf     <= '1';
					m_a3_0    <= '1';
					m_a3_1    <= '1';
					en_ir     <= '0';
					wr_mem    <= '0';
					rd_mem    <= '0';
					en_ir_low <= '0';
					-------------Next State Logic-----------------
					nQ <= HKT1;

				when LHI =>
					en_z      <= '0';
					en_c      <= '0';
					en_a      <= '0';
					en_b      <= '0';
					m_d3_0    <= '1';
					m_d3_1    <= '0';
					wr_rf     <= '1';
					m_a3_0    <= '0';
					m_a3_1    <= '0';
					en_ir     <= '0';
					wr_mem    <= '0';
					rd_mem    <= '0';
					en_ir_low <= '0';
					-------------Next State Logic-----------------
					nQ <= HKT2;

				when LS =>
					op_sel    <= '0';
					en_z      <= '0';
					en_c      <= '0';
					m_A       <= '0';
					en_a      <= '1';
					en_b      <= '1';
					m_b_0     <= '0';
					m_b_1     <= '1';
					m_op2     <= '1';
					m_d3_0    <= '0';
					m_d3_1    <= '0';
					wr_rf     <= '1';
					m_a3_0    <= '1';
					m_a3_1    <= '1';
					m_a1_0    <= '0';
					m_a1_1    <= '1';
					en_ir     <= '0';
					wr_mem    <= '0';
					rd_mem    <= '0';
					en_ir_low <= '0';
					-------------Next State Logic-----------------
					if(op_code(1 downto 0) = "00") then nQ <= LW;
						elsif(op_code(1 downto 0) = "01") then nQ <= SW;
							elsif(pe_done = '1') then nQ <= HKT2;
								elsif(op_code(1 downto 0) = "10") then nQ <= LM;
									elsif(op_code(1 downto 0) = "11") then nQ <= SM;
					end if;

				when LW =>
					op_sel    <= '0';
					en_z      <= '1';
					en_c      <= '0';
					m_z				<= '1';
					m_mem_a_1	<= '1';
					en_a      <= '0';
					en_b      <= '0';
					m_op2     <= '0';
					m_d3_0    <= '1';
					m_d3_1    <= '1';
					wr_rf     <= '1';
					m_a3_0    <= '1';
					m_a3_1    <= '0';
					en_ir     <= '0';
					wr_mem    <= '0';
					rd_mem    <= '1';
					m_mem_a		<= '1';
					en_ir_low <= '0';
					-------------Next State Logic-----------------
					nQ <= HKT1;

				when SW =>
					op_sel    <= '0';
					en_z      <= '0';
					en_c      <= '0';
					m_mem_a_1	<= '1';
					en_a      <= '0';
					en_b      <= '0';
					m_op2     <= '0';
					wr_rf     <= '0';
					m_a1_0    <= '0';
					m_a1_1    <= '0';
					en_ir     <= '0';
					wr_mem    <= '1';
					rd_mem    <= '0';
					m_mem_a		<= '1';
					en_ir_low <= '0';
					-------------Next State Logic-----------------
					nQ <= HKT1;

				when LM =>
					op_sel    <= '0';
					en_z      <= '0';
					en_c      <= '0';
					m_mem_a_1	<= '0';
					m_A       <= '1';
					en_a      <= '1';
					en_b      <= '0';
					m_op2     <= '1';
					m_d3_0    <= '1';
					m_d3_1    <= '1';
					wr_rf     <= '1';
					m_a3_0    <= '0';
					m_a3_1    <= '1';
					en_ir     <= '0';
					wr_mem    <= '0';
					rd_mem    <= '1';
					m_mem_a		<= '1';
					en_ir_low <= '1';
					-------------Next State Logic-----------------
					case pe_done is
						when '0' => nQ <= LM;
						when others => nQ <= HKT2;
					end case;
					--nQ <= HKT2 when pe_done = '1' else
					--			LM when pe_done = '0';

				when SM =>
					op_sel    <= '0';
					en_z      <= '0';
					en_c      <= '0';
					m_mem_a_1	<= '0';
					m_A       <= '1';
					en_a      <= '1';
					en_b      <= '0';
					m_op2     <= '1';
					wr_rf     <= '0';
					m_a1_0    <= '1';
					m_a1_1    <= '0';
					en_ir     <= '0';
					wr_mem    <= '1';
					rd_mem    <= '0';
					m_mem_a		<= '1';
					en_ir_low <= '1';
					-------------Next State Logic-----------------
					case pe_done is
						when '0' => nQ <= SM;
						when others => nQ <= HKT2;
					end case;
					--nQ <= HKT2 when pe_done = '1' else
					--			SM when pe_done = '0';
			end case;
		end if;
		end process;
end behave;


