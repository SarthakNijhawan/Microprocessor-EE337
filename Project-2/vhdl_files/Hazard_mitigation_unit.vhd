library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity HazardMitigationUnit is
	port(
		reset, flush_2_pipes, lm_sm_halt, lm_sm_nop, fu_stall, p5_dest_valid : in std_logic;
		p5_rfd, pcl_out, ir : in std_logic_vector(15 downto 0);
		p5_a3 : in std_logic_vector(2 downto 0);
		lm_sm_bits : in std_logic_vector(4 downto 0);
		---------------------------------------------------------------
		flush_bits, pipe_en_bits : out std_logic_vector(4 downto 0);
		pc_in : out std_logic_vector(15 downto 0);
		en_pc, lm_sm_stall, wr_mem_mux : out std_logic);

end HazardMitigationUnit;

architecture behave of HazardMitigationUnit is
	signal opcode : std_logic_vector(3 downto 0);
	begin

	process(reset, flush_2_pipes, lm_sm_halt, lm_sm_nop, fu_stall, p5_dest_val, p5_rfd, pcl_out, ir, p5_a3, adder_mux_out, lm_sm_bits)
		variable stall_flag : integer := 0;
		begin

		if (reset = '1') then
			flush_bits <= "11111";
			wr_mem_mux <= '1';
			-- en_pc, pipe_en_bits and lm_sm_stall are dont care condtions
		else

------------------ r7 detected in pipe 5  ------------------ not reset
			if (p5_a3 = "111"  and p5_dest_valid = '1') then
					en_pc <= '1';
					pc_in <= p5_rfd;
					lm_sm_stall <= '0';

					if (lm_sm_bits(4) = '0') then	-- not LM/SM						
						flush_bits <= "11111";
						wr_mem_mux <= '1';
					else
						if (lm_sm_bits(0) = '1' and lm_sm_halt = '1') then
							flush_bits <= "00000";
							wr_mem_mux <= '0';
						else
							if (lm_sm_bits(0) = '1' ) then
								flush_bits <= "00001";
								wr_mem_mux <= '0';
							elsif (lm_sm_bits(1) = '1' ) then
								flush_bits <= "00011";
								wr_mem_mux <= '0';
							elsif (lm_sm_bits(2) = '1' ) then
								flush_bits <= "00111";
								wr_mem_mux <= '0';
							elsif (lm_sm_bits(3) = '1' ) then
								flush_bits <= "01111";
								wr_mem_mux <= '0';
							end if ;
						end if ;
					end if;	

------------------ BEQ/JAL/JLR ------------------------------------------ not reset
			elsif (opcode = "1100" or opcode = "1000" or opcode = "1001") then	
				en_pc <= '1';
				wr_mem_mux <= '0';
				pc_in <= pcl_out;
				pipe_en_bits <= "11111";
				lm_sm_stall <= '0';
				if (flush_2_pipes = '1') then
					flush_bits <= "00011";
				else
					flush_bits <= "00000";
				end if;

------------------ Normal Operation along with hazards ------------------ not reset
			else
				pc_in <= pcl_out;
				wr_mem_mux <= '0';
				
				if (fu_stall = '1') then								-- Hazards encountered TODO
					en_pc <= '0';
					flush_bits <= "00100";
					lm_sm_stall <= '1';
					pipe_en_bits <= "11100";
				else

					lm_sm_stall <= '0';

				 	if (lm_sm_nop = '1') then							-- LM/SM is nothing but a NOP
						flush_bits <= "00010";							-- pipe 2 is flushed
						en_pc <= '1';
						pipe_en_bits <= "11111";
					else
						if (lm_sm_halt = '1') then						-- LM/SM is detected to execute for multiple cycles
							flush_bits <= "00000";
							en_pc <= '0';
							pipe_en_bits <= "11110";					-- pipe 1 is prevented from updating
						else 											-- Neither LM/SM nor any hazard handling is being done
							flush_bits <= "00000";							
							en_pc <= '1';
							pipe_en_bits <= "11111";

						end if;
					end if;
				end if;
			end if;
		end if;
	end process;

	opcode <= ir(15 downto 12);

end behave;