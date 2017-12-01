library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package basic is
---------------------------------------------------------------------------------------------------------
	component mux_2to1 is  -----checked
	port(
		s, input0, input1 : in std_logic;
		output : out std_logic);
	end component;
---------------------------------------------------------------------------------------------------------
	component mux_2to1_nbits is -----checked
		generic ( nbits : integer);
		port(
			s0 : in std_logic;
			input0, input1 : in std_logic_vector(nbits-1 downto 0);
			output : out std_logic_vector(nbits-1 downto 0));
	end component;
---------------------------------------------------------------------------------------------------------
	component mux_4to1 is -----checked
	port(
		s0, s1, input0, input1, input2, input3 : in std_logic;
		output : out std_logic);
	end component;
---------------------------------------------------------------------------------------------------------
	component mux_4to1_nbits is -----checked
	generic ( nbits : integer);
	port(
		s0, s1 : in std_logic;
		input0, input1, input2, input3 : in std_logic_vector(nbits-1 downto 0);
		output : out std_logic_vector(nbits-1 downto 0));
	end component;

---------------------------------------------------------------------------------------------------------
	component sign_extend is -----checked
		generic(input_width: integer := 6;
			output_width: integer := 16);
		port(
			input: in std_logic_vector(input_width-1 downto 0);
			output: out std_logic_vector(output_width-1 downto 0));
	end component;
---------------------------------------------------------------------------------------------------------
	component nor_box is
		generic(input_width: integer := 16);
		port(
			input: in std_logic_vector(input_width-1 downto 0);
			output: out std_logic);
	end component;
---------------------------------------------------------------------------------------------------------
	component unsigned_comparator is
	  	generic (nbits : integer);
	  	port (
	    		a      : in  std_logic_vector(nbits-1 downto 0);
	    		b      : in  std_logic_vector(nbits-1 downto 0);
	    		a_lt_b : out std_logic;
	    		a_eq_b : out std_logic;
	    		a_gt_b : out std_logic);
	end component;
---------------------------------------------------------------------------------------------------------
	component left7_shifter is
		generic(input_width: integer := 9;
			output_width: integer := 16);
		port(
			input: in std_logic_vector(input_width-1 downto 0);
			output: out std_logic_vector(output_width-1 downto 0));
	end component;
---------------------------------------------------------------------------------------------------------
	component alu is
	 	Port (
		 inp1 : in std_logic_vector(15 downto 0);
		 inp2 : in std_logic_vector(15 downto 0);
		 op_sel : in std_logic;
		 output : out std_logic_vector(15 downto 0);
		 c : out std_logic;
		 z : out std_logic);
	end component;
---------------------------------------------------------------------------------------------------------
	component dregister is
	  	generic (nbits : integer:=16);                    -- no. of bits
	  	port (
	    		reset: in std_logic;
	   		 din  : in  std_logic_vector(nbits-1 downto 0);
	    		dout : out std_logic_vector(nbits-1 downto 0);
	    		enable: in std_logic;
	    		clk     : in  std_logic);
	end component;
---------------------------------------------------------------------------------------------------------
	component dflipflop is
	  port (
	    reset: in std_logic;
	    din  : in  std_logic;
	    dout : out std_logic;
	    enable: in std_logic;
	    clk     : in  std_logic);
	end component;
---------------------------------------------------------------------------------------------------------
	component PriorityEncoder is
	port(
		input : in std_logic_vector(7 downto 0);
		output : out std_logic_vector(2 downto 0);
		invalid : out std_logic
	       );
	end component;
---------------------------------------------------------------------------------------------------------
	component counter is
	port(
		clk,reset,enable: in std_logic;
		overflow: out std_logic;
		A : out std_logic_vector(2 downto 0));
	end component;
---------------------------------------------------------------------------------------------------------
end package;
---------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2to1 is
	port(
		s, input0, input1 : in std_logic;
		output : out std_logic);
end entity;

architecture behave of mux_2to1 is

begin
	output <= ((s and input1) or ((not s) and input0));

end behave;
---------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2to1_nbits is
	generic ( nbits : integer :=16);
	port(
		s0 : in std_logic;
		input0, input1 : in std_logic_vector(nbits-1 downto 0);
		output : out std_logic_vector(nbits-1 downto 0));
