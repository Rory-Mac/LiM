library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUTB is
end entity;

architecture ALUTBLogic of ALUTB is
    constant PROPAGATION_DELAY : time := 2 ps;
    signal rs1, rs2, rd : std_logic_vector(0 to 63);
    signal imm : std_logic_vector(0 to 11);
    signal opcode : std_logic_vector(0 to 6);
    signal funct3 : std_logic_vector(0 to 2);
    signal funct7 : std_logic_vector(0 to 6);
begin
    ALUInstance : entity work.ALU port map (
        rs1, rs2, rd => rs1, rs2, rd,
        imm => imm,
        opcode => opcode,
        funct3 => funct3,
        funct7 => funct7
    );

    ALUTestBench : process
    begin
        #--------------------------------------------------------------------------------------------------------------------------------------------
        # R formatted instructions
        #--------------------------------------------------------------------------------------------------------------------------------------------
        opcode <= "0110011";
        # rd = rs1 + rs2 (6,735,792,583,923,410,602 + 1,537,674,342,596,007,853 = 8,273,466,926,519,418,880)
        rs1 <= "0101110101111010010101111010101011010101011101110010011010101010";
        rs2 <= "0001010101010110111010101010101011101010101010101101011110101101";
        funct3 <= "000";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd <= "0111001011010001010000100101010111000000001000100000000000000000" report "testbench failed for ALU R-format case 1" severity error;
        # rd = rs1 + rs2 (overflow) (14,606,675,343,330,440,277 + 15,769,514,261,793,623,883 = 30,376,189,605,124,063,232)
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        rs2 <= "1101101011011000100100011010101110101110101010100100111101001011";
        wait for PROPAGATION_DELAY;
        assert rd = "1010010110001101111001111000000110000011010101010100000000000000" report "testbench failed for ALU R-format case 2" severity error;
        # rd = rs1 - rs2 (overflow (14,606,675,343,330,440,277 - 15,769,514,261,793,623,883 = -1,162,838,918,463,184,896)
        funct7 <= "0000010";
        wait for PROPAGATION_DELAY;
        assert rd = "1110111111011100110001000010101000100110000000001010000000000000" report "testbench failed for ALU R-format case 3" severity error;
        # rd = rs1 ^ rs2
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        rs2 <= "1101101011011000100100011010101110101110101010100100111101001011";
        funct3 <= "100";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "0001000001101101110001000111111001111010000000001011101100011110" report "testbench failed for ALU R-format case 4" severity error;
        # rd = rs1 || rs2
        funct3 <= "110";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "1101101011111101110101011111111111111110101010101111111101011111" report "testbench failed for ALU R-format case 5" severity error;
        # rd = rs1 && rs2
        funct3 <= "111";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "1100101010010000000100011000000110000100101010100100010001000001" report "testbench failed for ALU R-format case 6" severity error;
        # rd = rs1 << rs2
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        rs2 <= "0000000000000000000000000000000000000000000000000000000000111111";
        funct3 <= "001";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "1000000000000000000000000000000000000000000000000000000000000000" report "testbench failed for ALU R-format case 7" severity error;
        # rd = rs1 >> rs2 (zero-filled)
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        rs2 <= "0000000000000000000000000000000000000000000000000000000000111111";
        funct3 <= "101";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000001" report "testbench failed for ALU R-format case 8" severity error;
        # rd = rs1 >> rs2 (arithmetic)
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        rs2 <= "0000000000000000000000000000000000000000000000000000000000111111";
        funct3 <= "101";
        funct7 <= "0000010";
        wait for PROPAGATION_DELAY;
        assert rd = "1111111111111111111111111111111111111111111111111111111111111111" report "testbench failed for ALU R-format case 9" severity error;
        # rd = (rs1 < rs2) ? 1 : 0 (signed)
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        rs2 <= "0101001111101000001001011110101001001010101001001110101010111011";
        funct3 <= "010";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000001" report "testbench failed for ALU R-format case 10" severity error;
        rs1 <= "0101001111101000001001011110101001001010101001001110101010111011";
        rs2 <= "1100101010110101010101011101010111010100101010101111010001010101";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000000" report "testbench failed for ALU R-format case 11" severity error;
        # rd = (rs1 < rs2) ? 1 : 0 (unsigned)
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        rs2 <= "0101001111101000001001011110101001001010101001001110101010111011";
        funct3 <= "011";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000000" report "testbench failed for ALU R-format case 12" severity error;
        rs1 <= "0101001111101000001001011110101001001010101001001110101010111011";
        rs2 <= "1100101010110101010101011101010111010100101010101111010001010101";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000001" report "testbench failed for ALU R-format case 13" severity error;

        #--------------------------------------------------------------------------------------------------------------------------------------------
        # I formatted instructions
        #--------------------------------------------------------------------------------------------------------------------------------------------
        opcode <= "0010011";
        # rd = rs1 + rs2 (6,735,792,583,923,410,602 + 2613 = 6,735,792,583,923,414,016)
        rs1 <= "0101110101111010010101111010101011010101011101110010011010101010";
        imm <= "101000110101";
        funct3 <= "000";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd <= "01100101010110101010101011101010111010100101010101111100000000000" report "testbench failed for ALU I-format case 1" severity error;
        # rd = rs1 + rs2 (overflow) (18,446,744,073,709,550,633 + 1879 = 30,376,189,605,124,063,232)
        rs1 <= "1111111111111111111111111111111111111111111111111111110000101001";
        imm <= "011101010111";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000000" report "testbench failed for ALU I-format case 2" severity error;
        # rd = rs1 ^ rs2
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        imm <= "111101001011";
        funct3 <= "100";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "1100101010110101010101011101010111010100101010101111101100011110" report "testbench failed for ALU I-format case 4" severity error;
        # rd = rs1 || rs2
        funct3 <= "110";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "1100101010110101010101011101010111010100101010101111111101011111" report "testbench failed for ALU I-format case 5" severity error;
        # rd = rs1 && rs2
        funct3 <= "111";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000010001000001" report "testbench failed for ALU I-format case 6" severity error;
        # rd = rs1 << imm[0:4]
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        imm <= "000000111111";
        funct3 <= "001";
        funct7 <= "0000001";
        wait for PROPAGATION_DELAY;
        assert rd = "1000000000000000000000000000000000000000000000000000000000000000" report "testbench failed for ALU I-format case 7" severity error;
        # rd = rs1 >> imm[0:4] (zero-filled)
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        imm <= "000000111111";
        funct3 <= "101";
        funct7 <= "0000001";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000001" report "testbench failed for ALU I-format case 8" severity error;
        # rd = rs1 >> imm[0:4] (arithmetic)
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        imm <= "001000111111";
        funct3 <= "101";
        funct7 <= "0010001";
        wait for PROPAGATION_DELAY;
        assert rd = "1111111111111111111111111111111111111111111111111111111111111111" report "testbench failed for ALU I-format case 9" severity error;
        # rd = (rs1 < imm) ? 1 : 0 (signed)
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        imm <= "011111111111";
        funct3 <= "010";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000001" report "testbench failed for ALU I-format case 10" severity error;
        rs1 <= "0101001111101000001001011110101001001010101001001110101010111011";
        imm <= "111111111111";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000000" report "testbench failed for ALU I-format case 11" severity error;
        # rd = (rs1 < imm) ? 1 : 0 (unsigned)
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        imm <= "011111111111";
        funct3 <= "011";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000000" report "testbench failed for ALU I-format case 12" severity error;
        rs1 <= "1101001111101000001001011110101001001010101001001110101010111011";
        imm <= "111111111111";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000000" report "testbench failed for ALU I-format case 13" severity error;
        rs1 <= "0000000000000000000000000000000000000000000000000000000000000001";
        imm <= "111111111111";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000001" report "testbench failed for ALU I-format case 13" severity error;

        wait;
    end process;
end architecture;

