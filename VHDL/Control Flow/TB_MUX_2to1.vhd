library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use work.UMDRISC_pkg.ALL;

entity TB_MUX_2to1 is
end TB_MUX_2to1;

architecture Behavioral of TB_MUX_2to1 is

	component MUX_2to1 is

		Port (
			SEL		: in   STD_LOGIC; -- 2 bits
			IN_1	: in   STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
			IN_2	: in   STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
			OUTPUT	: out  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0)
		);

	end component;

	signal SEL		: STD_LOGIC;
	signal IN_1,IN_2	: STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
	signal OUTPUT				: STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);

	constant period : time := 10 ns;

begin

	-- 2 TO 1 MUX
	MUX1: MUX_2to1 port map(
		SEL => SEL,
		IN_1 => IN_1,
		IN_2 => IN_2,
		output => output
	);

	tb : process
	begin
		-- Wait 100 ns for global reset to finish
		wait for 5*period;
		report "Starting [name] Test Bench" severity NOTE;

		--Set up the four inputs
		IN_1 <= x"111111";
		IN_2 <= x"222222";

		--Test the Select for each input
		SEL <= '0'; wait for 2*period;
		SEL <= '1'; wait for 2*period;

	end process;

end Behavioral;