end entity;

architecture behave of mux_2to1_nbits is

begin

	   gen: for I in 0 to nbits-1 generate
				output(I) <= (s0 and input1(I)) or ((not s0) and input0(I)) ;
		end generate;

end behave;
---------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_4to1 is
	port(
		s0, s1, input0, input1, input2, input3 : in std_logic;
		output : out std_logic);
end entity;

architecture behave of mux_4to1 is

begin
	output <= (
		      (s0 and s1 and input3) or
		      ((not s0) and s1 and input2) or
		      (s0 and (not s1) and input1) or
		      ((not s0) and (not s1) and input0)
		  );

end behave;
---------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_4to1_nbits is
	generic ( nbits : integer := 16);
	port(
		s0, s1 : in std_logic;
		input0, input1, input2, input3 : in std_logic_vector(nbits-1 downto 0);
		output : out std_logic_vector(nbits-1 downto 0));
end entity;

architecture behave of mux_4to1_nbits is

begin

	   gen: for I in 0 to nbits-1 generate
				output(I) <= (
					      (s0 and s1 and input3(I)) or
					      ((not s0) and s1 and input2(I)) or
					      (s0 and (not s1) and input1(I)) or
					      ((not s0) and (not s1) and input0(I))
					     );
		end generate;

end behave;
---------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_extend is
	generic(input_width: integer := 9;
		output_width: integer := 16);
	port(
		input: in std_logic_vector(input_width-1 downto 0);
		output: out std_logic_vector(output_width-1 downto 0));
end entity;

architecture extend of sign_extend is
begin
	output(input_width-1 downto 0) <= input;
	sign_bit:
	for i in input_width to output_width-1 generate
		output(i) <= input(input_width-1);
	end generate;

end architecture;
---------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nor_box is
	generic(input_width: integer := 16);
	port(
		input: in std_logic_vector(input_width-1 downto 0);
		output: out std_logic);
end entity;

architecture norer of nor_box is
	signal temp: std_logic_vector(input_width-1 downto 0);
begin
	temp(0) <= input(0);
	anding:
	for i in 1 to input_width-1 generate
		temp(i) <= temp(i-1) or input(i);
	end generate;

	output <= not temp(input_width-1);

end architecture;
---------------------------------------------------------------------------------------------------------
-- author: Madhav Desai
-- unsigned comparator with three outputs.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unsigned_comparator is
  generic (
    nbits : integer := 16);
  port (
    a      : in  std_logic_vector(nbits-1 downto 0);
    b      : in  std_logic_vector(nbits-1 downto 0);
    a_lt_b : out std_logic;
    a_eq_b : out std_logic;
    a_gt_b : out std_logic);
end unsigned_comparator;

architecture behave  of unsigned_comparator is
begin  -- behave
  process(a,b)
    variable i,l,e,g,x,y : std_logic;
    begin
      l := '0';
      e := '1';
      g := '0';
      for i  in nbits-1 downto 0 loop
         x := a(i) and (not( b(i)) );
         y := not(a(i) xor b(i));
         if( x = '1' and e = '1') then
           g := '1';
           e := '0';
         elsif (y = '0' and e = '1') then
           l := '1';
           e := '0';
         end if;
      end loop;  -- i
      a_lt_b <= l;
      a_gt_b <= g;
      a_eq_b <= e;
   end process;
end behave ;
---------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity left7_shifter is
	generic(input_width: integer := 9;
		output_width: integer := 16);
	port(
		input: in std_logic_vector(input_width-1 downto 0);
		output: out std_logic_vector(output_width-1 downto 0));
end entity;

architecture shift of left7_shifter is
begin
	output(output_width-1 downto 7) <= input;
	output(6 downto 0) <= "0000000";

end architecture;
---------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
 Port (
	 inp1 : in std_logic_vector(15 downto 0);
	 inp2 : in std_logic_vector(15 downto 0);
	 op_sel : in std_logic;
	 output : out std_logic_vector(15 downto 0);
	 c : out std_logic;                             ---overflow flag
	 z : out std_logic
);
end alu;

