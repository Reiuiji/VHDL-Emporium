---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2016
-- Module Name:    REGBank
-- Project Name:   REGBank
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Register Bank
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.ALL;

entity RegBank is
    GENERIC (DATA_WIDTH:positive:=16; REG_SIZE:positive:=4);
    PORT (
        CLK         : in  STD_LOGIC;
        RST         : in  STD_LOGIC;
        -- Register A
        RegA_Sel    : in  STD_LOGIC_VECTOR (REG_SIZE-1 downto 0);
        RegA        : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
        -- Register B
        RegB_Sel    : in  STD_LOGIC_VECTOR (REG_SIZE-1 downto 0);
        RegB        : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
        -- Input Register
        RegIN       : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
        RegIN_Sel   : in  STD_LOGIC_VECTOR (REG_SIZE-1 downto 0);
        RegIN_WE    : in  STD_LOGIC
    );
end RegBank;

architecture Behavioral of RegBank is

type Reg_Array_Type is array (0 to 15) of STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
signal RegArray: Reg_Array_Type;

begin

--Reg A
RegA <= RegArray(to_integer(unsigned(RegA_Sel)));
--Reg B
RegB <= RegArray(to_integer(unsigned(RegB_Sel)));

  process(RST,CLK)
  begin
	if (RST = '1') then

		RegArray <= (OTHERS => (OTHERS => '0'));

    elsif (clk'event and clk='1') then
      if (RegIN_WE = '1') then
        RegArray(to_integer(unsigned(RegIN_Sel))) <= RegIN;
      end if;
    end if;
  end process;


end Behavioral;

