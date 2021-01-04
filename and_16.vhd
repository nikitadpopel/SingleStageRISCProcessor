library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity and_16 is
	port (
		Rs,Rt			: in std_logic_vector(15 downto 0);
		result_and			: out std_logic_vector(15 downto 0));
end and_16;

architecture behavioral of and_16 is
	begin
		result_and <= Rs and Rt;
	end architecture behavioral;
