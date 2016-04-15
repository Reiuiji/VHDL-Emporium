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
-- Description: Register Bank with interupt mode
--   When the system enters interupt mode the 
--    registers will swapped with a temporal
--    register bank that will only last till
--    interupt mode is complete and will resume
--    previous register bank.
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.ALL;

entity RegBankInt is
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
        RegIN_WE    : in  STD_LOGIC;
        -- Interupt Mode
        RegIntMode  : in  STD_LOGIC
    );
end RegBankInt;

architecture Behavioral of RegBankInt is

signal RA,RAI : STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
signal RB,RBI : STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);

type Reg_Array_Type is array (0 to 15) of STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
signal RegArray: Reg_Array_Type;
signal IntRegArray: Reg_Array_Type;

begin

--Reg A
RA <= RegArray(to_integer(unsigned(RegA_Sel)));
--Reg B
RB <= RegArray(to_integer(unsigned(RegB_Sel)));
--Reg A Interupt Bank
RAI <= IntRegArray(to_integer(unsigned(RegA_Sel)));
--Reg B Interupt Bank
RBI <= IntRegArray(to_integer(unsigned(RegB_Sel)));

  --Process to handle updates of the register bank
  process(RST,CLK)
  begin
    if (RST = '1') then
      RegArray <= (OTHERS => (OTHERS => '0'));
      IntRegArray <= (OTHERS => (OTHERS => '0'));
    elsif (clk'event and clk='1') then
      if (RegIntMode = '0') then
        if (RegIN_WE = '1') then
          RegArray(to_integer(unsigned(RegIN_Sel))) <= RegIN;
        end if;
        IntRegArray <= (OTHERS => (OTHERS => '0'));
      else
        if (RegIN_WE = '1') then
          IntRegArray(to_integer(unsigned(RegIN_Sel))) <= RegIN;
        end if;
      end if;
    end if;
  end process;

  --Select which bank is being used
  WITH RegIntMode SELECT
    RegA  <=  RA  WHEN '0',
              RAI WHEN '1',
              RA  WHEN OTHERS;
  WITH RegIntMode SELECT
    RegB  <=  RB  WHEN '0',
              RBI WHEN '1',
              RB  WHEN OTHERS;

end Behavioral;

