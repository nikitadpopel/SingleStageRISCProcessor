library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity extend_16 is
	port (
		imm			: in std_logic_vector(4 downto 0);
		imm_extend			: out std_logic_vector(15 downto 0));
end extend_16;

architecture behavioral of extend_16 is
	begin
		imm_extend <= "00000000000" & imm;
	end architecture behavioral;