architecture Behavioral of alu is
	signal temp_out : std_logic_vector(15 downto 0);
begin
	process(inp1,inp2,op_sel,temp_out)
		begin
			case op_sel is
				when '0' =>
					temp_out <= std_logic_vector(signed(inp1) + signed(inp2));
					output <= temp_out;
					-------overflow logic-------------------
					if(inp1(15) = inp2(15)) then
						if(temp_out(15) = inp1(15)) then
							c <= '0';
						else
							c <= '1';
						end if;
					else
						c <= '0';
					end if;
					--------zero flag-----------------------
					if(temp_out = x"0000") then
						z <= '1';
					else
						z <= '0';
					end if;
				when '1' =>
					temp_out <= inp1 nand inp2;
					output <= temp_out;
					c <= '0';
					--------zero flag-----------------------
					if(temp_out = x"0000") then
						z <= '1';
					else
						z <= '0';
					end if;
				when others =>
					NULL;
			end case;
		end process;

end Behavioral;
---------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dregister is
  generic (
    nbits : integer:=16);                    -- no. of bits
  port (
    reset: in std_logic;
    din  : in  std_logic_vector(nbits-1 downto 0);
    dout : out std_logic_vector(nbits-1 downto 0);
    enable: in std_logic;
    clk     : in  std_logic);
end dregister;

architecture behave of dregister is

begin  -- behave
process(clk,reset,din)
begin
if(reset = '0') then
  if(clk'event and clk = '1') then
    if enable = '1' then
      dout <= din;
    end if;
  end if;

else dout <= (others => '0');
end if;

end process;
end behave;
---------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dflipflop is
  port (
    reset: in std_logic;
    din  : in  std_logic;
    dout : out std_logic;
    enable: in std_logic;
    clk     : in  std_logic);
end dflipflop;

architecture behave of dflipflop is

begin  -- behave
process(clk,reset,din)
begin
if(reset = '0') then
  if(clk'event and clk = '1') then
    if enable = '1' then
      dout <= din;
    end if;
  end if;

else dout <= '0';
end if;

end process;
end behave;
---------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--- Priority encoder.gives highest priority to MSB.
entity PriorityEncoder is
port(
	input : in std_logic_vector(7 downto 0);
	output : out std_logic_vector(2 downto 0);
	invalid : out std_logic
       );
end PriorityEncoder;

architecture behave of PriorityEncoder is
signal x_bar,x : std_logic_vector(7 downto 0);
signal y : std_logic_vector(2 downto 0);

begin
	loopy: for i in 0 to 7 generate
		x(i) <= input(7-i);
	       end generate;
	x_bar<= not(x);

	invalid <= not (x(0) or x(1) or x(2) or x(3) or x(4) or x(5) or x(6) or x(7));
	y(0) <= x_bar(0) and (x(1) or(x_bar(2) and x(3))or (x_bar(2) and x_bar(4) and x(5)) or (x_bar(2) and x_bar(4) and x_bar(6) and x(7)));
	y(1) <= x_bar(0) and x_bar(1) and (x(2) or x(3) or (x_bar(4) and x_bar(5) and (x(6) or x(7))));
	y(2) <= x_bar(0) and x_bar(1) and x_bar(2) and x_bar(3) and (x(4) or x(5) or x(6) or x(7));

	output <= not y;
end behave;
---------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter is
	port(	clk,reset,enable: in std_logic;
		overflow: out std_logic;
		A : out std_logic_vector(2 downto 0));
end entity;

architecture behave of counter is
	signal copy_A: std_logic_vector(2 downto 0);
begin
	process(clk)
		variable temp: std_logic_vector(2 downto 0):="111" ;
		begin
			if( clk'event and clk = '1') then
				if(reset = '0') then
				    if enable = '1' then
				      temp := temp + "001";
				    end if;
				else temp := "111";
				end if;
			end if;
			copy_A <= temp;
			A <= temp;
	end process;
	
	process(copy_A)
		begin
			if(copy_A = "000" and reset = '0') then
				overflow <= '1';
			else
				overflow <= '0';
			end if;
		end process;
end behave;	
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
