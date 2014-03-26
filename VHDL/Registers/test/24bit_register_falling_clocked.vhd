------------------------------------------------------------
-- Notes:
--      Clock on FALLING EDGE
--
-- Revision: 
--      0.01  - File Created
--      0.02  - Cleaned up Code given
--      0.03  - Incorporated a enable switch
--      0.04  - Have the register latch data on the falling 
--              clock cycle.
--
-- Additional Comments: 
--      The register latches it's data on the FALLING edge
-- 
-----------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use UMDRISC.ALL;

ENTITY Reg24 IS

	PORT(
		Clock	: IN 	STD_LOGIC;
		Resetn	: IN	STD_LOGIC;
		ENABLE	: IN	STD_LOGIC;
		D		: IN	STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
		Q		: OUT 	STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0) 
	);
END Reg24;

ARCHITECTURE Behavior OF Reg24 IS	

BEGIN

	PROCESS(Resetn, Clock)
	BEGIN
		IF Resetn = '0' THEN
			Q <= (OTHERS => '0');
		ELSIF Clock'EVENT AND Clock = '0' THEN
			IF ENABLE = '1' THEN
				Q <= D;
			END IF;
		END IF;
	END PROCESS;

END Behavior;
