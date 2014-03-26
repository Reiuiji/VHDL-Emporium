------------------------------------------------------------
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

ENTITY Reg24_LATCH IS
	GENERIC(
		DATA_WIDTH:INTEGER := 24
	);

	PORT(
		Clock	: IN 	STD_LOGIC;
		Resetn	: IN	STD_LOGIC;
		ENABLE	: IN	STD_LOGIC;
		INPUT	: IN	STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
		HOLD_OUT : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
		OUTPUT	: OUT 	STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
	);
END Reg24_LATCH;

ARCHITECTURE Behavior OF Reg24_LATCH IS

SIGNAL HOLD : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0) := (OTHERS => '0');

BEGIN

HOLD_OUT <= HOLD;

	PROCESS(Resetn, Clock)
	BEGIN
		IF Resetn = '0' THEN
			HOLD <= (OTHERS => '0');
			OUTPUT <= (OTHERS => '0');
		ELSE
			IF (ENABLE = '1') AND Clock'EVENT THEN
				IF Clock = '1' THEN
					OUTPUT <= HOLD;
				ELSE
					HOLD <= INPUT;
				END IF;
			END IF;
		END IF;
	END PROCESS;

END Behavior;
