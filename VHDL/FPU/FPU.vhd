library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
USE work.UMDRISC_pkg.ALL;

entity FPU is
	PORT (
		--INPUT 
		CLOCK 			: in STD_LOGIC;
		RESETN			: in STD_LOGIC;
		ENABLE			: in STD_LOGIC;

		-- Data from T1
		IMMED 			: IN STD_LOGIC_VECTOR(DATA_WIDTH-13 DOWNTO 0); --[11:0] 12 bits
		SIGNED_IMMED	: IN STD_LOGIC_VECTOR(DATA_WIDTH-9 DOWNTO 0); --[15:0] 16 bits

		--input Register
		REG_DATA_IN		: in STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0); -- Register Data input for general and shadow reg

		--CONTROL INPUT SIGNALS
		--General Purpose Register interface
		SRC1			: in STD_LOGIC_VECTOR(3 DOWNTO 0); -- General purpose Reg A Address
		SRC2			: in STD_LOGIC_VECTOR(3 DOWNTO 0); -- General purpose Reg B Address
		GP_DIN_SEL		: in STD_LOGIC_VECTOR(3 DOWNTO 0); -- Reg Address to write to
		GP_WE			: in STD_LOGIC; -- write enable for general purpose register
		--Shadow Register
		SR_SEL 			: in STD_LOGIC_VECTOR(1 DOWNTO 0); -- Shadow Register Select
		SR_DIN_SEL		: in STD_LOGIC_VECTOR(1 DOWNTO 0); -- Shadow Register to write to
		SR_WE			: in STD_LOGIC; -- write enable for shadow register
		--MUX's
		SRC0_SEL		: in STD_LOGIC; -- Select between immed and signed extension
		SRC1_MUX		: in STD_LOGIC;--_VECTOR(1 DOWNTO 0); -- Select between PC, RA, SR, DST_ADDR (4 select)
		SRC2_MUX		: in STD_LOGIC; -- Select between immed or Reg B (2 select)
		--ALU
		ALU_OPCODE		: in STD_LOGIC_VECTOR(3 DOWNTO 0); -- OPCODE for the ALU
		-- Program Counter
		--PC				: IN STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0); --Program Counter

		--OUTPUT
		STORE_DATA		: OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0); --Destination Data
		DST_ADDR		: OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0); --Destination Address
		ALU_OUT			: OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
		LDST_OUT		: OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0); -- output the load / store on the ALU 
		CCR				: OUT STD_LOGIC_VECTOR(3 DOWNTO 0) --Condition Code Register (ALU)

	);
end FPU;

architecture Structural of FPU is

---------- MUX ---------- ---------- ----------
component MUX_2to1 is
	Port (
		SEL		: in   STD_LOGIC;
		IN_1	: in   STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
		IN_2	: in   STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
		OUTPUT	: out  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0)
	);
end component;

component MUX_3to1 is
	Port (
		SEL		: in   STD_LOGIC_VECTOR (1 downto 0);
		IN_1	: in   STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
		IN_2	: in   STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
		IN_3	: in   STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
		OUTPUT	: out  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0)
	);
end component;

component MUX_4to1 is
	Port (
		SEL		: in   STD_LOGIC_VECTOR (1 downto 0);
		IN_1	: in   STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
		IN_2	: in   STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
		IN_3	: in   STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
		IN_4	: in   STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
		OUTPUT	: out  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0)
	);
end component;

---------- REG ---------- ---------- ----------
--Register Latch on Rising Edge
component RegR IS
	PORT(
		Clock	: IN 	STD_LOGIC;
		Resetn	: IN	STD_LOGIC;
		ENABLE	: IN	STD_LOGIC;
		INPUT	: IN	STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
		OUTPUT	: OUT 	STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0) 
	);
end component;
--Register Latch on Falling Edge
component RegF IS
	PORT(
		Clock	: IN 	STD_LOGIC;
		Resetn	: IN	STD_LOGIC;
		ENABLE	: IN	STD_LOGIC;
		INPUT	: IN	STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
		OUTPUT	: OUT 	STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0) 
	);
