library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity top is
generic(
c_clkfreq : integer := 50_000_000			--Clock frequency. Maximum for Spartan 3E
);
port(
clk		: in std_logic;
sw			: in std_logic_vector (1 downto 0);
counter	: out std_logic_vector (7 downto 0)
);
end top;

architecture Behavioral of top is

constant c_timer2seclim		: integer := c_clkfreq*2;										-- 2 second timer limit
constant c_timer1seclim		: integer := c_clkfreq;											-- 1 second timer limit
constant c_timer500mslim	: integer := c_clkfreq/2;										-- 500 ms timer limit
constant c_timer250mslim	: integer := c_clkfreq/4;										-- 250 ms timer limit

signal timer 					: integer range 0 to c_timer2seclim := 0;
signal timerlim				: integer range 0 to c_timer2seclim := 0;					--Timer limit. Maximum value that timer counts.
signal counter_int			: std_logic_vector (7 downto 0) := (others => '0');

begin
timerlim <= c_timer2seclim when sw = "00" else		-- Timers are adjusted according to the switches. Each switch combination assign to different timer limits.
				c_timer1seclim when sw = "01" else
				c_timer500mslim when sw = "10" else
				c_timer250mslim;
				
process(clk) begin
if(rising_edge(clk)) then
	if(timer >= timerlim-1) then							--If timer limits are changed while timer counts (buttons are changed while timer counts) or timer increase timer limit, timer must be reset.
		counter_int <= counter_int+1;
		timer 		<= 0;
	else															--If timer limits are not changed while timer counts, increase timer.
		timer <= timer +1;
	end if;
end if;
end process;
counter <= counter_int; 									--Assign final counter value.

end Behavioral;

