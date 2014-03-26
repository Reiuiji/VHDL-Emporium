library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.UMDRISC_pkg.ALL;

entity MUX_2to1 is

	Port (
		SEL		: in   STD_LOGIC; -- 2 bits
		IN_1	: in   STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
		IN_2	: in   STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
		OUTPUT	: out  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0)
	);

end MUX_2to1;

architecture Behavioral of MUX_2to1 is

begin

OUTPUT<=IN_1 when SEL='0' ELSE IN_2;

end Behavioral;
