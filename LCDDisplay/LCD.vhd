library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity LCD is
port(
	clk 				: in std_logic;
	reset 			: in std_logic;
	SF_D 				: out std_logic_vector ( 3 downto 0);
	LCD_E 			: out std_logic;
	LCD_RS 			: out std_logic;
	LCD_RW 			: out std_logic;
	SF_CE0 			: out std_logic;
	Data_Display 	: out std_logic_vector (7 downto 0)
);

end LCD;

architecture Behavioral of LCD is

type init_sequence is (idle, fifteenms, one, two, three, four, five, six, seven, eight, done);

signal init_state 	: init_sequence := idle;
signal init_init		: std_logic := '0';
signal init_done		: std_logic := '0';
signal i 				: integer range 0 to 750000 := 0;

signal SF_D0			: std_logic_vector(3 downto 0);
signal SF_D1			: std_logic_vector(3 downto 0);
signal LCD_E0			: std_logic;
signal LCD_E1			: std_logic;
signal mux				: std_logic;

type display_state is (init, function_set, entry_set, set_display, clr_display, pause, set_addr, 
char_G, char_H, char_R, char_I, char_E, char_T, char_P, done);

signal cur_state		: display_state := init;
signal i3 				: integer range 0 to 82000 := 0;

type tx_sequence is (high_setup, high_hold, oneus, low_setup, low_hold, fortyus, done);

signal tx_state		: tx_sequence := done;
signal tx_byte			: std_logic_vector(7 downto 0);
signal tx_init			: std_logic := '0';
signal i2				: integer range 0 to 2000 := 0;

begin

SF_CE0 <= '1';			--disable intel strataflash
LCD_RW <= '0';			--write only

power_on_initialize : process(clk, reset, init_init)
begin
if(reset = '1') then
	init_state 	<= idle;
	init_done 	<= '0';
