library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity and_1 is
	port (
		Rs,Rt			: in std_logic;
		result_and			: out std_logic);
end and_1;

architecture behavioral of and_1 is
	begin
		result_and <= Rs and Rt;
	end architecture behavioral;
