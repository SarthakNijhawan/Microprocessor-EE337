library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity decoder is
	port(
		IR : in std_logic_vector(15 downto 0);
		lm_sm_start : in std_logic;
		sm_address : in std_logic_vector(2 downto 0);
		lm_detected, sm_detected : out std_logic;
		op_code : out std_logic_vector(3 downto 0);
		ari_bits : out std_logic_vector(1 downto 0);
		mux_add2, mux_7sh : out std_logic;
		mux_a1 : out std_logic_vector(1 downto 0);
		mux_a2 : out std_logic;
		mux_a3, mux_d1, mux_d2, mux_op1, mux_op2 : out std_logic_vector(1 downto 0);
		mux_dr : out std_logic;
		mux_rfd : out std_logic_vector(1 downto 0);
		mux_z2, alu_op_sel, wr_dmem, wr_rf : out std_logic
		);
end entity;

architecture behave of decoder is
	signal RA,RB,RC : std_logic_vector(2 downto 0);
begin
	op_code <= IR(15 downto 12);
	RA <= IR(11 downto 9);
	RB <= IR(8 downto 6);
	RC <= IR(5 downto 3);
	ari_bits <= IR(1 downto 0);

	main: process(IR)
	begin
		case IR(15 downto 12) is
			when "0000" =>		--Add
				mux_a1 <= "00";
				mux_a2 <= '0';
				mux_a3 <= "11";
				mux_op1 <= "00";
				mux_op2 <= "00";
				mux_rfd <= "00";
				mux_z2 <= '0';
				alu_op_sel <= '0';
				wr_dmem <= '0';
				wr_rf <= '1';
				lm_detected <= '0';
				sm_detected <= '0';	
				---------------------------------------
				case RA is
					when "111" => mux_d1 <= "01";
					when others => mux_d1 <= "00";
				end case;
				---------------------------------------	
				---------------------------------------
				case RB is
					when "111" => mux_d2 <= "01";
					when others => mux_d2 <= "00";
				end case;
				---------------------------------------		
			when "0001" => 		--Add immediate
				mux_a1 <= "00";
				mux_a3 <= "10";
				mux_op1 <= "00";
				mux_op2 <= "01";
				mux_rfd <= "00";
				mux_z2 <= '0';
				alu_op_sel <= '0';
				wr_dmem <= '0';
				wr_rf <= '1';
				lm_detected <= '0';
				sm_detected <= '0';
				---------------------------------------
				case RA is
					when "111" => mux_d1 <= "01";
					when others => mux_d1 <= "00";
				end case;
				---------------------------------------	
			when "0010" => 		--Nand
				mux_a1 <= "00";
				mux_a2 <= '0';
				mux_a3 <= "11";
				mux_op1 <= "00";
				mux_op2 <= "00";
				mux_rfd <= "00";
				mux_z2 <= '0';
				alu_op_sel <= '1';
				wr_dmem <= '0';
				wr_rf <= '1';
				lm_detected <= '0';
				sm_detected <= '0';
				---------------------------------------
				case RA is
					when "111" => mux_d1 <= "01";
					when others => mux_d1 <= "00";
				end case;
				---------------------------------------	
				---------------------------------------
				case RB is
					when "111" => mux_d2 <= "01";
					when others => mux_d2 <= "00";
				end case;
				---------------------------------------	
			when "0011" =>		--LHI
				mux_7sh <= '0';
				mux_a3 <= "01";
				mux_rfd <= "01";
				wr_dmem <= '0';
				wr_rf <= '1';
				lm_detected <= '0';
				sm_detected <= '0';
			when "0100" => 		--LW
				mux_a2 <= '0';
				mux_a3 <= "01";
				mux_op1 <= "01";
				mux_op2 <= "00";
				mux_rfd <= "10";
				mux_z2 <= '1';
				alu_op_sel <= '0';
				wr_dmem <= '0';
				wr_rf <= '1';
				lm_detected <= '0';
				sm_detected <= '0';
				---------------------------------------
				case RB is
					when "111" => mux_d2 <= "01";
					when others => mux_d2 <= "00";
				end case;
				---------------------------------------	
			when "0101" => 		--SW
				mux_a1 <= "00";
				mux_a2 <= '0';
				mux_op1 <= "01";
				mux_op2 <= "00";
				mux_dr <= '1';
				alu_op_sel <= '0';
				wr_dmem <= '1';
				wr_rf <= '0';
				lm_detected <= '0';
				sm_detected <= '0';
				---------------------------------------
				case RA is
					when "111" => mux_d1 <= "01";
					when others => mux_d1 <= "00";
				end case;
				---------------------------------------	
				---------------------------------------
				case RB is
					when "111" => mux_d2 <= "01";
					when others => mux_d2 <= "00";
				end case;
				---------------------------------------	
			when "0110" => 		--LM
				mux_a1 <= "00";
				mux_a3 <= "00";
				mux_op2 <= "10";
				mux_rfd <= "10";
				alu_op_sel <= '0';
				wr_dmem <= '0';
				wr_rf <= '1';
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
					when "111" => mux_d1 <= "01";
					when others => mux_d1 <= "00";
				end case;
				---------------------------------------	
			when "0111" => 		--SM
				mux_a1 <= "00";
				mux_a2 <= '1';
				mux_op2 <= "10";
				mux_dr <= '0';
				alu_op_sel <= '0';
				wr_dmem <= '1';
				wr_rf <= '0';
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
					when "111" => mux_d1 <= "01";
					when others => mux_d1 <= "00";
				end case;
				---------------------------------------	
				---------------------------------------
				case sm_address is
					when "111" => mux_d2 <= "01";
					when others => mux_d2 <= "00";
				end case;
				---------------------------------------	
			when "1100" => 		--BEQ
				mux_add2 <= '1';
				mux_a1 <= "00";
				mux_a2 <= '0';
				wr_dmem <= '0';
				wr_rf <= '0';
				lm_detected <= '0';
				sm_detected <= '0';
				---------------------------------------
				case RA is
					when "111" => mux_d1 <= "01";
					when others => mux_d1 <= "00";
				end case;
				---------------------------------------	
				---------------------------------------
				case RB is
					when "111" => mux_d2 <= "01";
					when others => mux_d2 <= "00";
				end case;
				---------------------------------------	
			when "1000" => 		--JAL
				mux_add2 <= '0';
				mux_7sh <= '1';
				mux_a3 <= "01";
				mux_rfd <= "01";
				wr_dmem <= '0';
				wr_rf <= '1';
				lm_detected <= '0';
				sm_detected <= '0';
			when "1001" => 		--JLR
				mux_7sh <= '1';
				mux_a2 <= '0';
				mux_a3 <= "01";
				mux_rfd <= "01";
				wr_dmem <= '0';
				wr_rf <= '1';
				lm_detected <= '0';
				sm_detected <= '0';
				---------------------------------------
				case RB is
					when "111" => mux_d2 <= "01";
					when others => mux_d2 <= "00";
				end case;
				---------------------------------------	
			when others =>
		end case;
	end process;
end architecture; 
