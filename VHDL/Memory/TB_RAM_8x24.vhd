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

entity TB_RAM_8x24 is
end TB_RAM_8x24;

architecture Behavioral of TB_RAM_8x24 is

component RAM_8x24 is
	generic(
		RAM_WIDTH:	integer:=8; -- 00 - FF choice
		DATA_WIDTH: integer:=24
	);
	port(
		CLOCK			: in std_logic;
		WE				: in std_logic;
		--RESETN			: in std_logic;
        --OUTPUT RAM
		OUT_ADDR		: in std_logic_vector(RAM_WIDTH-1 downto 0);
		OUT_DATA		: out std_logic_vector(DATA_WIDTH-1 downto 0);
		--INPUT RAM
		IN_ADDR		    : in std_logic_vector(RAM_WIDTH-1 downto 0);
		IN_DATA			: in std_logic_vector(DATA_WIDTH-1 downto 0)
   );

	end component;
	
	CONSTANT RAM_WIDTH:integer:=8;

	signal CLOCK 			: STD_LOGIC := '0';
	signal WE 	: STD_LOGIC := '0';
	signal IN_ADDR		: std_logic_vector(RAM_WIDTH-1 downto 0);
	signal IN_DATA			: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal OUT_ADDR		: std_logic_vector(RAM_WIDTH-1 downto 0);
	signal OUT_DATA			: std_logic_vector(DATA_WIDTH-1 downto 0);

	constant period : time := 10 ns;

begin

	-- 15 24bit General purpose register
	Reg1: RAM_8x24 port map(
		CLOCK => Clock,
		WE => WE,
		IN_ADDR => IN_ADDR,
		IN_DATA => IN_DATA,
		OUT_ADDR => OUT_ADDR,
		OUT_DATA => OUT_DATA
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
		IN_ADDR <= (others => '0');
		OUT_ADDR <= (others => '0');

		IN_DATA <= x"FFFFFF";wait for 2*period;
		--Enabling the register
		WE <= '1'; wait for 2*period;
		WE <= '0';
		
		IN_ADDR <= x"01";

		WE <= '1'; wait for 2*period;
		WE <= '0';	
		
		IN_DATA <= x"333333"; wait for 50*period;
		IN_ADDR <= x"01";

		WE <= '1'; wait for 2*period;
		WE <= '0';

        OUT_ADDR <= X"01"; wait for 2*period;
        OUT_ADDR <= X"02";
		

	end process;

end Behavioral;

