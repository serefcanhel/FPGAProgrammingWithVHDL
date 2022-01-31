
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
generic(
N : integer := 2 -- N is used 2 because Spartan 3E has 4 buttons. So 2 2-bit number can be added maximum in this board.
);

port(
SW : in std_logic_vector (3 downto 0);			--Button port definitions
LED : out std_logic_vector (2 downto 0)		--LED port definitions
);
end top;

architecture Behavioral of top is

component nbit_adder is
generic(
N : integer := 2
);
port(
a_i : in std_logic_vector (N-1 downto 0);
b_i : in std_logic_vector (N-1 downto 0);
carry_i : in std_logic ;
sum_o : out std_logic_vector (N-1 downto 0) ;
carry_o : out std_logic
);
end component;

begin



nbit_adder_i : nbit_adder
generic map(
N => N
)
port map(
a_i => SW(1 downto 0),  		--First 2-bit number assigned to the first two switches.
b_i => SW(3 downto 2),			--Second 2-bit number asssigned to the last two switches.
carry_i => '0',					--Carry in is always zero. But, if there is another switch exits, it can be assigned to the switch. If carry in assigned to the switch, the led bit number must be changed.
sum_o => LED(1 downto 0),		--Result assigned to the leds. 
carry_o => LED(2)					--Carry out assigned to the led in case of any carry out exist.
);

end Behavioral;

