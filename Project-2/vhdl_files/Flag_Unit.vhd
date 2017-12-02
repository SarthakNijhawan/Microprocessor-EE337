library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flag_unit is
  port
    (IR : in std_logic_vector(15 downto 0); --
    --ari_bits : in std_logic_vector(1 downto 0);
    c_2 : in std_logic;
    z_2 : in std_logic;
    wr_rf_in : in std_logic
    flush_bit_flag_unit : in std_logic;
    p5_a3 : in std_logic_vector(2 downto 0);
    en_c2 : out std_logic;
    en_z2 : out std_logic;
    wr_rf :out std_logic);
end flag_unit;

architecture behave of flag_unit is
  begin
  process(IR,c_2,z_2,flush_bit_flag_unit,wr_rf_in,p5_a3)
  begin
    if( p5_a3 = "111") then --r7 harzard
        en_c2 <= '0';
        en_z2 <= '0';
    elsif(flush_bit_flag_unit = '1') then -- flush
        en_c2 <= '0';
        en_z2 <= '0';
        wr_rf <= '0';
    elsif((IR(15 downto 12) = "0000") or (IR(15 downto 12) = "0001") or (IR(15 downto 12) = "0010") or (IR(15 downto 12) = "0100")) then
        if(((IR(15 downto 12) = "0000") and (IR(1 downto 0) = "00")) or (IR(15 downto 12) = "0001")) then -- ADD or ADI
            en_c2 <= '1';
            en_z2 <= '1';
            wr_rf <= wr_rf_in;
        elsif((IR(15 downto 12) = "0000") and (IR(1 downto 0) = "01")) then-- ADZ
            if(z_2 = '1') then
                en_c2 <= '1';
                en_z2 <= '1';
                wr_rf <= wr_rf_in;
            else
                en_c2 <= '0';
                en_z2 <= '0';
                wr_rf <= '0';
            end if;
        elsif((IR(15 downto 12) = "0000") and (IR(1 downto 0) = "10")) then-- ADC
            if(c_2 = '1') then
                en_c2 <= '1';
                en_z2 <= '1';
                wr_rf <= wr_rf_in;
            else
                en_c2 <= '0';
                en_z2 <= '0';
                wr_rf <= '0';
            end if;
        elsif((IR(15 downto 12) = "0010") and (IR(1 downto 0) = "01")) then -- NDZ
            if(z_2 = '1') then
                en_c2 <= '0';
                en_z2 <= '1';
                wr_rf <= wr_rf_in;
            else
                en_c2 <= '0';
                en_z2 <= '0';
                wr_rf <= '0';
            end if;
        elsif((IR(15 downto 12) = "0000") and (IR(1 downto 0) = "10")) then -- NDC
            if(c_2 = '1') then
                en_c2 <= '0';
                en_z2 <= '1';
                wr_rf <= wr_rf_in;
            else
                en_c2 <= '0';
                en_z2 <= '0';
                wr_rf <= '0';
            end if;
        elsif((IR(15 downto 12) = "0010") and (IR(1 downto 0) = "00")) then-- NDU
            en_c2 <= '0';
            en_z2 <= '1';
            wr_rf <= wr_rf_in;
        elsif(IR(15 downto 0) = "0100") then -- LW
            en_c2 <= '0';
            en_z2 <= '1';
            wr_rf <= wr_rf_in;
        else
            en_c2 <= '0';
            en_z2 <= '0';
            wr_rf <= wr_rf_in;
        end if;
    else
        en_c2 <= '0';
        en_z2 <= '0';
        wr_rf <= wr_rf_in;
    end if;


    -- if(flush_bit_flag_unit = '1') then
    --   en_c2 <= '0';
    --   en_z2 <= '0';
    --   wr_rf <= '0';
    -- else
    --   if(op_code = "0000" and ari_bits = "00") then -- ADD instruction flags are set
    --     en_c2 <= '1';
    --     en_z2 <= '1';
    --     wr_rf <= '1';
    --   elsif(op_code = "0010" and ari_bits = "00") then -- NDU instruction zero flag set
    --     en_c2 <= '0';
    --     en_z2 <= '1';
    --     wr_rf <= '1';
    --   elsif(op_code = "0001") then -- ADI instruction both flags set
    --     en_c2 <= '1';
    --     en_z2 <= '1';
    --     wr_rf <= '1';
    --   elsif(op_code = "0000" and ari_bits = "10") then -- ADC
    --     if(carry_2 = '1') then
    --       en_c2 <= '1';
    --       en_z2 <= '1';
    --       wr_rf <= '1';
    --     else
    --       en_c2 <= '0';
    --       en_z2 <= '0';
    --       wr_rf <= '0';
    --     end if;
    --   elsif(op_code = "0000" and ari_bits = "01") then -- ADZ
    --     if(zero_2 = '1') then
    --       en_c2 <= '1';
    --       en_z2 <= '1';
    --       wr_rf <= '1';
    --     else
    --       en_c2 <= '0';
    --       en_z2 <= '0';
    --       wr_rf <= '0';
    --     end if;
    --   elsif(op_code = "0010" and ari_bits = "10") then -- NDC
    --     if(carry_2 = '1') then
    --       en_c2 <= '0';
    --       en_z2 <= '1';
    --       wr_rf <= '1';
    --     else
    --       en_c2 <= '0';
    --       en_z2 <= '0';
    --       wr_rf <= '0';
    --     end if;
    --   elsif(op_code = "0010" and ari_bits = "01") then -- NDZ
    --     if(zero_2 = '1') then
    --       en_c2 <= '0';
    --       en_z2 <= '1';
    --       wr_rf <= '1';
    --     else
    --       en_c2 <= '0';
    --       en_z2 <= '0';
    --       wr_rf <= '0';
    --     end if;
    --   elsif(op_code = "0100") then -- LW
    --     en_c2 <= '0';
    --     en_z2 <= '1';
    --     wr_rf <= '1';
    --   elsif(op_code = "0011" or op_code = "0110" or op_code = "1000" or op_code = "1001") then
    --     en_c2 <= '0';
    --     en_z2 <= '0';
    --     wr_rf <= '1';
    --   else
    --     en_c2 <= '0';
    --     en_z2 <= '0';
    --     wr_rf <= '0';
    --   end if;
    -- end if;
	end process;
end behave;
