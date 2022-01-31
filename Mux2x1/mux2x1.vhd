
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2x1 is
port(
a_i : in std_logic;
b_i : in std_logic;
s1 : in std_logic;
out1 : out std_logic
);

end mux2x1;

architecture Behavioral of mux2x1 is

begin


out1 <= a_i when s1 = '1' else
		  b_i;

end Behavioral;

