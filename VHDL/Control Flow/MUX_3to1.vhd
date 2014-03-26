library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.UMDRISC_pkg.ALL;

entity MUX_3to1 is

	Port (
		SEL		: in   STD_LOGIC_VECTOR (1 downto 0); -- 3 bits
		IN_1	: in   STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
		IN_2	: in   STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
		IN_3	: in   STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
		OUTPUT	: out  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0)
	);

end MUX_3to1;

architecture Behavioral of MUX_3to1 is

signal ZERO : STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0) := (others => '0');

begin

with SEL select
	OUTPUT<=	IN_1 when "00",
				IN_2 when "01",
				IN_3 when "10",
				ZERO when others;
end Behavioral;
