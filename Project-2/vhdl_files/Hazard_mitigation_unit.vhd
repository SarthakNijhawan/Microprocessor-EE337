library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity HazardMitigationUnit is
	port(
		reset, flush_2_pipes, lm_sm_halt, fu_stall : in std_logic,
		p5_rfd, pcl_out : in std_logic_vector(15 downto 0),
		p5_a3 : in std_logic_vector(2 downto 0),
		flush_bits, pipe_en_bits : out std_logic_vector(4 downto 0),
		en_pc, lm_sm_stall, wr_mem_mux : out std_logic,
		pc_in : std_logic_vector(15 downto 0));

end HazardMitigationUnit;

architecture behave of HazardMitigationUnit is
	begin
	process()
		begin
		
	end process;
end behave;