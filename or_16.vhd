library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity or_16 is
	port (
		Rs,Rt			: in std_logic_vector(15 downto 0);
		result_or			: out std_logic_vector(15 downto 0));
end or_16;

architecture behavioral of or_16 is
	begin
		result_or <= Rs or Rt;
	end architecture behavioral;
