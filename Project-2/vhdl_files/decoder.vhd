library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity decoder is
	port(
		IR : in std_logic_vector(15 downto 0);
		sm_address : in std_logic_vector(2 downto 0);
		lm_sm_start : in std_logic;
		lm_detected, sm_detected : out std_logic;
		mux_add2,mux_7sh,mux_a2,mux_d1,mux_d2,mux_dr,mux_rfd,mux_z2,alu_op_sel,wr_mem,wr_rf,op1_check,op2_check,dest_cycle,mux_ao,valid_dest : out std_logic;
		mux_a3,mux_op1,mux_op2,source1_cycle,source2_cycle : out std_logic_vector(1 downto 0)
		);
end entity;

architecture behave of decoder is
	signal RA,RB,RC : std_logic_vector(2 downto 0);
	signal op_code : std_logic_vector(3 downto 0);
	signal ari_bits : std_logic_vector(1 downto 0);
begin
	op_code <= IR(15 downto 12);
	RA <= IR(11 downto 9);
	RB <= IR(8 downto 6);
	RC <= IR(5 downto 3);
	ari_bits <= IR(1 downto 0);

	main: process(IR,sm_address,lm_sm_start)
	begin
		case op_code is
			when "0000" =>		--Add
				--mux_add2 <= '';
				--mux_7sh <= '';
				mux_a2 <= '0';
				mux_a3 <= "11";
				--mux_d1 <= '';
				--mux_d2 <= '';
				mux_op1 <= "00";
				mux_op2 <= "00";
				--mux_dr <= '';
				mux_rfd <= '0';
				mux_z2 <= '0';
				alu_op_sel <= '0';
				wr_mem <= '0';
				wr_rf <= '1';
				op1_check <= '1';
				op2_check <= '1';
				--dest_cycle <= '1';
				source1_cycle <= "00";
				source2_cycle <= "00";
				mux_ao <= '0';
				valid_dest <= '1';
				lm_detected <= '0';
				sm_detected <= '0';
				---------------------------------------
				case ari_bits is
					when "00" => dest_cycle <= '1';
					when others => dest_cycle <= '0';
				end case;
				---------------------------------------
				---------------------------------------
				case RA is
					when "111" => mux_d1 <= '1';
					when others => mux_d1 <= '0';
				end case;
				---------------------------------------
				---------------------------------------
				case RB is
					when "111" => mux_d2 <= '1';
					when others => mux_d2 <= '0';
				end case;
				---------------------------------------
			when "0001" => 		--Add immediate
				--mux_add2 <= '';
				--mux_7sh <= '';
				mux_a2 <= '0';
				mux_a3 <= "10";
				--mux_d1 <= '';
				--mux_d2 <= '';
				mux_op1 <= "00";
				mux_op2 <= "01";
				--mux_dr <= '';
				mux_rfd <= '0';
				mux_z2 <= '0';
				alu_op_sel <= '0';
				wr_mem <= '0';
				wr_rf <= '1';
				op1_check <= '1';
				op2_check <= '0';
				dest_cycle <= '1';
				source1_cycle <= "00";
				--source2_cycle <= "00";
				mux_ao <= '0';
				valid_dest <= '1';
				lm_detected <= '0';
				sm_detected <= '0';

				---------------------------------------
				case RA is
					when "111" => mux_d1 <= '1';
					when others => mux_d1 <= '0';
				end case;
				---------------------------------------

			when "0010" => 		--Nand
				--mux_add2 <= '';
				--mux_7sh <= '';
				mux_a2 <= '0';
				mux_a3 <= "11";
				--mux_d1 <= '';
				--mux_d2 <= '';
				mux_op1 <= "00";
				mux_op2 <= "00";
				--mux_dr <= '';
				mux_rfd <= '0';
				mux_z2 <= '0';
				alu_op_sel <= '1';
				wr_mem <= '0';
				wr_rf <= '1';
				op1_check <= '1';
				op2_check <= '1';
				--dest_cycle <= '1';
				source1_cycle <= "00";
				source2_cycle <= "00";
				mux_ao <= '0';
				valid_dest <= '1';
				lm_detected <= '0';
				sm_detected <= '0';
				---------------------------------------
				case ari_bits is
					when "00" => dest_cycle <= '1';
					when others => dest_cycle <= '0';
				end case;
				---------------------------------------
				---------------------------------------
				case RA is
					when "111" => mux_d1 <= '1';
					when others => mux_d1 <= '0';
				end case;
				---------------------------------------
				---------------------------------------
				case RB is
					when "111" => mux_d2 <= '1';
					when others => mux_d2 <= '0';
				end case;
				---------------------------------------

			when "0011" =>		--LHI
				--mux_add2 <= '';
				mux_7sh <= '0';
				-- mux_a2 <= '';
				mux_a3 <= "01";
				-- mux_d1 <= '';
				-- mux_d2 <= '';
				-- mux_op1 <= "";
				-- mux_op2 <= "";
				-- mux_dr <= '';
				mux_rfd <= '0';
				-- mux_z2 <= '';
				-- alu_op_sel <= '';
				wr_mem <= '0';
				wr_rf <= '1';
				op1_check <= '0';
				op2_check <= '0';
				dest_cycle <= '1';
				-- source1_cycle <= "";
				-- source2_cycle <= "";
				mux_ao <= '1';
				valid_dest <= '1';
				lm_detected <= '0';
				sm_detected <= '0';
			when "0100" => 		--LW
				-- mux_add2 <= '';
				-- mux_7sh <= '';
				mux_a2 <= '0';
				mux_a3 <= "01";
				-- mux_d1 <= '';
				--mux_d2 <= '';
				mux_op1 <= "01";
				mux_op2 <= "00";
				-- mux_dr <= '';
				mux_rfd <= '1';
				mux_z2 <= '1';
				alu_op_sel <= '0';
				wr_mem <= '0';
				wr_rf <= '1';
				op1_check <= '0';
				op2_check <= '1';
				dest_cycle <= '0';
				-- source1_cycle <= "";
				source2_cycle <= "00";
				mux_ao <= '0';
				valid_dest <= '1';
				lm_detected <= '0';
				sm_detected <= '0';
				---------------------------------------
				case RB is
					when "111" => mux_d2 <= '1';
					when others => mux_d2 <= '0';
				end case;
				---------------------------------------
			when "0101" => 		--SW
				-- mux_add2 <= '';
				-- mux_7sh <= '';
				mux_a2 <= '0';
				-- mux_a3 <= "";
				-- mux_d1 <= '';
				-- mux_d2 <= '';
				mux_op1 <= "01";
				mux_op2 <= "00";
				mux_dr <= '1';
				-- mux_rfd <= '';
				-- mux_z2 <= '';
				alu_op_sel <= '0';
				wr_mem <= '1';
				wr_rf <= '0';
				op1_check <= '1';
				op2_check <= '1';
				-- dest_cycle <= '';
				source1_cycle <= "01";
				source2_cycle <= "00";
				mux_ao <= '0';
				valid_dest <= '0';
				lm_detected <= '0';
				sm_detected <= '0';
				---------------------------------------
				case RA is
					when "111" => mux_d1 <= '1';
					when others => mux_d1 <= '0';
				end case;
				---------------------------------------
				---------------------------------------
				case RB is
					when "111" => mux_d2 <= '1';
					when others => mux_d2 <= '0';
				end case;
				---------------------------------------
			when "0110" => 		--LM
				-- mux_add2 <= '';
				-- mux_7sh <= '';
				-- mux_a2 <= '';
				mux_a3 <= "00";
				-- mux_d1 <= '';
				-- mux_d2 <= '';
				-- mux_op1 <= "";
				mux_op2 <= "10";
				-- mux_dr <= '';
				mux_rfd <= '1';
				-- mux_z2 <= '';
				alu_op_sel <= '0';
				wr_mem <= '0';
				wr_rf <= '1';
				op1_check <= '1';
				op2_check <= '0';
				dest_cycle <= '0';
				source1_cycle <= "00";
				-- source2_cycle <= "";
				mux_ao <= '0';
				valid_dest <= '1';
				lm_detected <= '1';
				sm_detected <= '0';
				---------------------------------------
				case lm_sm_start is
					when '1' => mux_op1 <= "00";
					when others => mux_op1 <= "10";
				end case;
				---------------------------------------
				---------------------------------------
				case RA is
					when "111" => mux_d1 <= '1';
					when others => mux_d1 <= '0';
				end case;
				---------------------------------------
			when "0111" => 		--SM
				-- mux_add2 <= '';
				-- mux_7sh <= '';
				mux_a2 <= '1';
				-- mux_a3 <= "00";
				-- mux_d1 <= '';
				-- mux_d2 <= '';
				-- mux_op1 <= "";
				mux_op2 <= "10";
				mux_dr <= '0';
				-- mux_rfd <= '1';
				-- mux_z2 <= '';
				alu_op_sel <= '0';
				wr_mem <= '1';
				wr_rf <= '0';
				op1_check <= '1';
				op2_check <= '1';
				-- dest_cycle <= '0';
				source1_cycle <= "01";
				source2_cycle <= "01";
				mux_ao <= '0';
				valid_dest <= '0';
				lm_detected <= '0';
				sm_detected <= '1';
				---------------------------------------
				case lm_sm_start is
					when '1' => mux_op1 <= "00";
					when others => mux_op1 <= "10";
				end case;
				---------------------------------------
				---------------------------------------
				case RA is
					when "111" => mux_d1 <= '1';
					when others => mux_d1 <= '0';
				end case;
				---------------------------------------
				---------------------------------------
				case sm_address is
					when "111" => mux_d2 <= '1';
					when others => mux_d2 <= '0';
				end case;
				---------------------------------------
			when "1100" => 		--BEQ
				mux_add2 <= '1';
				-- mux_7sh <= '';
				mux_a2 <= '0';
				-- mux_a3 <= "";
				-- mux_d1 <= '';
				-- mux_d2 <= '';
				-- mux_op1 <= "01";
				-- mux_op2 <= "00";
				-- mux_dr <= '1';
				-- mux_rfd <= '';
				-- mux_z2 <= '';
				-- alu_op_sel <= '0';
				wr_mem <= '0';
				wr_rf <= '0';
				op1_check <= '1';
				op2_check <= '1';
				-- dest_cycle <= '';
				source1_cycle <= "10";
				source2_cycle <= "10";
				-- mux_ao <= '0';
				valid_dest <= '0';
				lm_detected <= '0';
				sm_detected <= '0';
				---------------------------------------
				case RA is
					when "111" => mux_d1 <= '1';
					when others => mux_d1 <= '0';
				end case;
				---------------------------------------
				---------------------------------------
				case RB is
					when "111" => mux_d2 <= '1';
					when others => mux_d2 <= '0';
				end case;
				---------------------------------------
			when "1000" => 		--JAL
				mux_add2 <= '0';
				mux_7sh <= '1';
				-- mux_a2 <= '0';
				mux_a3 <= "01";
				-- mux_d1 <= '';
				-- mux_d2 <= '';
				-- mux_op1 <= "01";
				-- mux_op2 <= "00";
				-- mux_dr <= '1';
				mux_rfd <= '0';
				-- mux_z2 <= '';
				-- alu_op_sel <= '0';
				wr_mem <= '0';
				wr_rf <= '1';
				op1_check <= '0';
				op2_check <= '0';
				dest_cycle <= '1';
				-- source1_cycle <= "01";
				-- source2_cycle <= "00";
				mux_ao <= '1';
				valid_dest <= '1';
				lm_detected <= '0';
				sm_detected <= '0';
			---------------------------------------
			when "1001" => 		--JLR
				-- mux_add2 <= '';
				mux_7sh <= '1';
				mux_a2 <= '0';
				mux_a3 <= "01";
				-- mux_d1 <= '';
				-- mux_d2 <= '';
				-- mux_op1 <= "01";
				-- mux_op2 <= "00";
				-- mux_dr <= '1';
				mux_rfd <= '0';
				-- mux_z2 <= '';
				-- alu_op_sel <= '0';
				wr_mem <= '0';
				wr_rf <= '1';
				op1_check <= '0';
				op2_check <= '1';
				dest_cycle <= '1';
				-- source1_cycle <= "01";
				source2_cycle <= "10";
				mux_ao <= '1';
				valid_dest <= '1';
				lm_detected <= '0';
				sm_detected <= '0';
				---------------------------------------
				case RB is
					when "111" => mux_d2 <= '1';
					when others => mux_d2 <= '0';
				end case;
				---------------------------------------
			when others =>
		end case;
	end process;
end architecture;
