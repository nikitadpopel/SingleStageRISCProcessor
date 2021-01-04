library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.NUMERIC_STD.all;

entity add_16 is
	port (
		A,B			: in std_logic_vector(15 downto 0);
		result_add			: out std_logic_vector(15 downto 0));
end add_16;

architecture behavioral of add_16 is
	begin
		result_add <= std_logic_vector(unsigned(A) + unsigned(B));
	end architecture behavioral;
