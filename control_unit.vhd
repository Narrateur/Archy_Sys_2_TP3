-- Unite de controle processeur pipeline
-- Version à compléter
-- Auteur : 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity control_unit is
port (	Clk 		: in std_logic;

	Inst 		: in std_logic_vector(31 downto 0);
	Src_PC 		: out std_logic;

	Src1, Src2	: out std_logic_vector(3 downto 0);

	Imm     	: out std_logic_vector(15 downto 0);
	Src_Op_B 	: out std_logic; 	
	Cmd_UAL 	: out std_logic_vector(1 downto 0);
	Z,N			: in std_logic;
	
	Src_Adr_Branch 	: out std_logic; 	
	RW, Bus_Val 	: out std_logic;

	Banc_Src 	: out std_logic_vector(1 downto 0);
	Dest 		: out std_logic_vector(3 downto 0);
	Banc_Ecr 	: out std_logic 
);
end control_unit;

architecture beh of control_unit is

signal di_ri :  std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal di_src_PC, ex_src_pc, mem_src_pc : std_logic := '1';
signal codeop : std_logic_vector(3 downto 0);
	
begin

	-- registre RI
	ri : process(clk)
	begin
		if Clk'event and Clk='0' then
			di_ri <= Inst;
		end if;
	end process;

	-- decodeur
	---------------------
	-- a vous
	---------------------

	codeop <= Inst(31 downto 28);

	dec: process(codeop)
	begin

		case codeop is
			when "0000" => --NOP
				Src_PC          <= '0';
				Banc_Src        <= "00";
				Banc_Ecr        <= '0';
				Src_Op_B        <= '0';
				Src_adr_branch  <= '-';

			when "0001" => --ADDS
				Src_PC 		<= '1';
				Banc_Src 	<= "01";
				Banc_Ecr	<= '1';
				Cmd_Ual         <= "00";     -- Z=0, N=0;
				Src_Op_B        <= '0';
				Src_adr_branch  <= '-';
				Src1 <= Inst(27 downto 24);
				Src2 <= Inst(23 downto 20);
				Dest <= Inst(19 downto 16);
				Imm <= Inst(15 downto 0);

				
			when "0010" => --SUB
				Banc_Ecr <= '1';
				Src_Op_B <= '1';
				Cmd_Ual <= "01"; -- 00 = Addition - 01 = Soustraction 
				Banc_Src <= "01";
				Src_PC <= '1';
				Src_adr_branch  <= '-';
				Src1 <= Inst(27 downto 24);
				Src2 <= Inst(23 downto 20);
				Dest <= Inst(19 downto 16);
				Imm <= Inst(15 downto 0);

			
			when "0011" => --SW
				Src_PC <= '1'; 
				Banc_Ecr <= '1';
				Src_Op_B <= '0';
				Cmd_Ual <= "00";
				Banc_Src <= "01";
				Src_adr_branch <= '-';
				Src1 <= Inst(27 downto 24);
				Src2 <= Inst(23 downto 20);
				Dest <= Inst(19 downto 16);
				Imm <= Inst(15 downto 0);
				

			when "0100" => --LW
				Banc_Ecr <= '1';
				Src_Op_B <= '0';
				Cmd_Ual <= "00";
				Src_Adr_Branch <= '-';
				Banc_Src <= "01";
				Src_Pc <= '1';
				Src1 <= Inst(27 downto 24);
				Src2 <= Inst(23 downto 20);
				Dest <= Inst(19 downto 16);
				Imm <= Inst(15 downto 0);
				

			when "0101" => --JSR
				Src1 <= Inst(27 downto 24);
				Src2 <= Inst(23 downto 20);
				Dest <= Inst(19 downto 16);
				Imm <= Inst(15 downto 0);
				Banc_Ecr <= '1';
				Banc_Src <= "10";
				Src_PC <= '1';

				Banc_Ecr <= '0';
				Src_Op_B <= '0';
				Cmd_Ual <= "00";
				Src_Adr_Branch <= '0';
				Src_PC <= '0';
				
				
			when "0110" => --RTS
				Src1 <= Inst(27 downto 24);
				Src2 <= Inst(23 downto 20);
				Dest <= Inst(19 downto 16);
				Imm <= Inst(15 downto 0);
				Src_Op_B <= '0';
				Src_Pc <= '0';

			when "0111" => --BEQ
				Src1 <= Inst(27 downto 24);
				Src2 <= Inst(23 downto 20);
				Dest <= Inst(19 downto 16);
				Imm <= Inst(15 downto 0);
				Src_Op_B <= '1';
				Cmd_Ual <= "01";
				Banc_Ecr <= '0';
				if Z = '0' then
					Src_Adr_Branch <= '1';
					Src_Pc <= '0';
				else
					Src_Adr_Branch <= '0';
					Src_Pc <= '1';
				end if;

			when "1000" => --BRA
				Imm <= Inst(15 downto 0);
				Src_Adr_Branch <= '0';
				Src_Pc <= '0';

			when others =>
				Src_PC          <= '0';
				Banc_Src        <= "00";
				Banc_Ecr        <= '0';
				Src_Op_B        <= '0';
				Src_adr_branch  <= '-';
		end case;
	end process;


	-- registres pipeline
	---------------------
	-- a vous
	---------------------
	pipline:process()
	begin
		
	end process;

	

end beh;