elsif(clk = '1' and clk'event) then
	case init_state is
		when idle =>
			init_done <= '0';
			if(init_init = '1') then
				init_state 	<= fifteenms;
				i				<= 0;
			else
				init_state	<= idle;
			end if;
		
		when fifteenms =>
			init_done <= '0';
			if(i = 750000) then
				init_state	<= one;
				i				<= 0;
			else
				init_state	<= fifteenms;
				i				<= i+1;
			end if;
			
		when one =>
			SF_D1			<= "0011";
			LCD_E1		<= '1';
			init_done 	<= '0';
			if(i = 11) then
				init_state	<= two;
				i				<= 0;
			else
				init_state	<= one;
				i				<= i+1;
			end if;

		when two =>
			LCD_E1		<= '0';
			init_done 	<= '0';
			if(i = 205000) then
				init_state	<= three;
				i				<= 0;
			else
				init_state	<= two;
				i				<= i+1;
			end if;
		
		when three =>
			SF_D1			<= "0011";
			LCD_E1		<= '1';
			init_done 	<= '0';
			if(i = 11) then
				init_state	<= four;
				i				<= 0;
			else
				init_state	<= three;
				i				<= i+1;
			end if;
		
		when four =>
			SF_D1			<= "0011";
			LCD_E1		<= '0';
			init_done 	<= '0';
			if(i = 5000) then
				init_state	<= five;
				i				<= 0;
			else
				init_state	<= four;
				i				<= i+1;
			end if;
			
		when five =>
			SF_D1			<= "0011";
			LCD_E1		<= '1';
			init_done 	<= '0';
			if(i = 11) then
				init_state	<= six;
				i				<= 0;
			else
				init_state	<= five;
				i				<= i+1;
			end if;
		
		when six =>
			SF_D1			<= "0011";
			LCD_E1		<= '0';
			init_done 	<= '0';
			if(i = 2000) then
				init_state	<= seven;
				i				<= 0;
			else
				init_state	<= six;
				i				<= i+1;
			end if;
		
		when seven =>
			SF_D1			<= "0010";
			LCD_E1		<= '1';
			init_done 	<= '0';
			if(i = 11) then
				init_state	<= eight;
				i				<= 0;
			else
				init_state	<= seven;
				i				<= i+1;
			end if;
			
		when eight =>
			SF_D1			<= "0010";
			LCD_E1		<= '0';
			init_done 	<= '0';
			if(i = 2000) then
				init_state	<= done;
				i				<= 0;
			else
				init_state	<= eight;
				i				<= i+1;
			end if;
			
		when done =>
			init_state		<= done;
			init_done		<= '1';
	end case;
end if;
end process power_on_initialize;

display : 	process(clk, reset)
begin 
if(reset = '1') then
	cur_state	<= init;
elsif(clk = '1' and clk'event) then
	case cur_state is
		when init =>
			tx_init		<= '0';
			mux			<= '1';
			init_init	<= '1';
			LCD_RS		<= '1';
			SF_D			<= SF_D1;
			LCD_E			<= LCD_E1;
			if(init_done = '1') then
				cur_state <= function_set;
			else
				cur_state <= init;
			end if;
			
		when function_set =>
			tx_init		<= '1';
			mux			<= '0';
			init_init	<= '0';
			LCD_RS		<= '0';
			tx_byte		<= X"28";
			SF_D			<= SF_D0;
			LCD_E			<= LCD_E0;
			if(i2 = 2000) then
				cur_state <= entry_set;
			else
				cur_state <= function_set;
			end if;
			
		when entry_set =>
			tx_init		<= '1';
			mux			<= '0';
			init_init	<= '0';
			LCD_RS		<= '0';
			tx_byte		<= X"06";
			SF_D			<= SF_D0;
			LCD_E			<= LCD_E0;
			if(i2 = 2000) then
				cur_state <= set_display;
			else
				cur_state <= entry_set;
			end if;
			
		when set_display =>
			tx_init		<= '1';
			mux			<= '0';
			init_init	<= '0';
			LCD_RS		<= '0';
			tx_byte		<= X"0C";
			SF_D			<= SF_D0;
			LCD_E			<= LCD_E0;
			if(i2 = 2000) then
				cur_state <= clr_display;
			else
				cur_state <= set_display;
			end if;
			
		when clr_display =>
			tx_init		<= '1';
			mux			<= '0';
			init_init	<= '0';
			LCD_RS		<= '0';
			tx_byte		<= X"01";
			SF_D			<= SF_D0;
			LCD_E			<= LCD_E0;
			if(i2 = 2000) then
				cur_state <= pause;
			else
				cur_state <= clr_display;
			end if;
			
		when pause =>
			tx_init		<= '0';
			mux			<= '0';
			init_init	<= '0';
			LCD_RS		<= '1';
			SF_D			<= SF_D0;
			LCD_E			<= LCD_E0;
			if(i3 = 82000) then
				cur_state <= set_addr;
				i3			 <= 0;
			else
				cur_state <= pause;
				i3			 <= i3+1;
			end if;
			
		when set_addr =>
			tx_init		<= '1';
			mux			<= '0';
			init_init	<= '0';
			LCD_RS		<= '0';
			tx_byte		<= X"08";
			SF_D			<= SF_D0;
			LCD_E			<= LCD_E0;
			if(i2 = 2000) then
				cur_state <= char_G;
			else
				cur_state <= set_addr;
			end if;
		
		when char_G =>
			tx_init		<= '1';
			mux			<= '0';
			init_init	<= '0';
			LCD_RS		<= '1';
			tx_byte		<= X"47";
			SF_D			<= SF_D0;
			LCD_E			<= LCD_E0;
			if(i2 = 2000) then
				cur_state <= char_H;
			else
				cur_state <= char_G;
			end if;
			
		when char_H =>
			tx_init		<= '1';
			mux			<= '0';
			init_init	<= '0';
			LCD_RS		<= '1';
			tx_byte		<= X"48";
			SF_D			<= SF_D0;
			LCD_E			<= LCD_E0;
			if(i2 = 2000) then
				cur_state <= char_R;
			else
				cur_state <= char_H;
			end if;
		
		when char_R =>
			tx_init		<= '1';
			mux			<= '0';
			init_init	<= '0';
			LCD_RS		<= '1';
			tx_byte		<= X"52";
			SF_D			<= SF_D0;
			LCD_E			<= LCD_E0;
			if(i2 = 2000) then
				cur_state <= char_I;
			else
				cur_state <= char_R;
			end if;
			
		when char_I =>
			tx_init		<= '1';
			mux			<= '0';
			init_init	<= '0';
			LCD_RS		<= '1';
			tx_byte		<= X"49";
			SF_D			<= SF_D0;
			LCD_E			<= LCD_E0;
			if(i2 = 2000) then
				cur_state <= char_E;
			else
				cur_state <= char_I;
			end if;
			
		when char_E =>
			tx_init		<= '1';
			mux			<= '0';
			init_init	<= '0';
			LCD_RS		<= '1';
			tx_byte		<= X"45";
			SF_D			<= SF_D0;
			LCD_E			<= LCD_E0;
			if(i2 = 2000) then
				cur_state <= char_T;
			else
				cur_state <= char_E;
			end if;
		
		when char_T =>
			tx_init		<= '1';
			mux			<= '0';
			init_init	<= '0';
			LCD_RS		<= '1';
			tx_byte		<= X"54";
			SF_D			<= SF_D0;
			LCD_E			<= LCD_E0;
			if(i2 = 2000) then
				cur_state <= char_P;
			else
				cur_state <= char_T;
			end if;
		
		when char_P =>
			tx_init		<= '1';
			mux			<= '0';
			init_init	<= '0';
			LCD_RS		<= '1';
			tx_byte		<= X"50";
			SF_D			<= SF_D0;
			LCD_E			<= LCD_E0;
			if(i2 = 2000) then
				cur_state <= done;
			else
				cur_state <= char_P;
			end if;
		
		when done =>
			tx_init		<= '0';
			mux			<= '0';
			init_init	<= '0';
			LCD_RS		<= '1';
			tx_byte		<= X"00";
			SF_D			<= SF_D0;
			LCD_E			<= LCD_E0;
			cur_state 	<= done;
		end case;
			
end if;
end process display;

transmit : process(clk, reset)
begin
if(reset = '1') then 
	tx_state <= done;
elsif(clk = '1' and clk'event) then
	case tx_state is
		when done =>
			LCD_E0	<= '0';
			if(tx_init = '1') then 
				tx_state	<= high_setup;
				i2			<= 0;
			else
				tx_state	<= done;
				i2			<= 0;
			end if;
			
		when high_setup =>
			LCD_E0 		<= '0';
			SF_D0			<=tx_byte(7 downto 4);
			if(i2 = 2) then
				tx_state <= high_hold;
				i2			<= 0;
			else
				tx_state <= high_setup;
				i2			<= i2+1;
			end if;
		
		when high_hold =>
			LCD_E0 		<= '1';
			SF_D0			<=tx_byte(7 downto 4);
			if(i2 = 2) then
				tx_state <= oneus;
				i2			<= 0;
			else
				tx_state <= high_hold;
				i2			<= i2+1;
			end if;
			
		when oneus =>
			LCD_E0 		<= '0';
			if(i2 = 50) then
				tx_state <= low_setup;
				i2			<= 0;
			else
				tx_state <= oneus;
				i2			<= i2+1;
			end if;
		
		when low_setup =>
			LCD_E0 		<= '0';
			SF_D0		<= tx_byte( 3 downto 0);
			if(i2 = 2) then
				tx_state <= low_hold;
				i2			<= 0;
			else
				tx_state <= low_setup;
				i2			<= i2+1;
			end if;
		
		when low_hold =>
			LCD_E0 		<= '1';
			SF_D0			<= tx_byte( 3 downto 0);
			if(i2 = 12) then
				tx_state <= fortyus;
				i2			<= 0;
			else
				tx_state <= low_hold;
				i2			<= i2+1;
			end if;
			
		when fortyus =>
			LCD_E0 		<= '0';
			if(i2 = 2000) then
				tx_state <= done;
				i2			<= 0;
			else
				tx_state <= fortyus;
				i2			<= i2+1;
			end if;
	end case;			
end if;
end process transmit;


end Behavioral;

