library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux_16 is
port(
    picker      : in  std_logic;
    in_1, in_2  : in  std_logic_vector(15 downto 0);
    output      : out std_logic_vector(15 downto 0));
end mux_16;

architecture behavioral of mux_16 is
begin
  mux : process(picker, in_1, in_2)
  begin
    case picker is
      when '0' =>         -- choice 1
        output <= in_1;
      when '1' =>         -- choice 2
        output <= in_2;
      when others =>
        output <= "0000000000000000";
    end case;
  end process mux;
end behavioral;
