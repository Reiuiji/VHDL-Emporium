library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE work.UMDRISC_pkg.ALL;

entity SREG_4 is
	generic(
		REG_WIDTH:	integer:=2 -- select between 4 different possible registers
	);
	port(
		CLOCK			: in std_logic;
		SR_WE			: in std_logic;
		RESETN			: in std_logic;
		--Shadow Register
		SR_SEL			: in std_logic_vector(REG_WIDTH-1 downto 0);
		SR_OUT			: out std_logic_vector(DATA_WIDTH-1 downto 0);
		SR_IN			: in std_logic_vector(DATA_WIDTH-1 downto 0)
   );
end SREG_4;

architecture REG_S_ARCH of SREG_4 is

	type	reg_type is array (0 to 2**REG_WIDTH-1) of std_logic_vector (DATA_WIDTH-1 downto 0);
	signal	registers: reg_type ;

	signal	S_REG_ADDR : std_logic_vector(REG_WIDTH-1 downto 0);
	
begin
   process(CLOCK)
   begin
		if(RESETN = '0') then
			registers <= (others => (others =>'0'));
		else
			if (CLOCK'event and CLOCK = '0') then
				if (SR_WE = '1') then
					registers(to_integer(unsigned(SR_SEL))) <= SR_IN;
				end if;
				S_REG_ADDR <= SR_SEL;
			end if;
		end if;
	end process;
	SR_OUT <= registers(to_integer(unsigned(S_REG_ADDR)));
end REG_S_ARCH;
