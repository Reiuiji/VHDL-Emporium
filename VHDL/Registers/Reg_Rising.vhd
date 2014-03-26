------------------------------------------------------------
-- Notes:
--      Clocked on RISING EDGE
--
-- Revision: 
--      0.01  - File Created
--      0.02  - Cleaned up Code given
--      0.03  - Incorporated a enable switch
--      0.04  - Have the register latch data on the rising 
--              clock cycle.
--
-- Additional Comments: 
--      The register latches it's data on the RISING edge
-- 
-----------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE work.UMDRISC_pkg.ALL;

ENTITY RegR IS

	PORT(
		Clock	: IN 	STD_LOGIC;
		Resetn	: IN	STD_LOGIC;
		ENABLE	: IN	STD_LOGIC;
		INPUT	: IN	STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
		OUTPUT	: OUT 	STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0) 
	);

END RegR;

ARCHITECTURE Behavior OF RegR IS	

BEGIN

	PROCESS(Resetn, Clock)
	BEGIN
		IF Resetn = '0' THEN
			OUTPUT <= (OTHERS => '0');
		ELSIF ENABLE = '1' THEN
			IF Clock'EVENT AND Clock = '1' THEN
				OUTPUT <= INPUT;
			END IF;
		END IF;
	END PROCESS;

END Behavior;