end component;
--Register With a Hold(Latch on Falling) while Reg Latch Rising Edge
component RegHold_F IS
	PORT(
		Clock	: IN 	STD_LOGIC;
		Resetn	: IN	STD_LOGIC;
		ENABLE	: IN	STD_LOGIC;
		INPUT	: IN	STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
		OUTPUT	: OUT 	STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
	);
end component;

--4bit Register Latch on Rising Edge
component Reg4R IS

	PORT(
		Clock	: IN 	STD_LOGIC;
		Resetn	: IN	STD_LOGIC;
		ENABLE	: IN	STD_LOGIC;
		INPUT	: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		OUTPUT	: OUT 	STD_LOGIC_VECTOR(3 DOWNTO 0) 
	);
end component;

-------- 16 24bit General Purpose Reg ---------
component REG_S16 is
	generic(
		REG_WIDTH:	integer:=4 -- select between 16 different possible registers
	);
	port(
		CLOCK			: in std_logic;
		WE				: in std_logic;
		--RESETN			: in std_logic;
		--Register A
		REG_A_ADDR		: in std_logic_vector(REG_WIDTH-1 downto 0);
		REG_A			: out std_logic_vector(DATA_WIDTH-1 downto 0);
		--Register B
		REG_B_ADDR		: in std_logic_vector(REG_WIDTH-1 downto 0);
		REG_B			: out std_logic_vector(DATA_WIDTH-1 downto 0);
		--CHANGE REGISTER
		REG_A_IN_ADDR	: in std_logic_vector(REG_WIDTH-1 downto 0);
		REG_A_IN		: in std_logic_vector(DATA_WIDTH-1 downto 0)
   );
end component;

---------- 4 24bit Shadow Reg------- ----------
component SREG_4 is
	generic(
		REGS_WIDTH:	integer:=2 -- select between 4 different possible registers
	);
	port(
		CLOCK			: in std_logic;
		SR_WE			: in std_logic;
--		RESETN			: in std_logic;
		--Shadow Register
		SR_SEL			: in std_logic_vector(REGS_WIDTH-1 downto 0);
		SR_OUT			: out std_logic_vector(DATA_WIDTH-1 downto 0);
		--CHANGE REGISTER
		SR_IN_SEL		: in std_logic_vector(REGS_WIDTH-1 downto 0);
		SR_IN			: in std_logic_vector(DATA_WIDTH-1 downto 0)
   );
end component;

---------- ALU ---------- ---------- ----------
component ALU is
	Port (
		CLOCK		: in	STD_LOGIC;
		RA		: in	STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
		RB		: in	STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
		OPCODE	: in	STD_LOGIC_VECTOR (3 downto 0);
		CCR		: out	STD_LOGIC_VECTOR (3 downto 0);	-- Condition Codes (N,Z,V,C)
		ALU_OUT	: out	STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
		LDST_OUT: out	STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0) -- Output from the Load/Store Routine
	);
end component;

---------- SIGNALS ------ ---------- ----------

signal IMMEDS,SIGN,IM_OUT : STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
signal IMMED0, SIG_EXT0 : STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
signal SR_OUT,IM_RB,DST_ADDRS,SD_RA : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
signal SRC1_S, SRC2_S : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
signal CCR_OUT : STD_LOGIC_VECTOR(3 downto 0);
signal OPERAND0, OPERAND1, OPERAND2 : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
--signal PC0 : STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);

signal DST_DATA_OUT : STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
signal ALU0 : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0); --,LDST_OUT

