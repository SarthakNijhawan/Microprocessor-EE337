-- List of all components for Datapath
-- Instruction RAM	*
-- Instruction Decoder
-- Sign Extender 6	*
-- Sign Extender 9	*
-- Padder		*
-- Adder			*
-- Data Register *
-- Multiplexer Generic (16 bit) *
-- Register File	*
-- Forwarding  Logic	*
-- ALU				*
-- Data RAM			*
-- Register Generic *
-- Address Block	*

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;
--======================
package components is
--======================
TYPE matrix16 IS ARRAY (NATURAL RANGE <>) OF std_logic_vector(15 downto 0);
TYPE matrix3 IS ARRAY (NATURAL RANGE <>) OF std_logic_vector(2 downto 0);
TYPE matrix8 IS ARRAY (NATURAL RANGE <>) OF std_logic_vector(7 downto 0);
type AddressOutType_bit is array(0 to 7) of bit_vector(15 downto 0);
--type matrix16(7 downto 0)_bit is array(0 to 7) of bit_vector(15 downto 0);
type dramCtrl is Record
		mem_ctr : std_logic_vector(7 downto 0);
		pathway : std_logic;
		writeEN : std_logic;
		load_mem : std_logic;
	 end Record;
type RegFileCtrl is Record
	 		a3rf :  std_logic_vector(2 downto 0);
	 		path_decider :  std_logic;
	 		rf_write:  std_logic;
	 		r7_write :  std_logic;
	 		logic_in :  std_logic_vector(7 downto 0);
			CarryEn: std_logic;
	  	zeroEN: std_logic;
	 	end record;
component DataRegister is
	generic (data_width:integer);
	port (Din: in std_logic_vector(data_width-1 downto 0):=(others => '0');
	      Dout: out std_logic_vector(data_width-1 downto 0):=(others => '0');
	      clk: in std_logic :='0';
			enable: in std_logic := '0'
		  );
end component;

component padder is
port ( I : in std_logic_vector(8 downto 0);
		 O : out std_logic_vector(15 downto 0));
end component;

component SignExtend_9 is
port( 	--- Input
		IN_9:in std_logic_vector(9 downto 1);
		OUT_16: out std_logic_vector(16 downto 1)
		);
end component;

component SignExtend_6 is
port( 	--- Input
		IN_6:in std_logic_vector(6 downto 1);
		OUT_16: out std_logic_vector(16 downto 1)
		);
end component;


component Add_1 is
port(
	I: in std_logic_vector(15 downto 0);
	O: out std_logic_vector(15 downto 0)
	);
end component;


component regfile is port(
done : out std_logic;
clk : in std_logic;
logic_in : in std_logic_vector(7 downto 0);
Din_rf: in matrix16(7 downto 0);
Dout_rf: out matrix16(7 downto 0);
a3rf : in std_logic_vector(2 downto 0);
d3rf : in std_logic_vector(15 downto 0);
d4rf : in std_logic_vector(15 downto 0);
path_decider : in std_logic;
rf_write: in std_logic;
pc_write : in std_logic
	);
end component;

component iROM is
  port (
	clock   : in  std_logic;
	load_mem: in std_logic;
	mem_loaded : out std_logic;
	address : in  std_logic_vector(15 downto 0);
	dataout : out std_logic_vector(15 downto 0)
  );
end component;

component dRAM is
  port (
	clock   : in  std_logic;
	mem_ctr : in std_logic_vector(7 downto 0);
	Din_mem: in matrix16(7 downto 0);
	Dout_mem: out matrix16(7 downto 0);
	Addr_mem: in matrix16(7 downto 0);
	pathway: in std_logic;
	writeEN: in std_logic;
	load_mem: in std_logic;
	mem_loaded: out std_logic;
	ai_mem: in std_logic_vector(15 downto 0);
	di_mem: in std_logic_vector(15 downto 0);
	do_mem: out std_logic_vector(15 downto 0)
  );
end component;

