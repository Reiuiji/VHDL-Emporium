--------------------------------------------------------------------------------
-- Company: 	  UMD ECE
-- Engineers:	  Benjamin Doiron, Daniel Noyes
--
-- Create Date:   12:35:25 03/26/2014
-- Design Name:   Scan to Hex Testbench
-- Module Name:   scan_to_hex_tb
-- Project Name:  Risc Machine Project 1
-- Target Device: Spartan 3E Board
-- Tool versions: Xilinx 14.7
-- Description:   This is the testbench for reading scancodes and changing them into hex.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY scan_to_hex_tb IS
END scan_to_hex_tb;
 
ARCHITECTURE behavior OF scan_to_hex_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT scan_to_hex
    PORT(
         Send : IN  std_logic;
         Resetn : IN  std_logic;
         scancode : IN  std_logic_vector(7 downto 0);
         output : OUT  std_logic_vector(23 downto 0);
			outCount : out STD_LOGIC_VECTOR (3 downto 0);
			hexdebug : out STD_LOGIC_VECTOR (3 downto 0);
			outbufdebug : out STD_LOGIC_VECTOR (63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Send : std_logic := '0';
	signal Resetn : std_logic := '0';
   signal scancode : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
	signal hexdebug : std_logic_vector(3 downto 0);
   signal output : std_logic_vector(23 downto 0);
   signal counter : std_logic_vector(3 downto 0);
	signal outbufdebug : STD_LOGIC_VECTOR (63 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: scan_to_hex PORT MAP (
          Send => Send,
			 Resetn => Resetn,
          scancode => scancode,
          output => output,
			 outCount => counter,
			 hexdebug => hexdebug,
			 outbufdebug => outbufdebug
        );


   -- Stimulus process
   stim_proc: process
   begin		
		Resetn <= '1';
		wait for 20 ns;
		send <= '1';
		scancode <= x"16";
		wait for 20 ns;
		send <= '0';
		wait for 20 ns;
		send <= '1';
		scancode <= x"26";		
		wait for 20 ns;
		send <= '0';
		wait for 20 ns;
		send <= '1';
		scancode <= x"16";
		wait for 20 ns;
		send <= '0';
		wait for 20 ns;
		send <= '1';
		scancode <= x"26";		
		wait for 20 ns;
		send <= '0';
		wait for 20 ns;
		send <= '1';
		scancode <= x"16";
		wait for 20 ns;
		send <= '0';
		wait for 20 ns;
		send <= '1';
		scancode <= x"16";
		wait for 20 ns;
		send <= '0';
		wait for 20 ns;
		send <= '1';
		scancode <= x"5A";
		wait for 20 ns;	
		send <= '0';
		
		wait for 20 ns;
		send <= '1';
		scancode <= x"36";
		wait for 20 ns;
		send <= '0';
		wait for 20 ns;
		send <= '1';
		scancode <= x"46";		
		wait for 20 ns;
		send <= '0';
		wait for 20 ns;
		send <= '1';
		scancode <= x"36";
		wait for 20 ns;
		send <= '0';
		wait for 20 ns;
		send <= '1';
		scancode <= x"46";		
		wait for 20 ns;
		send <= '0';
		wait for 20 ns;
		send <= '1';
		scancode <= x"23";
		wait for 20 ns;
		send <= '0';
		wait for 20 ns;
		send <= '1';
		scancode <= x"23";
		wait for 20 ns;
		send <= '0';
		wait for 20 ns;
		send <= '1';
		scancode <= x"5A";
		wait for 20 ns;	
		send <= '0';
		end process;
END;