begin
IMMED0 <= std_logic_vector(resize(unsigned(IMMED), IMMED0'length));
SIG_EXT0 <= std_logic_vector(resize(unsigned(SIGNED_IMMED), SIGNED_IMMED'length));
--PC0 <= std_logic_vector(resize(unsigned(PC), PC0'length));
DST_ADDR <= DST_ADDRS;

U_IMMED: RegF PORT MAP (
	Clock				=> CLOCK,
	RESETN				=> RESETN,
	ENABLE				=> ENABLE,
	INPUT				=> IMMED0,
	OUTPUT				=> IMMEDS
);

U_SIGN_EXT: RegF PORT MAP (
	Clock				=> CLOCK,
	RESETN				=> RESETN,
	ENABLE				=> ENABLE,
	INPUT				=> SIG_EXT0,
	OUTPUT				=> SIGN
);

U_IM_MUX: MUX_2to1 PORT MAP (
	SEL		=> SRC0_SEL,
	IN_1	=> IMMEDS,
	IN_2	=> SIGN,
	OUTPUT	=> IM_OUT
);

U_REG16TGT: REG_S16 PORT MAP (
	CLOCK			=> CLOCK,
	--RESETN			=> RESETN,
	WE				=> GP_WE,
	REG_A_ADDR		=> SRC1,
	REG_A			=> SRC1_S,
	REG_B_ADDR		=> SRC2,
	REG_B			=> SRC2_S,
	REG_A_IN_ADDR	=> GP_DIN_SEL,
	REG_A_IN		=> REG_DATA_IN
);

U_REG_SHADOW: SREG_4 PORT MAP (
	CLOCK	=> CLOCK,
	--RESETN	=> RESETN,
	SR_WE	=> SR_WE,
	SR_IN_SEL => SR_DIN_SEL,
	SR_IN	=> REG_DATA_IN,
	SR_SEL	=> SR_SEL,
	SR_OUT	=> SR_OUT
);

U_Operand0: RegR PORT MAP (
	Clock	=> CLOCK,
	RESETN	=> RESETN,
	ENABLE	=> ENABLE,
	INPUT	=> IM_OUT,
	OUTPUT	=> Operand0
);

U_Operand1: RegR PORT MAP (
	Clock	=> CLOCK,
	RESETN	=> RESETN,
	ENABLE	=> ENABLE,
	INPUT	=> SRC1_S,
	OUTPUT	=> Operand1
);

U_Operand2: RegR PORT MAP (
	Clock	=> CLOCK,
	RESETN	=> RESETN,
	ENABLE	=> ENABLE,
	INPUT	=> SRC2_S,
	OUTPUT	=> Operand2
);

U_IM_RB_MUX: MUX_2to1 PORT MAP (
	SEL		=> SRC2_MUX,
	IN_1	=> Operand0,
	IN_2	=> Operand2,
	OUTPUT	=> IM_RB
);

U_SD_RA_MUX: MUX_2to1 PORT MAP (
	SEL		=> SRC1_MUX,
	IN_1	=> Operand1,
	IN_2	=> SR_OUT,
	OUTPUT	=> SD_RA
);
--U_SD_RA_MUX: MUX_4to1 PORT MAP (
--	SEL		=> SRC1_MUX,
--	IN_1	=> Operand1,
--	IN_2	=> SR_OUT,
--	IN_3	=> DST_ADDRS,
--	IN_4	=> PC0,
--	OUTPUT	=> SD_RA
--);

U_ALU: ALU PORT MAP (
	CLOCK		=> CLOCK,
	RA			=> SD_RA,
	RB			=> IM_RB,
	OPCODE		=> ALU_OPCODE,
	CCR			=> CCR_OUT,
	ALU_OUT		=> ALU0,
	LDST_OUT	=> LDST_OUT
);

U_NZVC_REG: Reg4R PORT MAP (
	Clock	=> CLOCK,
	RESETN	=> RESETN,
	ENABLE	=> ENABLE,
	INPUT	=> CCR_OUT,
	OUTPUT	=> CCR
);

U_STORE_DATA: RegHold_F PORT MAP (
	Clock	=> CLOCK,
	RESETN	=> RESETN,
	ENABLE	=> ENABLE,
	INPUT	=> IM_RB,
	OUTPUT	=> STORE_DATA
);

U_ALU_OUT: RegR PORT MAP (
	Clock	=> CLOCK,
	RESETN	=> RESETN,
	ENABLE	=> ENABLE,
	INPUT	=> ALU0,
	OUTPUT	=> ALU_OUT
);

U_DST_ADDR: RegHold_F PORT MAP (
	Clock	=> CLOCK,
	RESETN	=> RESETN,
	ENABLE	=> ENABLE,
	INPUT	=> Operand1,
	OUTPUT	=> DST_ADDRS
);

end Structural;

