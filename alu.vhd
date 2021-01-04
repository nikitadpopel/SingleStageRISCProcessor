library ieee;
use ieee.std_logic_1164.all;

entity alu is
	port( Rs        : in std_logic_vector(15 downto 0);
        Rt    : in std_logic_vector(15 downto 0);
		    ALUOp     : in std_logic_vector (3 downto 0);
		    branch		: out std_logic;
		    result	  : out std_logic_vector(15 downto 0));
end alu;

architecture behavioral of alu is
	-- This is where we create our temporary signals
	signal result_add	: std_logic_vector(15 downto 0);
	signal result_sub	: std_logic_vector(15 downto 0);
  signal result_or	: std_logic_vector(15 downto 0);
	signal result_and	: std_logic_vector(15 downto 0);
	signal result_xor	: std_logic_vector(15 downto 0);
	signal result_sll	: std_logic_vector(15 downto 0);
	signal result_srl	: std_logic_vector(15 downto 0);
  signal result_beq 	: std_logic_vector(15 downto 0);

	begin
		-- Below, we connect all of our digital logic components in the ALU
		-- The 'aluMux' component is intaking all of the results from the digital logic components
		-- and then outputting the correct result based on the 'ALUOp' signal
		mux1 : entity work.aluMux(behavioral) port map(	a1 => result_add, a2 => result_sub,
								a3 => result_or, a4 => result_and,
								a5 => result_xor, a6 => result_sll,
								a7 => result_srl, a8 => result_sub,
								a9 => result_sub, a10 => result_xor,
								a11 => result_beq, a12 => result_sub,
								a13 => result_sub, a14 => Rt,
								ALUOp => ALUOp,
								ALUresult => result, branch => branch);
		add1 : entity work.add_16(behavioral) port map(A => Rs, B => Rt, result_add => result_add);
		sub1 : entity work.sub_16(behavioral) port map(A => Rs, B => Rt, result_sub => result_sub);
		or1 : entity work.or_16(behavioral) port map(Rs => Rs, Rt => Rt, result_or => result_or);
		and1 : entity work.and_16(behavioral) port map(Rs => Rs, Rt => Rt, result_and => result_and);
		xor1 : entity work.xor_16(behavioral) port map(Rs => Rs, Rt => Rt, result_xor => result_xor);
		sll1 : entity work.sll_16(behavioral) port map(Rs => Rs, Rt => Rt, result_sll => result_sll);
		srl1 : entity work.srl_16(behavioral) port map(Rs => Rs, Rt => Rt, result_srl => result_srl);
		not1 : entity work.not_16(behavioral) port map(A => result_xor, result_not => result_beq);
end behavioral;
