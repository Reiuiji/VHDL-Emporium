--------------------------------------------------------------------------------
-- Company: 	  UMD ECE
-- Engineers:	  Benjamin Doiron, Daniel Noyes
--
-- Create Date:   12:35:25 03/26/2014
-- Design Name:   Scan to Hex
-- Module Name:   scan_to_hex
-- Project Name:  Risc Machine Project 1
-- Target Device: Spartan 3E Board
-- Tool versions: Xilinx 14.7
-- Description:   This code takes in keystrokes and places them in a buffer.
-- The buffer is then read into a translator, changing it from scancode to hex values.
-- The hex values are then sent to the FPU once the enter key is pressed.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: N/A
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity scan_to_hex is
    Port ( 
	   Send : in STD_LOGIC; -- tells when input signal happens
		Resetn : in STD_LOGIC;
		scancode : in  STD_LOGIC_VECTOR (7 downto 0);	-- The input code
		output 	: out STD_LOGIC_VECTOR (23 downto 0);	-- The output code
		
		outCount : out STD_LOGIC_VECTOR (3 downto 0);
		hexdebug : out STD_LOGIC_VECTOR (3 downto 0);
		outbufdebug: out STD_LOGIC_VECTOR (63 downto 0)
	);
end scan_to_hex;

architecture Behavioral of scan_to_hex is

--signal Counter : STD_LOGIC_VECTOR(3 downto 0):= (others => '0'); -- range (0 to 15);
signal Counter : integer range 0 to 15; 
signal Hex : STD_LOGIC_VECTOR(3 downto 0);

signal OutB : STD_LOGIC_VECTOR(23 downto 0);
type Buff_type is array (0 to 15)
     of std_logic_vector (3 downto 0);
signal Buff: Buff_type;


begin

outbufdebug(63 downto 60) <= Buff(0);
outbufdebug(59 downto 56) <= Buff(1);
outbufdebug(55 downto 52) <= Buff(2);
outbufdebug(51 downto 48) <= Buff(3);
outbufdebug(47 downto 44) <= Buff(4);
outbufdebug(43 downto 40) <= Buff(5);
outbufdebug(39 downto 36) <= Buff(6);
outbufdebug(35 downto 32) <= Buff(7);
outbufdebug(31 downto 28) <= Buff(8);
outbufdebug(27 downto 24) <= Buff(9);
outbufdebug(23 downto 20) <= Buff(10);
outbufdebug(19 downto 16) <= Buff(11);
outbufdebug(15 downto 12) <= Buff(12);
outbufdebug(11 downto 8) <= Buff(13);
outbufdebug(7 downto 4) <= Buff(14);
outbufdebug(3 downto 0) <= Buff(15);

outCount <= conv_std_logic_vector(counter, 4);

with scancode select
	Hex<=x"0" when x"45",--0
		x"1" when x"16",--1
		x"2" when x"1e",--2
		x"3" when x"26",--3
		x"4" when x"25",--4
		x"5" when x"2e",--5
		x"6" when x"36",--6
		x"7" when x"3d",--7
		x"8" when x"3e",--8
		x"9" when x"46",--9
		x"A" when x"1c",--a
		x"B" when x"32",--b
		x"C" when x"21",--c
		x"D" when x"23",--d
		x"E" when x"24",--e
		x"F" when x"2b",--f
		"ZZZZ" when others;
		
Hexdebug <= Hex;
output <= OutB;
process(Send)
begin
	if Resetn = '0' then
		OutB <= (others => '0');
		Buff <= (others => (others =>'0'));
	else
		-- Keyboard Complete Signal
		if send'event and Send = '0' then
		
			if scancode = X"5A" then -- Enter Key
				OutB(23 downto 20) <= buff(counter - 6);
				OutB(19 downto 16) <= buff(counter - 5);
				OutB(15 downto 12) <= buff(counter - 4);
				OutB(11 downto  8) <= buff(counter - 3);
				OutB(7  downto  4) <= buff(counter - 2);
				OutB(3  downto  0) <= buff(counter - 1);
			
			else
				if scancode = X"66" then
					counter <= counter - 1;
				else
					buff(counter) <= Hex;
					counter <= counter + 1;
				end if;
			end if;
		end if;
	end if;

end process;

--				"1111111" when x"66",--	backspace : Initially 1111111, changed to 0001000 due to lab
--											-- changed back, brandyn didn't have errors.
--				"1111111" when x"29",--space bar
--				"0000000" when others;	 
end Behavioral;

