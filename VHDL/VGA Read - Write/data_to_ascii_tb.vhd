--------------------------------------------------------------------------------
-- Company: 	  UMD ECE
-- Engineers:	  Benjamin Doiron
--
-- Create Date:   12:35:25 03/26/2014
-- Design Name:   Data To ASCII Testbench
-- Module Name:   data_to_ascii_tb
-- Project Name:  Risc Machine Project 1
-- Target Device: Spartan 3E Board
-- Tool versions: Xilinx 14.7
-- Description:   This is the test bench for the data_to_ascii
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY data_to_ascii_tb IS
END data_to_ascii_tb;
 
ARCHITECTURE behavior OF data_to_ascii_tb IS 
 
    COMPONENT data_to_ascii
    PORT(
			clk: IN std_logic;
         IN_DATA : IN  std_logic_vector(23 downto 0);
         OUT_ASCII : OUT  std_logic_vector(7 downto 0);
			debugoutput : out STD_LOGIC_VECTOR (7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
	signal clk: std_logic :='0';
   signal IN_DATA : std_logic_vector(23 downto 0) := (others => '0');

 	--Outputs
   signal OUT_ASCII : std_logic_vector(7 downto 0);
	signal debugoutput: std_logic_vector(7 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: data_to_ascii PORT MAP (
			 clk => clk,
          IN_DATA => IN_DATA,
          OUT_ASCII => OUT_ASCII,
			 debugoutput => debugoutput
        ); 

   -- Stimulus process
   stim_proc: process
   begin			
		wait for 20 ns;
		clk <= '1';
		IN_DATA (23 downto 20) <= x"0";
		IN_DATA (19 downto 16) <= x"2";
		IN_DATA (15 downto 12) <= x"A";
		IN_DATA (11 downto  8) <= x"B";
		IN_DATA ( 7 downto  4) <= x"C";
		IN_DATA ( 3 downto  0) <= "ZZZZ";
		wait for 20 ns;
		clk <= '0';
		wait for 20 ns;
		clk <= '1';
		wait for 20 ns;
		clk <= '0';
		wait for 20 ns;
		clk <= '1';
		wait for 20 ns;
		clk <= '0';
		wait for 20 ns;
		clk <= '1';
		wait for 20 ns;
		clk <= '0';
		wait for 20 ns;
		clk <= '1';
		wait for 20 ns;
		clk <= '0';
		wait for 20 ns;
		clk <= '1';
		wait for 20 ns;
		clk <= '0';
		wait for 20 ns;
		clk <= '1';
      wait;
   end process;

END;
