library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.basic.all;

entity nstalls_count is
    port(nstalls : in std_logic_vector(2 downto 0);
			clk : in std_logic;
         stall_bit : in std_logic;
         adder_mux_out : out std_logic_vector(2 downto 0)
    );
end nstalls_count;

architecture behave of nstalls_count is
    signal mux_select : std_logic := '1';
    signal reg_out : std_logic_vector(2 downto 0);
    signal mux_out, add_out : std_logic_vector(2 downto 0);
	 --signal stall_bit_1 : std_logic;
    begin

        mux1_1 : mux_2to1_nbits
            generic map(3)
            port map(s0 => mux_select, input0 => nstalls, input1 => reg_out, output => mux_out);

        dreg : dregister
            generic map(3)
            port map(reset => '0', din => add_out, dout => reg_out, enable => '1', clk => clk);
        add_out <= std_logic_vector( unsigned(mux_out) + 1 );
        adder_mux_out <= mux_out;
		  
		  --stall_bit_1 <= stall_bit;

        process(nstalls, stall_bit)
        begin
            if(stall_bit'event and stall_bit = '1') then
                mux_select <= '0';
            --else
              --  mux_select <= '1';
            end if;
        end process;
end behave;
