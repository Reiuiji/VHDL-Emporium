----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:50:59 03/16/2014 
-- Design Name: 
-- Module Name:    TB_SREG_4 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use work.UMDRISC_pkg.ALL;

entity TB_SREG_4 is
end TB_SREG_4;

architecture Behavioral of TB_SREG_4 is

component SREG_4 is

	generic(
		REG_WIDTH:	integer:=2 -- select between 16 different possible registers
	);
	port(
		CLOCK			: in std_logic;
		SR_WE	: in std_logic;
		RESETN			: in std_logic;
		--Shadow Register
		SR_SEL			: in std_logic_vector(REG_WIDTH-1 downto 0);
		SR_OUT			: out std_logic_vector(DATA_WIDTH-1 downto 0);
		SR_IN			: in std_logic_vector(DATA_WIDTH-1 downto 0)
   );

	end component;
	
	CONSTANT REG_WIDTH:integer:=2;

	signal CLOCK 			: STD_LOGIC := '0';
	signal SR_WE		 	: STD_LOGIC := '0';
	signal RESETN			: STD_LOGIC := '0';
	signal SR_SEL			: std_logic_vector(REG_WIDTH-1 downto 0);
	signal SR_OUT			: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal SR_IN			: std_logic_vector(DATA_WIDTH-1 downto 0);

	constant period : time := 10 ns;

begin

	-- 15 24bit General purpose register
	Reg1: SREG_4 port map(
		CLOCK => Clock,
		SR_WE => SR_WE,
		RESETN => RESETN,
		SR_SEL => SR_SEL,
		SR_OUT => SR_OUT,
		SR_IN => SR_IN
	);

	m50MHZ_Clock: process
	begin
		CLOCK <= '0'; wait for period;
		CLOCK <= '1'; wait for period;
	end process m50MHZ_Clock;

	tb : process
	begin
		-- Wait 100 ns for global reset to finish
		wait for 5*period;
		report "Starting [name] Test Bench" severity NOTE;

		----- Unit Test -----
		SR_SEL <= "00";

		--Reset disable
		RESETN <= '1'; wait for 2*period;

		--Write to each Register(4)
		SR_IN <= x"FFFFF0";
		wait for 2*period;
		SR_WE <= '1'; wait for 2*period;
		SR_WE <= '0'; wait for 2*period;

		SR_IN <= x"FFFF0F";
		SR_SEL <= "01";

		SR_WE <= '1'; wait for 2*period;
		SR_WE <= '0'; wait for 2*period;

		SR_IN <= x"FFF0FF";
		SR_SEL <= "10";

		SR_WE <= '1'; wait for 2*period;
		SR_WE <= '0'; wait for 2*period;

		SR_IN <= x"FF0FFF";
		SR_SEL <= "11";

		SR_WE <= '1'; wait for 2*period;
		SR_WE <= '0'; wait for 2*period;

		--Read from each register
		SR_SEL <= "00"; wait for 2*period;
		SR_SEL <= "01"; wait for 2*period;
		SR_SEL <= "10"; wait for 2*period;
		SR_SEL <= "11"; wait for 2*period;

		

	end process;

end Behavioral;

