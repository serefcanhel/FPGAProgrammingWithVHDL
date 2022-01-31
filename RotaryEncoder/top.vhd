library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity top is
Port ( clk : in STD_LOGIC;
rot_a : in STD_LOGIC;
rot_b : in STD_LOGIC;
rot_center : in STD_LOGIC;
led : out STD_LOGIC_VECTOR (7 downto 0));
end top;

architecture Behavioral of top is

signal rotary_a_in: std_logic;
signal rotary_b_in: std_logic;
signal rotary_q1: std_logic;
signal rotary_q2: std_logic;
signal rotary_in: std_logic_vector(1 downto 0);
signal rotary_event: std_logic;
signal rotary_left:std_logic;
signal delay_rotary_q1:std_logic; 
signal center_flag:std_logic;

begin

rotary_a_in <= rot_a;
rotary_b_in <= rot_b;

rotary_filter: process(clk)
begin
if clk'event and clk='1' then
rotary_in <= rotary_b_in & rotary_a_in;

case rotary_in is
when "00" => rotary_q1 <= '0';
rotary_q2 <= rotary_q2;
when "01" => rotary_q1 <= rotary_q1;
rotary_q2 <= '0';
when "10" => rotary_q1 <= rotary_q1;
rotary_q2 <= '1';
when "11" => rotary_q1 <= '1';
rotary_q2 <= rotary_q2;
when others => rotary_q1 <= rotary_q1;
rotary_q2 <= rotary_q2;
end case;
end if;
end process rotary_filter;

direction: process(clk)
begin
if clk'event and clk='1' then

delay_rotary_q1 <= rotary_q1;
if rotary_q1='1' and delay_rotary_q1='0' then
rotary_event <= '1';
rotary_left <= rotary_q2;
else
rotary_event <= '0';
rotary_left <= rotary_left;
end if;
end if;
end process direction;

led_switch: process(clk,rotary_event,rotary_left)

variable i : integer;
variable index : integer;
begin
if clk'event and clk='1' then
if rotary_event='1' and rotary_left='0' then --left
led <="00000000";
i:=i+1;
index :=i mod 8;
led(index)<='1';
end if;
if rotary_event='1' and rotary_left='1' then --right
led <="00000000";
if i=0 then 
i:=8;
end if;
i:=i-1;
index :=i mod 8;
led(index)<='1';
end if; 
end if;
end process led_switch;

process(rot_center)
begin
if (rot_center='1') then
center_flag<='1';
elsif (rot_center='0') then
center_flag<='0';
end if; 
end process;
end Behavioral;

