
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder is
port(
a_i     : in std_logic;
b_i     : in std_logic;
sum_o   : out std_logic;
carry_o : out std_logic
);
end half_adder;

architecture Behavioral of half_adder is

begin
sum_o <= a_i xor b_i;
carry_o <= a_i and b_i;

end Behavioral;

