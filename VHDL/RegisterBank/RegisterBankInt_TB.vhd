---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2016
-- Module Name:    RegBankInt_TB
-- Project Name:   RegBankInt
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Register Bank with interupt mode Test Bench
---------------------------------------------------
LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;
USE ieee.STD_LOGIC_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY RegBankInt_tb IS
    GENERIC (DATA_WIDTH:positive:=16; REG_SIZE:positive:=4);
END RegBankInt_tb;

ARCHITECTURE behavior OF RegBankInt_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT RegBankInt
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
    END COMPONENT;

    --Inputs
    SIGNAL CLK     : STD_LOGIC := '0';
    SIGNAL RST     : STD_LOGIC := '0';

    -- Register A
    SIGNAL RegA_Sel    : STD_LOGIC_VECTOR (REG_SIZE-1 downto 0):= (others=>'0');
    SIGNAL RegA        : STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0):= (others=>'0');
    -- Register B
    SIGNAL RegB_Sel    : STD_LOGIC_VECTOR (REG_SIZE-1 downto 0):= (others=>'0');
    SIGNAL RegB        : STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0):= (others=>'0');
    -- Input Register
    SIGNAL RegIN       : STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0):= (others=>'0');
    SIGNAL RegIN_Sel   : STD_LOGIC_VECTOR (REG_SIZE-1 downto 0):= (others=>'0');
    SIGNAL RegIN_WE    : STD_LOGIC:= '0';

	SIGNAL RegIntMode  : STD_LOGIC := '0';
    
    -- Constants
    -- constant period : time := 20 ns; -- 25 MHz =(1/20E-9)/2
    constant period : time := 10 ns; -- 50 MHz =(1/10E-9)/2
    -- constant period : time := 5 ns; -- 100 MHz =(1/10E-9)/2

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: RegBankInt PORT MAP( CLK         => CLK,
                            RST         => RST,
                            RegA_Sel    => RegA_Sel,
                            RegA        => RegA,
                            RegB_Sel    => RegB_Sel,
                            RegB        => RegB,
                            RegIN       => RegIN,
                            RegIN_Sel   => RegIN_Sel,
                            RegIN_WE    => RegIN_WE,
                            RegIntMode  => RegIntMode);
    
    -- Generate clock
    gen_Clock: process
    begin
        CLK <= '0'; wait for period;
        CLK <= '1'; wait for period;
    end process gen_Clock;

    tb : PROCESS
    BEGIN    

        -- Wait 100 ns for global reset to finish
        RST <= '1';
        wait for 2*period;
        RST <= '0';
        wait for 100 ns;

        report "Start Register Bank Test Bench" severity NOTE;

        --Test Read
        RegA_Sel <= X"0"; -- 0
        RegB_Sel <= X"0"; -- 0
        wait for 2*period;
        RegB_Sel <= X"1"; -- 0
        wait for 2*period;
        RegB_Sel <= X"F"; -- F
        wait for 2*period;

        RegIN    <= (OTHERS => '1');
        RegIN_Sel <= X"F"; -- F
        RegIN_WE <= '1';
        wait for 2*period;
        RegIN_WE <= '0';

		--Test Interupt mode
        RegIntMode <= '1';

        RegIN    <= X"8888";
        RegIN_Sel <= X"F"; -- F
        RegIN_WE <= '1';
        wait for 2*period;
        RegIN_WE <= '0';

        RegA_Sel <= X"F"; -- F
        wait for 2*period;
        RegIntMode <= '0';
        wait for 2*period;
        RegIntMode <= '1';

	
        -- END Reg Test --
        
        report "Finish Register Bank Test Bench" severity NOTE;

        wait; -- will wait forever
    END PROCESS;

END;
