library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity not_16 is
	port (
		A			: in std_logic_vector(15 downto 0);
		result_not			: out std_logic_vector(15 downto 0));
end not_16;

architecture behavioral of not_16 is
	begin
		result_not <= not A;
	end architecture behavioral;
