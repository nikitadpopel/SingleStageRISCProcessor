library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.NUMERIC_STD.all;

entity sll_one is
	port (
		imm			: in std_logic_vector(15 downto 0);
		imm_shifted			: out std_logic_vector(15 downto 0));
end sll_one;

architecture behavioral of sll_one is
	begin
		imm_shifted <= std_logic_vector(shift_left(unsigned(imm), 1));
	end architecture behavioral;
