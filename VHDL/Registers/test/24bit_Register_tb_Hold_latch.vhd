LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;

USE work.UMDRISC_pkg.ALL;

entity RegR_LATCH_tb is
end RegR_LATCH_tb;

architecture Behavioral of RegR_LATCH_tb is

	component RegR_LATCH is

	PORT(
		Clock	: IN 	STD_LOGIC;
		Resetn	: IN	STD_LOGIC;
		ENABLE	: IN	STD_LOGIC;
		INPUT		: IN	STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
		HOLD_OUT : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
		OUTPUT		: OUT 	STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0) 
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
	
	--DEBUG TO SEE THE OUTPUT OF HOLD
	signal H : STD_LOGIC_VECTOR(23 DOWNTO 0) := (OTHERS => '0');
	signal H2 : STD_LOGIC_VECTOR(23 DOWNTO 0) := (OTHERS => '0');
	signal H3 : STD_LOGIC_VECTOR(23 DOWNTO 0) := (OTHERS => '0');
	signal H4 : STD_LOGIC_VECTOR(23 DOWNTO 0) := (OTHERS => '0');

	constant period : time := 10 ns;

begin

	-- Register 1
	Reg1: RegR_LATCH port map(
		CLOCK => Clock,
		RESETN => Resetn,
		ENABLE => ENABLE,
		INPUT => D,
		HOLD_OUT => H,
		OUTPUT => Q
	);
	-- Register 2
	Reg2: RegR_LATCH port map(
		CLOCK => Clock,
		RESETN => Resetn,
		ENABLE => ENABLE,
		INPUT => Q,
		HOLD_OUT => H2,
		OUTPUT => Q2
	);
	-- Register 3
	Reg3: RegR_LATCH port map(
		CLOCK => Clock,
		RESETN => Resetn,
		ENABLE => ENABLE,
		INPUT => Q2,
		HOLD_OUT => H3,
		OUTPUT => Q3
	);
	-- Register 4
	Reg4: RegR_LATCH port map(
		CLOCK => Clock,
		RESETN => Resetn,
		ENABLE => ENABLE,
		INPUT => Q3,
		HOLD_OUT => H4,
		OUTPUT => Q4
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
