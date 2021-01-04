library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
package data2_pkg is
        type address_array is array(0 to 127) of std_logic_vector(15 downto 0);
        type register_array is array(0 to 7) of std_logic_vector(15 downto 0);
        type data_array is array(0 to 31) of std_logic_vector(15 downto 0);
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.data2_pkg.all;

entity top is
  Port ( REG         : out	  register_array;
         DATA_OUT    : out    data_array);
end top;

architecture behavior of top is

  -- creating all of our signals
  signal  sig_jump, sig_branch, sig_ALUbranch, sig_MemRead,
          sig_MemtoReg, sig_MemWrite, sig_ALUSrc, sig_RegWrite, sig_RegDst,
          sig_mux16_3_sel : std_logic;

  signal  sig_instructionOut, sig_readData1, sig_readData2, sig_aluResult,
          sig_immExtend, sig_immExtendShifted, sig_AddOut1, sig_AddOut2,
          sig_MemDataRead, sig_RegWriteData, sig_mux16_1Out, sig_mux16_3Out,
          sig_location, sig_mux16_4Out : std_logic_vector(15 downto 0);

  signal sig_mux3Out                    : std_logic_vector(2 downto 0);
  signal sig_ALUOp                      : std_logic_vector(3 downto 0);

  signal clk_sig      : std_logic := '0';
  signal IntTwo       : std_logic_vector(15 downto 0) := "0000000000000010";
  signal sig_PC       : std_logic_vector(15 downto 0) := "0000000000000000";
  constant Tperiod : time := 100 ns;
  signal tempREGout : register_array;
  signal tempDATAout : data_array;
  signal cnt : integer := 0;

  -- inputting our instructions
  signal instructions : address_array := ( "0110100000100100", --0   li s1, 0x0004
                                           "0011100100100100", --2   sll s1, s1, 4
                                           "0110100001010000", --4   li s2, 0x0010
                                           "0011101001001000", --6   sll s2, s2, 8
                                           "0111001001010000", --8   addi s2, s2, 0x0010
                                           "0110100001101111", --10  li s3, 0x000F
                                           "0110100010001111", --12  li s4, 0x000F
                                           "0011110010000100", --14  sll s4, s4, 4
                                           "0110100011010000", --16  li s6, 0x0010
                                           "0110100011100101", --18  li s7, 0x0005
                                           "0110100000000001", --20  li s0, 0x0001
                                           "0011100000001000", --22  sll s0, s0, 8
                                           "0111000000000001", --24  addi s0, s0, 0x0001
                                           "0101111000000000", --26  sw s0, s6
                                           "0111000000001111", --28  addi s0, s0, 0x000F
                                           "0101111000000010", --30  sw s0, s6 0x0002
                                           "0100000000000100", --32  srl s0, s0, 4
                                           "0101111000000100", --34  sw s0, s6, 0x0004
                                           "0110100000001111", --36  li s0, 0x000F
                                           "0011100000000100", --38  sll s0, s0, 4
                                           "0101111000000110", --40  sw s0, s6, 0x0006
                                           "0111000000001111", --42  addi s0, s0, 0x000F
                                           "0101111000001000", --44  sw s0, s6, 0x0008
                                           "0110100000000000", --46  mainloop li $0, $zero
                                           "1000111100010011", --48  beq $7, $0, endprog
                                           "0110100000000001", --50  li $0, 0x1
                                           "0000111100011100", --52  sub $7, $7, $0
                                           "0110011010100000", --54  lw $5, $6
                                           "0110100000010001", --56  li $0, 0x11
                                           "1001010100000111", --58  bgt $5, $0, yesgreater
                                           "0011101101100010", --60  sll $3, $3, 2
                                           "0011010001110000", --62  xor $4, $4, $3
                                           "0110100000001111", --64  li $0, 0xF
                                           "0011100000000100", --66  sll $0, $0, 4
                                           "0111000000001111", --68  addi $0, $0, 0xF
                                           "0101111000000000", --70  sw $0, $6
                                           "1010000001011000", --72  j outloop
                                           "0100000100100011", --74  yesgreater srl $1, $1, 3
                                           "0001101000101000", --76  or $2, $2, $1
                                           "0110100000001111", --78  li $0, 0xF
                                           "0011100000000100", --80  sll $0, $0, 4
                                           "0111000000001111", --82  addi $0, $0, 0xF
                                           "0011100000001000", --84  sll $0, $0, 8
                                           "0101111000000000", --86  sw $0, $6
                                           "0111011011000010", --88  outloop addi $6, $6, 2
                                           "1010000000101110", --90  j mainloop
                                           "1010000001011100", --92
                                            others => (others => '0'));--endprog j endprog

  begin


    -- linking all of our components
    instructionMemory_1 : entity work.instructionMemory(behavioral) port map(clk => clk_sig,
                                                                            address => sig_PC,
                                                                            address_list => instructions,
                                                                            instructionOut => sig_instructionOut);

    dataMemory_1 : entity work.data_memory(behavioral) port map(            clk => clk_sig,
                                                                            data_write => sig_readData2,
                                                                            address => sig_aluResult,
                                                                            MemRead => sig_MemRead,
                                                                            MemWrite => sig_MemWrite,
                                                                            data_read => sig_MemDataRead,
                                                                            data_list => tempDATAout);

    mux3_1 : entity work.mux_3(behavioral) port map(                        picker => sig_RegDst,
                                                                            in_1 => sig_instructionOut(4 downto 2),
                                                                            in_2 => sig_instructionOut(7 downto 5),
                                                                            output => sig_mux3Out);

    control_1 : entity work.control(behavioral) port map(                   --clk => clk_sig,
                                                                            OPcode => sig_instructionOut(15 downto 11),
                                                                            ALUOp => sig_ALUOp,
                                                                            jump => sig_jump,
                                                                            branch => sig_branch,
                                                                            MemRead => sig_MemRead,
                                                                            MemtoReg => sig_MemtoReg,
                                                                            MemWrite => sig_MemWrite,
                                                                            ALUSrc => sig_ALUSrc,
                                                                            RegWrite => sig_RegWrite,
                                                                            RegDst => sig_RegDst);

    registerFile_1 : entity work.registerFile(behavioral) port map(         clk => clk_sig,
                                                                            RegWrite => sig_RegWrite,
                                                                            readReg1 => sig_instructionOut(10 downto 8),
                                                                            readReg2 => sig_instructionOut(7 downto 5),
                                                                            writeReg => sig_mux3Out,
                                                                            writeData => sig_RegWriteData,
                                                                            readData1 => sig_readData1,
                                                                            readData2 => sig_readData2,
                                                                            register_list => tempREGout);

    and1_1 : entity work.and_1(behavioral) port map(                        Rs => sig_branch,
                                                                            Rt => sig_ALUbranch,
                                                                            result_and => sig_mux16_3_sel);

    add16_1pc : entity work.add_16pc(behavioral) port map(                  cnt_in => cnt,
                                                                            A => sig_PC,
                                                                            B => IntTwo,
                                                                            result_add => sig_AddOut1);

    add16_2 : entity work.add_16(behavioral) port map(                      A => sig_AddOut1,
                                                                            B => sig_immExtendShifted,
                                                                            result_add => sig_AddOut2);

    signExtend_1 : entity work.extend_16(behavioral) port map(              imm => sig_instructionOut(4 downto 0),
    	                                                                      imm_extend => sig_immExtend);

    shiftLeftone_1 : entity work.sll_one(behavioral) port map(              imm => sig_immExtend,
                                                                            imm_shifted	=> sig_immExtendShifted);

    mux16_1 : entity work.mux_16(behavioral) port map(                      picker => sig_ALUSrc,
                                                                            in_1 => sig_readData2,
                                                                            in_2 => sig_immExtend,
                                                                            output => sig_mux16_1Out);

    mux16_2 : entity work.mux_16(behavioral) port map(                      picker => sig_MemtoReg,
                                                                            in_1 => sig_aluResult,
                                                                            in_2 => sig_MemDataRead,
                                                                            output => sig_RegWriteData);

    mux16_3 : entity work.mux_16(behavioral) port map(                      picker => sig_mux16_3_sel,
                                                                            in_1 => sig_AddOut1,
                                                                            in_2 => sig_AddOut2,
                                                                            output => sig_mux16_3Out);

    mux16_4 : entity work.mux_16(behavioral) port map(                      picker => sig_jump,
                                                                            in_1 => sig_mux16_3Out,
                                                                            in_2 => sig_location,
                                                                            output => sig_mux16_4Out);

    alu_1 : entity work.alu(behavioral) port map(
                                                                            Rs => sig_readData1,
                                                                            Rt => sig_mux16_1Out,
                                                                            ALUOp => sig_ALUOp,
                                                                            branch => sig_ALUbranch,
                                                                            result => sig_aluResult);
    sig_location <= "00000" & sig_instructionOut(10 downto 0);

    -- creating our clock process
    tick : process (clk_sig)
      begin
        clk_sig <= NOT clk_sig after Tperiod/2;
        IF (rising_edge(clk_sig)) THEN --falling
           cnt <= cnt + 1;
        END IF;
        REG <= tempREGout;
        DATA_OUT <= tempDATAout;
    end process tick;

    -- our process that advances our program count to the next one (as decided by the processor)
    pc_advance : process (clk_sig, sig_mux16_4Out)
      begin
        IF (falling_edge(clk_sig)) THEN --falling
           sig_PC <= sig_mux16_4Out;
        END IF;
    end process pc_advance;

    -- our process that sends reports on the status of our register/memory values
    reporting : process(clk_sig, sig_PC)
      begin
        IF (rising_edge(clk_sig) and sig_PC = x"0000" and cnt = 0 ) THEN
          report "Current Clock Cycle Value: " & integer'image(cnt);
          report "The initial register values are: $1: " & integer'image(to_integer(unsigned(tempREGout(1))))
                                                  & "  $2: " & integer'image(to_integer(unsigned(tempREGout(2))))
                                                  & "  $3: " & integer'image(to_integer(unsigned(tempREGout(3))))
                                                  & "  $4: " & integer'image(to_integer(unsigned(tempREGout(4))))
                                                  & "  $5: " & integer'image(to_integer(unsigned(tempREGout(5))))
                                                  & "  $6: " & integer'image(to_integer(unsigned(tempREGout(6))))
                                                  & "  $7: " & integer'image(to_integer(unsigned(tempREGout(7))));
          report "The initial memory values are:   MEM[$6]: " & integer'image(to_integer(unsigned(tempDATAout(16))))
                                                  & "  MEM[$6+2]: " & integer'image(to_integer(unsigned(tempDATAout(18))))
                                                  & "  MEM[$6+4]: " & integer'image(to_integer(unsigned(tempDATAout(20))))
                                                  & "  MEM[$6+6]: " & integer'image(to_integer(unsigned(tempDATAout(22))))
                                                  & "  MEM[$6+8]: " & integer'image(to_integer(unsigned(tempDATAout(24)))) & LF & LF;
        END IF;
        IF (rising_edge(clk_sig) and cnt = 26 ) THEN
          report "Current Clock Cycle Value: " & integer'image(cnt);
          report "The initialized register values are: $1: " & integer'image(to_integer(unsigned(tempREGout(1))))
                                                  & "  $2: " & integer'image(to_integer(unsigned(tempREGout(2))))
                                                  & "  $3: " & integer'image(to_integer(unsigned(tempREGout(3))))
                                                  & "  $4: " & integer'image(to_integer(unsigned(tempREGout(4))))
                                                  & "  $5: " & integer'image(to_integer(unsigned(tempREGout(5))))
                                                  & "  $6: " & integer'image(to_integer(unsigned(tempREGout(6))))
                                                  & "  $7: " & integer'image(to_integer(unsigned(tempREGout(7))));
          report "The initialized memory values are:   MEM[$6]: " & integer'image(to_integer(unsigned(tempDATAout(16))))
                                                  & "  MEM[$6+2]: " & integer'image(to_integer(unsigned(tempDATAout(18))))
                                                  & "  MEM[$6+4]: " & integer'image(to_integer(unsigned(tempDATAout(20))))
                                                  & "  MEM[$6+6]: " & integer'image(to_integer(unsigned(tempDATAout(22))))
                                                  & "  MEM[$6+8]: " & integer'image(to_integer(unsigned(tempDATAout(24)))) & LF & LF;
        END IF;
        IF (rising_edge(clk_sig) and sig_PC = x"002E" and cnt > 38) THEN
          report "Current Clock Cycle Value: " & integer'image(cnt);
          report "The current register values are: $1: " & integer'image(to_integer(unsigned(tempREGout(1))))
                                                  & "  $2: " & integer'image(to_integer(unsigned(tempREGout(2))))
                                                  & "  $3: " & integer'image(to_integer(unsigned(tempREGout(3))))
                                                  & "  $4: " & integer'image(to_integer(unsigned(tempREGout(4))))
                                                  & "  $5: " & integer'image(to_integer(unsigned(tempREGout(5))))
                                                  & "  $6: " & integer'image(to_integer(unsigned(tempREGout(6))))
                                                  & "  $7: " & integer'image(to_integer(unsigned(tempREGout(7))));
          report "The current memory values are:   MEM[$6]: " & integer'image(to_integer(unsigned(tempDATAout(16))))
                                                  & "  MEM[$6+2]: " & integer'image(to_integer(unsigned(tempDATAout(18))))
                                                  & "  MEM[$6+4]: " & integer'image(to_integer(unsigned(tempDATAout(20))))
                                                  & "  MEM[$6+6]: " & integer'image(to_integer(unsigned(tempDATAout(22))))
                                                  & "  MEM[$6+8]: " & integer'image(to_integer(unsigned(tempDATAout(24)))) & LF & LF;
        END IF;
      end process reporting;
end behavior;
