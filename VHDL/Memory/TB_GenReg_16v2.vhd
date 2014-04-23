----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:50:59 03/16/2014 
-- Design Name: 
-- Module Name:    TB_DUAL_RAM - Behavioral 
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

entity TB_REG_S16 is
end TB_REG_S16;

architecture Behavioral of TB_REG_S16 is

component REG_S16 is

	generic(
		REG_WIDTH:	integer:=4 -- select between 16 different possible registers
	);
	port(
		CLOCK			: in std_logic;
		WE	: in std_logic;
		--Register A
		REG_A_ADDR		: in std_logic_vector(REG_WIDTH-1 downto 0);
		REG_A			: out std_logic_vector(DATA_WIDTH-1 downto 0);
		--Register B
		REG_B_ADDR		: in std_logic_vector(REG_WIDTH-1 downto 0);
		REG_B			: out std_logic_vector(DATA_WIDTH-1 downto 0);
		--CHANGE REGISTER
		REG_A_IN_ADDR	: in std_logic_vector(REG_WIDTH-1 downto 0);
		REG_A_IN		: in std_logic_vector(DATA_WIDTH-1 downto 0)
   );

	end component;
	
	CONSTANT REG_WIDTH:integer:=4;

	signal CLOCK 			: STD_LOGIC := '0';
	signal WE 	: STD_LOGIC := '0';
	signal REG_A_ADDR		: std_logic_vector(REG_WIDTH-1 downto 0);
	signal REG_A			: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal REG_B_ADDR		: std_logic_vector(REG_WIDTH-1 downto 0);
	signal REG_B			: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal REG_A_IN_ADDR	: std_logic_vector(REG_WIDTH-1 downto 0);
	signal REG_A_IN		: std_logic_vector(DATA_WIDTH-1 downto 0);

	constant period : time := 10 ns;

begin

	-- 15 24bit General purpose register
	Reg1: REG_S16 port map(
		CLOCK => Clock,
		WE => WE,
		REG_A_ADDR => REG_A_ADDR,
		REG_A => REG_A,
		REG_B_ADDR => REG_B_ADDR,
		REG_B => REG_B,
		REG_A_IN_ADDR => REG_A_IN_ADDR,
		REG_A_IN => REG_A_IN
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
		REG_A_ADDR <= (others => '0');
		REG_B_ADDR <= (others => '0');
		REG_A_IN_ADDR <= (others => '0');

		REG_A_IN <= x"FFFFFF";wait for 2*period;
		--Enabling the register
		WE <= '1'; wait for 2*period;
		WE <= '0';
		
		REG_A_IN_ADDR <= x"1";

		WE <= '1'; wait for 2*period;
		WE <= '0';	
		
		REG_B_ADDR <= x"1"; wait for 50*period;
		

	end process;

end Behavioral;

