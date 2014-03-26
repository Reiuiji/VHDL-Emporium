library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

entity Reg24_tb is
end Reg24_tb;

architecture Behavioral of Reg24_tb is

	component Reg24 is

	GENERIC(
		DATA_WIDTH:INTEGER := 24
	);

	PORT(
		Clock	: IN 	STD_LOGIC;
		Resetn	: IN	STD_LOGIC;
		ENABLE	: IN	STD_LOGIC;
		D		: IN	STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
		Q		: OUT 	STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0) 
	);

	end component;

	signal CLOCK : STD_LOGIC := '0';
	signal RESETN : STD_LOGIC := '0';
	signal ENABLE : STD_LOGIC := '0';
	signal D : STD_LOGIC_VECTOR(23 DOWNTO 0) := (OTHERS => '0');
	signal Q : STD_LOGIC_VECTOR(23 DOWNTO 0) := (OTHERS => '0');
	signal Q2 : STD_LOGIC_VECTOR(23 DOWNTO 0) := (OTHERS => '0');
	signal Q3 : STD_LOGIC_VECTOR(23 DOWNTO 0) := (OTHERS => '0');
	signal Q4 : STD_LOGIC_VECTOR(23 DOWNTO 0) := (OTHERS => '0');

	constant period : time := 10 ns;

begin

	-- Register 1
	Reg1: Reg24 port map(
		CLOCK => Clock,
		RESETN => Resetn,
		ENABLE => ENABLE,
		D => D,
		Q => Q
	);
	-- Register 2
	Reg2: Reg24 port map(
		CLOCK => Clock,
		RESETN => Resetn,
		ENABLE => ENABLE,
		D => Q,
		Q => Q2
	);
	-- Register 3
	Reg3: Reg24 port map(
		CLOCK => Clock,
		RESETN => Resetn,
		ENABLE => ENABLE,
		D => Q2,
		Q => Q3
	);
	-- Register 4
	Reg4: Reg24 port map(
		CLOCK => Clock,
		RESETN => Resetn,
		ENABLE => ENABLE,
		D => Q3,
		Q => Q4
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
		report "Starting [name] Test Bench" severity NOTE;

		----- Unit Test -----
		--Reset disable
		RESETN <= '1'; wait for period;
		assert (Q = 00)  report "Failed READ. [OUT_Port0]=" & integer'image(to_integer(unsigned(Q))) severity ERROR;
		
		D <= x"FFFFFF";
		
		--Enabling the register
		ENABLE <= '1'; wait for 2*period;
		-- Test each input via loop
		for i in 0 to 256 loop 
				D <= std_logic_vector(to_signed(i,D'length)); wait for 2*period;
		end loop;

	end process;

end Behavioral;
