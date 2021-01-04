library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.data2_pkg.all;

entity data_memory is
  port(
        clk           : in std_logic; --clock
        data_write    : in std_logic_vector(15 downto 0); --data to be written
        address       : in std_logic_vector(15 downto 0); --where to write/read data
        MemRead       : in std_logic; --are we reading?
        MemWrite      : in std_logic; --are we writing?
        data_read     : out std_logic_vector(15 downto 0); --data to be read out
        data_list     : out data_array); --port to interface with data
end data_memory;

architecture behavioral of data_memory is
  signal temp_address   : std_logic_vector(15 downto 0);
  signal temp           : data_array := (others => (others => '0'));

  begin
    process(clk, data_write, MemWrite, MemRead, address, temp)
    begin
      data_list <= temp; --send out data
      temp_address(15 downto 0) <= address(15 downto 0); --read in address
      if(rising_edge(clk)) then
        if(MemWrite = '1') then
          temp(to_integer(unsigned(temp_address))) <= data_write; --if writing, store data
        end if;
      end if;
      if (MemRead = '1') then
        data_read <= temp(to_integer(unsigned(temp_address))); --if reading, send out data
      else
        data_read <= "0000000000000000"; --is not reading, read nothing
      end if;
    end process;
end behavioral;
