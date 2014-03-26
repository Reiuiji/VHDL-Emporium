library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter is
	GENERIC(
		COUNT_WIDTH:INTEGER := 24--;
		--MEM_LIMIT:INTEGER := 8* 256 -- 256 Bytes
	);

	Port (
		CLOCK				: in	STD_LOGIC;
		RESET				: in	STD_LOGIC;
		ENABLE				: in	STD_LOGIC;
		PROGRAM_COUNTER		: out	STD_LOGIC_VECTOR (COUNT_WIDTH-1 downto 0)
	);
			   
end counter;

architecture Behavioral of counter is

signal PC : std_logic_vector(COUNT_WIDTH-1 downto 0):= (others => '0'); --<= (others <= "0"); -- Program Counter

begin
	process (CLOCK, RESET)
	begin
		if (RESET = '1') then 
			PC <= (OTHERS => '0');
		elsif CLOCK = '0' and CLOCK'event then
			if ENABLE = '1' then
				if PC = x"FF" then --MEM_LIMIT) then
					PC <= (OTHERS => '0');
				else
					PC <= PC + 1;
				end if;
			end if;
		end if;
	end process;
	PROGRAM_COUNTER <= PC;
end Behavioral;
