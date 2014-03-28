--------------------------------------------------------------------------------
-- Company: 	  UMD ECE
-- Engineers:	  Benjamin Doiron
--
-- Create Date:   12:35:25 03/26/2014
-- Design Name:   Data To Ascii
-- Module Name:   data_to_ascii
-- Project Name:  Risc Machine Project 1
-- Target Device: Spartan 3E Board
-- Tool versions: Xilinx 14.7
-- Description:   This code takes in output data from the FPU and
-- begins the process of outputting it to screen. Data is sent through
-- and each grouping of hex data is read individually. Data is collected and
-- sent to the VGA as though it were keyboard data.
--
-- Currently this is in modification and will change drastically to suit
-- the needs of the lab.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: N/A
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_to_ascii is
	Port (  
			clk 	  : in STD_LOGIC;
			IN_DATA   : in STD_LOGIC_VECTOR (23 downto 0);
			OUT_ASCII : out STD_LOGIC_VECTOR (7 downto 0);
			debugoutput : out STD_LOGIC_VECTOR (7 downto 0)
		);
end data_to_ascii;

architecture Behavioral of data_to_ascii is

signal counter: integer range 0 to 6;
signal datacode : STD_LOGIC_VECTOR(3 downto 0);
signal output : STD_LOGIC_VECTOR (7 downto 0);

begin
process(clk)
	begin
	if(clk'event and clk = '1') then

		case counter is
			when 0 => datacode <= IN_DATA (23 downto 20);
			when 1 => datacode <= IN_DATA (19 downto 16);
			when 2 => datacode <= IN_DATA (15 downto 12);
			when 3 => datacode <= IN_DATA (11 downto  8);
			when 4 => datacode <= IN_DATA ( 7 downto  4);
			when others => datacode <= IN_DATA ( 3 downto  0);
		end case;
		
		case datacode is
			when x"0" 	=> output <= x"30";	 
			when x"1"  	=> output <= x"31";	
			when x"2"  	=> output <= x"32";	
			when x"3"  	=> output <= x"33"; 	
			when x"4"  	=> output <= x"34"; 	
			when x"5"  	=> output <= x"35"; 	
			when x"6"  	=> output <= x"36"; 	
			when x"7"  	=> output <= x"37"; 	
			when x"8"  	=> output <= x"38"; 	
			when x"9"  	=> output <= x"39"; 	
			when x"A"	=> output <= x"41"; 
			when x"B"	=> output <= x"42"; 
			when x"C"	=> output <= x"43"; 
			when x"D"	=> output <= x"44"; 
			when x"E"	=> output <= x"45"; 
			when x"F"	=> output <= x"46"; 
			when others	=> output <= x"00"; 
		end case;

		debugoutput <= output;
		
		if (output > x"00") then
			OUT_ASCII <= output;
		end if;

		if (counter > 4) then
			counter <= counter + 1;
		else
			counter <= 0;
		end if;

	end if;
end process;	
-- There needs to be something that prevents it from reading the same data over and over
-- maybe a flag saying when new dats is sent out?
-- Then maybe we could put the data into a buffer or something.
-- Right now there could be issues.

end Behavioral;