component AddressBlock is
port(
	Ain: in std_logic_vector(15 downto 0);
	Sel: in std_logic_vector(7 downto 0);
	Aout: out matrix16(7 downto 0));
end component;

component GenericMux is

        generic (dataWidth : positive := 16;
						seln: positive := 2);
        port (  I : in matrix16(2**seln - 1 downto 0);
                S : in std_logic_vector(seln - 1 downto 0);
                O : out std_logic_vector(dataWidth - 1 downto 0));
end component;

component Adder is
port(
	I1,I2: in std_logic_vector(15 downto 0);
	O: out std_logic_vector(15 downto 0)
	);
end component;
component FwdCntrl is
port (
padder:       in matrix16(2 downto 0);       -- 0 - execute  1 - mem -- 2- for writeback for all
PC_1:         in matrix16(2 downto 0);
aluop:        in matrix16(2 downto 0);    -- alu output
regDest:      in matrix3(2 downto 0) ;
Iword:        in matrix16(2 downto 0);
Lm_mem:       in matrix16(7 downto 0);  -- mem stage
Lm_wb:        in matrix16(7 downto 0);   -- writeback stage ()
mem_out:      in matrix16(1 downto 0);   -- 0 - mem , 1- writeback (single output)
Lm_sel:       in matrix8(2 downto 0);    --0 - execute , 1- mem, 2- writeback (single output)
regFiledata:  in matrix16(7 downto 0);  -- regFiledata[7] has to be connected to PC brought by the pipeline register
carry :       in std_logic_vector(2 downto 0);   -- 0 - execute  1 - mem -- 2- for writeback
zero:         in std_logic_vector(3 downto 0); -- 0- LW_zero_signal, 1- alu_zero_sig, 2-zero_flag, 3- writeback
regDataout:   out matrix16(7 downto 0);
stallflag:    out std_logic
         ) ;
end component ;

component ALU is
port(
		I1,I2 : in std_logic_vector(15 downto 0);
		O: out std_logic_vector(15 downto 0);
		Sel: in std_logic;
		C,Z: out std_logic);
end component;

component InstructionDecoder is
port(
I16: in std_logic_vector(15 downto 0);
RF: out RegFileCtrl;
DRAM: out dramCtrl;
M1_sel,M6_sel,M7_sel: out std_logic_vector(0 downto 0);
M3_sel: out std_logic_vector(1 downto 0);
M4_sel,M5_sel: out std_logic_vector(2 downto 0);
ALUsel: out std_logic_vector(0 downto 0)
	 );
end component;

component isEqual is
port(I1,I2: in std_logic_vector(15 downto 0);
		O: out std_logic);
end component;

component HazardUnit is
port (
------------------------
lw_out: in std_logic_vector(15 downto 0);
lm_out: in std_logic_vector(15 downto 0);
aluop: in std_logic_vector(15 downto 0);
JLRreg:in std_logic_vector(15 downto 0);
Pc_Im6:in std_logic_vector(15 downto 0);
Pc_Im9:in std_logic_vector(15 downto 0);
padder:in std_logic_vector(15 downto 0);
-------------
stallflag: in std_logic;
Instruction_pipeline: in matrix16(0 to 4); --  0- for IF, 1-ID, 2-RR, 3-EX, 4-MEM
carry_ex: in std_logic;
zero_ex: in std_logic_vector(2 downto 0);  -- 0-LW_zero_sig, 1-ALU_zer_sig, 2-zero_sig
regDest: in matrix3(0 to 3);               -- 0-ID, 1-RR, 2-EX, 3-MEM
Lm_sel_r7: in std_logic;
BEQequal: in std_logic;
PCplus1 : in std_logic_vector(15 downto 0);
Instr_out: out matrix16(0 to 4);
pipeline_enable: out std_logic_vector(0 to 4);  --  0- for IF, 1-ID, 2-RR, 3-EX, 4-MEM
PC_write_en: out std_logic;
PCval: out std_logic_vector(15 downto 0)
         ) ;
