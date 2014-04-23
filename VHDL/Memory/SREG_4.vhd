------------------------------------------------------------
-- School:     University of Massachusetts Dartmouth      --
-- Department: Computer and Electrical Engineering        --
-- Class:      ECE 368 Digital Design                     --
-- Engineer:   Daniel Noyes                               --
--             Massarrah Tannous                          --
------------------------------------------------------------
--
-- Create Date:    Spring 2014
-- Module Name:    GenReg_16
-- Project Name:   UMD-RISC 24
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
--
-- Description:
--      Code was modified from Handout Code: Dr.Fortier(c)
--      16 General Purpose Registers
--
-- Notes:
--      [Insert Notes]
--
-- Revision: 
--      0.01  - File Created
--      0.02  - Incorporated a memory init [1]
--
-- Additional Comments: 
--      [1]: code adaptive from the following blog
--          http://myfpgablog.blogspot.com/2011/12/memory-initialization-methods.html
--          this site pointed to XST user guide
-- 
-----------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SREG_4 is
	generic(
		REGS_WIDTH:	integer:=2; -- select between 4 different possible registers
		DATA_WIDTH: integer:=24
	);
	port(
		CLOCK			: in std_logic;
		SR_WE				: in std_logic;
		--RESETN			: in std_logic;
		--Register OUT
		SR_SEL		: in std_logic_vector(REGS_WIDTH-1 downto 0);
		SR_OUT			: out std_logic_vector(DATA_WIDTH-1 downto 0);
		--CHANGE REGISTER
		SR_IN_SEL	: in std_logic_vector(REGS_WIDTH-1 downto 0);
		SR_IN		: in std_logic_vector(DATA_WIDTH-1 downto 0)
   );
end SREG_4;

architecture REG_S_ARCH of SREG_4 is

	type	ram_type is array (0 to 2**REGS_WIDTH-1) of std_logic_vector (DATA_WIDTH-1 downto 0);
    signal ram: ram_type := (
        x"000000",  -- 0
        x"000000",  -- 1
        x"000000",  -- 2
        x"000000"   -- 3
	);


	signal	ADDR_S_REG: std_logic_vector(REGS_WIDTH-1 downto 0);
	
begin
   process(CLOCK,SR_WE)
   begin
			if (CLOCK'event and CLOCK = '0') then
				if (SR_WE = '1') then
					ram(to_integer(unsigned(SR_IN_SEL))) <= SR_IN;
				end if;
				ADDR_S_REG <= SR_IN_SEL;
			end if;
	end process;
	SR_OUT <= ram(to_integer(unsigned(ADDR_S_REG)));
end REG_S_ARCH;
