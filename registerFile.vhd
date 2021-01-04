library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.data2_pkg.all;

entity registerFile is
  port( clk, RegWrite                    : in std_logic;
        readReg1, readReg2, writeReg     : in std_logic_vector(2 downto 0);
        writeData                        : in std_logic_vector(15 downto 0);
        readData1, readData2             : out std_logic_vector(15 downto 0);
        register_list                    : out register_array);
end registerFile;

architecture behavioral of registerFile is

  -- initialising register values
  signal registers : register_array := ( "0000000000000000",
                                         "0000000000000000",
                                         "0000000000000000",
                                         "0000000000000000",
                                         "0000000000000000",
                                         "0000000000000000",
                                         "0000000000000000",
                                         "0000000000000000");
  begin
    process(clk, RegWrite, registers, readReg1, readReg2, writeReg, writeData)
      begin

        -- writing in current registers into register_list for being able to
        -- view registers from top level
        register_list <= registers;

        -- writing in the output of the ALU into Rs/Rd
        IF (rising_edge(clk)) THEN
          IF (RegWrite = '1') THEN
            registers(to_integer(unsigned(writeReg))) <= writeData;
          END IF;
        END IF;

        -- sending out the data stored in the called for register location
        readData1 <= registers(to_integer(unsigned(readReg1)));
        readData2 <= registers(to_integer(unsigned(readReg2)));
    end process;
end behavioral;
