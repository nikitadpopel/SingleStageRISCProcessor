library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity aluMux is
port(
  a1, a2, a3, a4, a5, a6, a7, a8,
  a9, a10, a11, a12, a13, a14       : in  std_logic_vector(15 downto 0);
  ALUOp                             : in  std_logic_vector(3 downto 0);
  ALUresult                         : out std_logic_vector(15 downto 0);
  branch                            : out std_logic);
end aluMux;

architecture behavioral of aluMux is
begin
mux : process(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,ALUOp)
begin
  case ALUOp is

    -- add, this is the add command. a1 is connected to the adder
    when "0000" =>
      ALUresult <= a1;
      branch <= '0';

    -- sub, this is the sub command. a2 is connected to the subtractor
    when "0001" =>
      ALUresult <= a2;
      branch <= '0';

    -- or, this is the or command. a3 is connected to the OR gate
    when "0010" =>
      ALUresult <= a3;
      branch <= '0';

    -- and, this is the and command. a4 is connected to the and gate
    when "0011" =>
      ALUresult <= a4;
      branch <= '0';

    -- xor, this is the xor command. a5 is connected to the xor gate
    when "0100" =>
      ALUresult <= a5;
      branch <= '0';

    -- sll, this is the sll command. a6 is connected to the sll gate
    when "0101" =>
      ALUresult <= a6;
      branch <= '0';

    -- srl, this is the srl command. a7 is connected to the srl gate
    when "0110" =>
      ALUresult <= a7;
      branch <= '0';

    -- sgt, this is the sgt command. a8 is connected to the subtractor
    -- this is done because we are checking whether or not our most significant bit is
    -- '0'. If our most significant bit is zero, this means that we were subtracting
    -- a smaller value from a larger number. (i.e. not necessary to write the difference
    -- in two's complement)
    when "0111" =>
      if (a8(15) = '0') and (a8 /= "0000000000000000") then
        ALUresult <= "0000000000000001";
        branch <= '0';
      else
        ALUresult <= "0000000000000000";
        branch <= '0';
      end if;

    -- slt, this is the slt command. a9 is also connected to the subtractor
    -- this is done because we are checking whether or not our most significant bit is
    -- '1'. If our most significant bit is one, this means that we were subtracting
    -- a larger value from a smaller number. (i.e. the process of subtracting the
    -- two numbers resulted in the two's complement representation of the negative integer)
    when "1000" =>
      if (a9(15) = '1') then
        ALUresult <= "0000000000000001";
        branch <= '0';
      else
        ALUresult <= "0000000000000000";
        branch <= '0';
      end if;

    -- bne, this is the bne command. a10 is connected to the xor gate
    -- this is done because when comparing two 16 bit vectors
    -- if the particular spot in question is different, that particular bit will
    -- be '1'. If there is a single logical high bit in this resulting bit vector,
    -- this means that the two bit vectors are in fact not equal
    when "1001" =>
      if (a10 /= "0000000000000000") then
        ALUresult <= "0000000000000000";
        branch <= '1';
      else
        ALUresult <= "0000000000000000";
        branch <= '0';
      end if;

    -- beq, this is the beq command. a11 is connected to the not gate
    -- it is connected to the not gate because this input should just be the inversion of
    -- the bit vector coming out of the xor gate (the vector being fed into bne above)
    when "1010" =>
      if (a11 = "1111111111111111") then
        ALUresult <= "0000000000000000";
        branch <= '1';
      else
        ALUresult <= "0000000000000000";
        branch <= '0';
      end if;

    -- bgt, this is the bgt command. a12 is connected to the subtractor and operates
    -- in exactly the same way as the sgt (set greater than). It checks to see whether or not
    -- the subtraction operation will result in a two's complement bit stream (with
    -- a most significant bit of '1') if not, then the branch command is enabled.
    -- one difference between this command and the sgt command is that we are not actually
    -- looking for a result bit vector in this case but we are looking for the branch flag
    when "1011" =>
      if (a12(15) = '0') and (a12 /= "0000000000000000") then
        ALUresult <= "0000000000000000";
        branch <= '1';
      else
        ALUresult <= "0000000000000000";
        branch <= '0';
      end if;

    -- blt, this is the blt command. a13 is also connected to the subtractor and operates
    -- in exactly the same way as the slt (set lesser than). It checks to see whether or not
    -- the subtraction operation will result in a two's complement bit stream (with
    -- a most significant bit of '1') if the most significant bit is one, then the branch command is enabled.
    -- one difference between this command and the slt command is that we are not actually
    -- looking for a result bit vector in this case but we are instead looking for the branch flag
    when "1100" =>
      if (a13(15) = '1') then
        ALUresult <= "0000000000000000";
        branch <= '1';
      else
        ALUresult <= "0000000000000000";
        branch <= '0';
      end if;

    -- li, this is the li command. a14 is just directly connected to Rt or in this
    -- case our immediate location of the instruction code.
    when "1101" =>
      ALUresult <= a14;
      branch <= '0';
    when others => ALUresult <= "0000000000000000";
  end case;
end process mux;
end behavioral;
