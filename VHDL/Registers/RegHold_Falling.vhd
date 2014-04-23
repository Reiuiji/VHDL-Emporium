------------------------------------------------------------
-- School:     University of Massachusetts Dartmouth      --
-- Department: Computer and Electrical Engineering        --
-- Class:      ECE 368 Digital Design                     --
-- Engineer:   Daniel Noyes                               --
--             Massarrah Tannous                          --
------------------------------------------------------------
--
-- Create Date:    Spring 2014
-- Module Name:    24bit_Register
-- Project Name:   UMD-RISC 24
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
--
-- Description:
--      Code was modified from Presenation Code: Dr.Fortier(c)
--      24 bit register with a hold lock the input state just
--        incase input conflict later
--
-- Notes:
--      HOLD Clocked on FALLING EDGE
--		OUTPUT Clocked on rising EDGE
--
-- Revision: 
--      0.01  - File Created
--      0.02  - Cleaned up Code given
--      0.03  - Incorporated a enable switch
--      0.04  - Have the register latch data on the falling 
--              clock cycle.
--      0.05  - Forked and added a input hold for the register
--
-- Additional Comments: 
--      The register latches it's output data on the Rising edge
--      Hold latch on the falling edge
--      The main reason why I included a hold latch was to Prevent
--          Any register transfer faults that could occur.
--          Mostly acts as a safety buffer.
-- 
-----------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.UMDRISC_pkg.ALL;

ENTITY RegHold_F IS

	PORT(
		Clock	: IN 	STD_LOGIC;
		Resetn	: IN	STD_LOGIC;
		ENABLE	: IN	STD_LOGIC;
		INPUT	: IN	STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
		OUTPUT	: OUT 	STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
	);

END RegHold_F;

ARCHITECTURE Behavior OF RegHold_F IS

SIGNAL HOLD : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0) := (OTHERS => '0');

BEGIN

	PROCESS(Resetn, Clock,ENABLE)
	BEGIN
		IF Resetn = '0' THEN
			HOLD <= (OTHERS => '0');
			OUTPUT <= (OTHERS => '0');
		ELSIF ENABLE = '1' THEN
			IF Clock'EVENT AND Clock = '1' THEN
					OUTPUT <= HOLD;
			END IF;
			IF Clock'EVENT AND Clock = '0' THEN
					HOLD <= INPUT;
			END IF;
		END IF;
	END PROCESS;

END Behavior;
