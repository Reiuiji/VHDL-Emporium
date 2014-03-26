library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

entity counter_tb is
	generic(
		COUNT_WIDTH:integer:=24
	);
end counter_tb;

architecture Behavioral of counter_tb is

	
	component counter is

	generic(
		COUNT_WIDTH:integer:=24
	);

	port (
		CLOCK				: in	STD_LOGIC;
		RESET				: in	STD_LOGIC;
		ENABLE				: in	STD_LOGIC;
		PROGRAM_COUNTER		: out	STD_LOGIC_VECTOR (COUNT_WIDTH-1 downto 0)
	);
	end component;

	signal CLOCK : STD_LOGIC := '0';
	signal ENABLE: STD_LOGIC := '0';
	signal RESET : STD_LOGIC := '0';
	signal PROGRAM_COUNTER : STD_LOGIC_VECTOR (COUNT_WIDTH-1 downto 0);

	constant period : time := 10 ns;

begin

	-- Instantiate the Unit Under Testing (UUT)
	uut: counter port map(
		CLOCK => CLOCK,
		RESET => RESET,
		ENABLE => ENABLE,
		PROGRAM_COUNTER => PROGRAM_COUNTER
	);


	m50MHZ_Clock: process
	begin
		CLOCK <= '0'; wait for period;
		CLOCK <= '1'; wait for period;
	end process m50MHZ_Clock;

	tb : process
	begin
		-- Wait 100 ns for global reset to finish
		wait for 100 ns;
		report "Starting counter Test Bench" severity NOTE;

		----- Unit Test -----
		--Enable
		ENABLE <= '1';
		wait for 100 ns;

		--Reset
		RESET <= '1'; wait for period;
		RESET <= '0';

		-- Test each input via loop
		for i in 0 to 512 loop 
				assert (PROGRAM_COUNTER = i)  report "Failed Counting. PROGRAM_COUNTER=" & integer'image(to_integer(unsigned(PROGRAM_COUNTER))) severity ERROR; wait for 2*period;
		end loop;

		report "Finished counter Test Bench" severity NOTE;

	end process;

end Behavioral;
