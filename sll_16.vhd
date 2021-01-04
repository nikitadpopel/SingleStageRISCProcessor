library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.NUMERIC_STD.all;

entity sll_16 is
	port (
		Rs			: in std_logic_vector(15 downto 0);
		Rt			: in std_logic_vector(15 downto 0);
		result_sll			: out std_logic_vector(15 downto 0));
end sll_16;

architecture behavioral of sll_16 is
	begin
		result_sll <= std_logic_vector(shift_left(unsigned(Rs), to_integer(unsigned(Rt))));
	end architecture behavioral;
