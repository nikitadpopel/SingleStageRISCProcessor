library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity xor_16 is
	port (
		Rs,Rt			: in std_logic_vector(15 downto 0);
		result_xor			: out std_logic_vector(15 downto 0));
end xor_16;

architecture behavioral of xor_16 is
	begin
		result_xor <= Rs xor Rt;
	end architecture behavioral;
