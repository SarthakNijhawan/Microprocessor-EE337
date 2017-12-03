library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FU is
    port(p3_lm_sm_bit,p4_lm_sm_bit,p5_lm_sm_bit,lm_sm_bit,op1_check,op2_check,p5_dest,p4_dest,p3_dest,p4_valid,p5_valid,p3_valid : in std_logic;
         A1,A2,p3_a3,p4_a3,p5_a3 : in std_logic_vector(2 downto 0);
         source1_cycle,source2_cycle : in std_logic_vector(1 downto 0);
         mux_memd,mux_dr,stall_bit : out std_logic;
         mux_op1,mux_op2,mux_d1,mux_d2 : out std_logic_vector(1 downto 0);
         nstalls : out std_logic_vector(1 downto 0)
        );
end FU;

architecture behave of FU is
    begin
    process(p3_lm_sm_bit,p4_lm_sm_bit,p5_lm_sm_bit,lm_sm_bit,op1_check,
            op2_check,p5_dest,p4_dest,p3_dest,p4_valid,p5_valid,p3_valid,
                A1,A2,p3_a3,p4_a3,p5_a3,source1_cycle,source2_cycle)
        begin
            --------------------------------------------------------------------
            if (op1_check = '0' and op2_check = '0') then
                --- No Hazards detected
                mux_memd <= '0';
                mux_op1  <= "00";
                mux_op2  <= "00";
                mux_d1 <= "00";
                mux_d2 <= "00";
                mux_dr <= '0';
                stall_bit <= '0';
            else
                ------------------------ FOR OP1 ---------------------------
                ------------------------------------------------------------
                ---------------------------- PIPE 3 ------------------------
                if (not (lm_sm_bit = '1' and p3_lm_sm_bit = '1') and p3_valid = '1' and p3_a3 = A1) then
                        if (p3_dest = '1') then                             -- dest_cycles = 4
                                if (source1_cycle = "10") then                   -- src-cycles = 3
                                    mux_op1  <= "00";
                                    mux_d1 <= "01";
                                    stall_bit <= '1';
                                    nstalls <= "11";
                                elsif (source1_cycle = "00") then              -- src-cycles = 4
                                    mux_op1  <= "01";
                                    stall_bit <= '0';
                                elsif (source1_cycle = "01") then               -- src-cycles = 5
                                    mux_memd <= '1';
                                    stall_bit <= '0';
                            end if;
                        else                                                -- dest_cycles = 5
                            if (source1_cycle = "10") then                      -- src-cycles = 3
                                    mux_op1  <= "00";
                                    mux_d1 <= "10";
                                    stall_bit <= '1';
                                    nstalls <= "10";
                            elsif (source1_cycle = "00") then                  -- src-cycles = 4
                                    stall_bit <= '1';
                                    nstalls <= "11";
                            elsif (source1_cycle = "01") then                   -- src-cycles = 5
                                    mux_memd <= '1';
                                    stall_bit <= '0';
                            end if;
                        end if;
                ------------------------------------------------------------
                ---------------------------- PIPE 4 ------------------------
                elsif (not (lm_sm_bit = '1' and p4_lm_sm_bit = '1') and p4_valid = '1' and p4_a3 = A1) then
                        if (p4_dest = '1') then                             -- dest_cycles = 4
                            mux_memd <= '0';
                            mux_op1  <= "00";
                            mux_d1 <= "01";
                            mux_dr <= '0';
                            stall_bit <= '0';
                        else                                               -- dest_cycles = 5
                            if (source1_cycle = "10") then                       -- src-cycles = 3
                                mux_op1  <= "00";
                                mux_d1 <= "10";
                                stall_bit <= '1';
                                nstalls <= "11";
                            elsif (source1_cycle = "00") then                     -- src-cycles = 4
                                mux_op1  <= "10";
                                stall_bit <= '0';
                            elsif (source1_cycle = "01") then                    -- src-cycles = 5
                                mux_memd <= '0';
                                mux_dr <= '1';
                                stall_bit <= '0';
                            end if;
                        end if;
                ------------------------------------------------------------
                ---------------------------- PIPE 5 ------------------------
                elsif (not (lm_sm_bit = '1' and p5_lm_sm_bit = '1') and p5_valid = '1' and p5_a3 = A1) then
                    mux_memd <= '0';
                    mux_dr <= '0';
                    stall_bit <= '0';
                    mux_op1  <= "00";
                    mux_d1 <= "10";
                else
                    -- No hazards detected for op1
                    mux_memd <= '0';
                    mux_op1  <= "00";
                    mux_d1 <= "00";
                    mux_dr <= '0';
                    stall_bit <= '0';
                end if;



                ------------------------ FOR OP2 ---------------------------
                ------------------------------------------------------------
                ---------------------------- PIPE 3 ------------------------
                if (not (lm_sm_bit = '1' and p3_lm_sm_bit = '1') and p3_valid = '1' and p3_a3 = A2) then
                        if (p3_dest = '1') then                             -- dest_cycles = 4
                                if (source2_cycle = "10") then                   -- src-cycles = 3
                                    mux_op2  <= "00";
                                    mux_d2 <= "01";
                                    stall_bit <= '1';
                                    nstalls <= "11";
                                elsif (source2_cycle = "00") then                -- src-cycles = 4
                                    mux_op2  <= "01";
                                    stall_bit <= '0';
                                elsif (source2_cycle = "01") then                -- src-cycles = 5
                                    mux_memd <= '1';
                                    stall_bit <= '0';
                            end if;
                        else                                                -- dest_cycles = 5
                            if (source2_cycle = "10")  then                      -- src-cycles = 3
                                    mux_op2  <= "00";
                                    mux_d2 <= "10";
                                    stall_bit <= '1';
                                    nstalls <= "10";
                            elsif (source2_cycle = "00") then                    -- src-cycles = 4
                                    stall_bit <= '1';
                                    nstalls <= "11";
                            elsif (source2_cycle = "01") then                   -- src-cycles = 5
                                    mux_memd <= '1';
                                    stall_bit <= '0';
                            end if;
                        end if;
                ------------------------------------------------------------
                ---------------------------- PIPE 4 ------------------------
                elsif (not (lm_sm_bit = '1' and p4_lm_sm_bit = '1') and p4_valid = '1' and p4_a3 = A2) then
                        if (p4_dest = '1') then                             -- dest_cycles = 4
                            mux_memd <= '0';
                            mux_op2  <= "00";
                            mux_d2 <= "01";
                            mux_dr <= '0';
                            stall_bit <= '0';
                        else                                               -- dest_cycles = 5
                            if (source2_cycle = "10") then                       -- src-cycles = 3
                                mux_op2  <= "00";
                                mux_d2 <= "10";
                                stall_bit <= '1';
                                nstalls <= "11";
                            elsif (source2_cycle = "00") then                    -- src-cycles = 4
                                mux_op2  <= "10";
                                stall_bit <= '0';
                            elsif (source2_cycle = "01") then                    -- src-cycles = 5
                                mux_memd <= '0';
                                mux_dr <= '1';
                                stall_bit <= '0';
                            end if;
                        end if;
                ------------------------------------------------------------
                ---------------------------- PIPE 5 ------------------------
                elsif (not (lm_sm_bit = '1' and p5_lm_sm_bit = '1') and p5_valid = '1' and p5_a3 = A2) then
                    mux_memd <= '0';
                    mux_dr <= '0';
                    stall_bit <= '0';
                    mux_op2  <= "00";
                    mux_d2 <= "10";
                else
                    -- No hazards detected for op1
                    mux_memd <= '0';
                    mux_op2  <= "00";
                    mux_d2 <= "00";
                    mux_dr <= '0';
                    stall_bit <= '0';
                end if;

        end if;
    end process;
end behave;
