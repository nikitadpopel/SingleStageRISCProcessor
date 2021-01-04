library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.data2_pkg.all;-- defining our type address_array so that we can connect the type in the port

entity instructionMemory is
  port( clk              : in std_logic;
        address          : in std_logic_vector(15 downto 0);
        address_list     : in address_array;
        instructionOut   : out std_logic_vector(15 downto 0));
end instructionMemory;

architecture behavioral of instructionMemory is
  signal instructions : address_array := (others => (others => '0')); -- initiating a address_array with all zeros
  signal progCount : std_logic_vector(15 downto 0);

  begin
    instructions <= address_list;           -- overwriting our previously initialized address_array with our instructions
    process(clk, progCount, address)        -- passed in from the top level
      begin
        IF (rising_edge(clk)) THEN 
          progCount <= address;
        END IF;
        instructionOut <= instructions(to_integer(unsigned(progCount)) / 2);    -- sending instruction out to the processor
    end process;
end behavioral;
