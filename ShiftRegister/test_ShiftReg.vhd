
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_ShiftReg IS
END test_ShiftReg;
 
ARCHITECTURE behavior OF test_ShiftReg IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ShiftReg
    PORT(
         A : OUT  std_logic;
         B : OUT  std_logic;
         C : OUT  std_logic;
         D : OUT  std_logic;
         data_in : IN  std_logic;
         reset : IN  std_logic;
         clk : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal data_in : std_logic := '0';
   signal reset : std_logic := '0';
   signal clk : std_logic := '1';

 	--Outputs
   signal A : std_logic;
   signal B : std_logic;
   signal C : std_logic;
   signal D : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ShiftReg PORT MAP (
          A => A,
          B => B,
          C => C,
          D => D,
          data_in => data_in,
          reset => reset,
          clk => clk
        );

   -- Clock process definitions
   clock_process :process
   begin
		wait for clock_period;
		clk <= not clk;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		wait for 40 ns;
		data_in <= not data_in;
		wait for 150 ns;
   end process;

END;