end component ;
--===============Pipeline related stuff===============

type IF_ID_type	is Record
	I16, PC, PC_1: std_logic_vector(15 downto 0);
end Record;
type ID_RR_type	is Record
	-- data to be forwarded
	I16, PC, PC_1, SE6, Padder, PC_Imm6: std_logic_vector(15 downto 0);
	-- contols to be forwarded
	RF:  RegFileCtrl; -- A3 included here -- to be taken untill WB stage
	DRAM: dramCtrl;
	ALUsel: std_logic;
	M6_sel,M7_sel: std_logic_vector(0 downto 0);
	M3_sel: std_logic_vector(1 downto 0);
	M4_sel,M5_sel: std_logic_vector(2 downto 0);
end Record;
type RR_EX_type is Record
	-- data to be forwarded
	I16, PC_1, SE6, Padder, D1, D2: std_logic_vector(15 downto 0);
	D_multiple: matrix16(7 downto 0);
	-- controls to be forwarded
	ALUsel: std_logic;
	RF:  RegFileCtrl; -- A3 included here -- to be taken untill WB stage
	DRAM:  dramCtrl;
	M6_sel, M7_sel: std_logic_vector(0 downto 0);
	M3_sel: std_logic_vector(1 downto 0);
end Record;
type EX_MEM_type is Record
	-- data to be forwarded
	I16, PC_1, Padder, ALU_OUT, D1: std_logic_vector(15 downto 0);
	C_old, Z_old: std_logic;
	-- controls to be forwarded
	RF:  RegFileCtrl; -- A3 included here -- to be taken untill WB stage
	DRAM:  dramCtrl;
	D_multiple, A_multiple: matrix16(7 downto 0);
	M3_sel: std_logic_vector(1 downto 0);
end Record;
type MEM_WB_type is Record
	-- data to be forwarded
	I16, PC_1, Padder, ALU_OUT: std_logic_vector(15 downto 0);
	C_old, Z_old: std_logic;
	-- controls to be forwarded
	RF:  RegFileCtrl; -- A3 included here -- to be taken untill WB stage
	mem_out: std_logic_vector(15 downto 0);
	D_multiple: matrix16(7 downto 0);
	M3_sel: std_logic_vector(1 downto 0);
end Record;

component IF_ID_reg is
	port (Din: in IF_ID_type;
	      Dout: out IF_ID_type;
	      clk, enable: in std_logic);
end component;

component ID_RR_reg is
	port (Din: in ID_RR_type;
	      Dout: out ID_RR_type;
	      clk, enable: in std_logic);
end component;

component RR_EX_reg is
	port (Din: in RR_EX_type;
	      Dout: out RR_EX_type;
	      clk, enable: in std_logic);
end component;

component EX_MEM_reg is
	port (Din: in EX_MEM_type;
	      Dout: out EX_MEM_type;
	      clk, enable: in std_logic);
end component;

component  MEM_WB_reg is
	port (Din: in MEM_WB_type;
	      Dout: out MEM_WB_type;
	      clk, enable: in std_logic);
end component;

component Datapath is
port(
clk: in std_logic;
	mem_ctr_out: out std_logic_vector(7 downto 0);
	din_mem_out: out matrix16(7 downto 0);
	dout_mem_in: in matrix16(7 downto 0);
	dram_addr_mem: out matrix16(7 downto 0);
	dram_pathway: out std_logic;
	dram_writeEN:out std_logic;
	dram_mem_loaded:in std_logic;
	dram_ai_mem:out std_logic_vector(15 downto 0);
	dram_di_mem:out std_logic_vector(15 downto 0);
	dram_do_mem:in std_logic_vector(15 downto 0);
	irom_mem_loaded:in std_logic;
	irom_address:out std_logic_vector(15 downto 0);
	irom_dataout:in std_logic_vector(15 downto 0)
	);
end component;

--==========
end components;
--==========
