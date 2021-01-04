library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.NUMERIC_STD.all;

entity sub_16 is
	port (
		A,B			: in std_logic_vector(15 downto 0);
		result_sub			: out std_logic_vector(15 downto 0));
end sub_16;

architecture behavioral of sub_16 is
	begin
		result_sub <= std_logic_vector(unsigned(A) - unsigned(B));
	end architecture behavioral;
