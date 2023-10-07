library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUTB is
end entity;

architecture ALUTBLogic of ALUTB is
    constant PROPAGATION_DELAY : time := 2 ps;
    signal rs1, rs2, rd : signed(0 to 63);
    signal imm : signed(0 to 11);
    signal opcode : std_logic_vector(0 to 6);
    signal funct3 : std_logic_vector(0 to 2);
    signal funct7 : std_logic_vector(0 to 6);
begin
    ALUInstance : entity work.ALU port map (
        rs1 => rs1,
        rs2 => rs2,
        rd => rd,
        imm => imm,
        opcode => opcode,
        funct3 => funct3,
        funct7 => funct7
    );

    ALUTestBench : process
    begin
        ---------------------------------------------------------------------------------------------------------------------------------------------
        -- R formatted instructions
        ---------------------------------------------------------------------------------------------------------------------------------------------
        opcode <= "0110011";
        -- rd = rs1 + rs2 (6,735,792,583,923,410,602 + 1,537,674,342,596,007,853 = 8,273,466,926,519,418,880)
        rs1 <= "0101110101111010010101111010101011010101011101110010011010101010";
        rs2 <= "0001010101010110111010101010101011101010101010101101011110101101";
        funct3 <= "000";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd <= "0111001011010001010000100101010111000000001000100000000000000000" report "testbench failed for ALU R-format add" severity error;
        -- rd = rs1 + rs2 (overflow) (14,606,675,343,330,440,277 + 15,769,514,261,793,623,883 = 30,376,189,605,124,063,232)
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        rs2 <= "1101101011011000100100011010101110101110101010100100111101001011";
        wait for PROPAGATION_DELAY;
        assert rd = "1010010110001101111001111000000110000011010101010100001110100000" report "testbench failed for ALU R-format add with overflow" severity error;
        -- rd = rs1 - rs2 (overflow) (14,606,675,343,330,440,277 - 15,769,514,261,793,623,883 = -1,162,838,918,463,184,896)
        funct7 <= "0100000";
        wait for PROPAGATION_DELAY;
        assert rd = "1110111111011100110001000010101000100110000000001010010100001010" report "testbench failed for ALU R-format sub with overflow" severity error;
        -- rd = rs1 - rs2 (1,000,000,000 - 999,999,999 = 1)
        rs1 <= "0000000000000000000000000000000000111011100110101100101000000000";
        rs2 <= "0000000000000000000000000000000000111011100110101100100111111111";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000001" report "testbench failed for ALU R-format sub (+/+)";
        -- rd = rs1 - rs2 (-1,000,000,000 - 1,000,000,000 = -2,000,000,000)
        rs1 <= "1111111111111111111111111111111111000100011001010011011000000000";
        rs2 <= "0000000000000000000000000000000000111011100110101100101000000000";
        wait for PROPAGATION_DELAY;
        assert rd = "1111111111111111111111111111111110001000110010100110110000000000" report "testbench failed for ALU R-format sub (-/-)";
        -- rd = rs1 ^ rs2
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        rs2 <= "1101101011011000100100011010101110101110101010100100111101001011";
        funct3 <= "100";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "0001000001101101110001000111111001111010000000001011101100011110" report "testbench failed for ALU R-format XOR" severity error;
        -- rd = rs1 || rs2
        funct3 <= "110";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "1101101011111101110101011111111111111110101010101111111101011111" report "testbench failed for ALU R-format OR" severity error;
        -- rd = rs1 && rs2
        funct3 <= "111";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "1100101010010000000100011000000110000100101010100100010001000001" report "testbench failed for ALU R-format AND" severity error;
        -- rd = rs1 << rs2
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        rs2 <= "0000000000000000000000000000000000000000000000000000000000111111";
        funct3 <= "001";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "1000000000000000000000000000000000000000000000000000000000000000" report "testbench failed for ALU R-format sll" severity error;
        -- rd = rs1 >> rs2 (zero-filled)
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        rs2 <= "0000000000000000000000000000000000000000000000000000000000111111";
        funct3 <= "101";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000001" report "testbench failed for ALU R-format srl" severity error;
        -- rd = rs1 >> rs2 (arithmetic)
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        rs2 <= "0000000000000000000000000000000000000000000000000000000000111111";
        funct3 <= "101";
        funct7 <= "0100000";
        wait for PROPAGATION_DELAY;
        assert rd = "1111111111111111111111111111111111111111111111111111111111111111" report "testbench failed for ALU R-format sra" severity error;
        -- rd = (rs1 < rs2) ? 1 : 0 (signed)
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        rs2 <= "0101001111101000001001011110101001001010101001001110101010111011";
        funct3 <= "010";
        funct7 <= "0100000";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000001" report "testbench failed for ALU R-format slt (lt evaluates false)" severity error;
        rs1 <= "0101001111101000001001011110101001001010101001001110101010111011";
        rs2 <= "1100101010110101010101011101010111010100101010101111010001010101";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000000" report "testbench failed for ALU R-format slt (lt evaluates true)" severity error;
        -- rd = (rs1 < rs2) ? 1 : 0 (unsigned)
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        rs2 <= "0101001111101000001001011110101001001010101001001110101010111011";
        funct3 <= "011";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000000" report "testbench failed for ALU R-format sltu (evaluates false)" severity error;
        rs1 <= "0101001111101000001001011110101001001010101001001110101010111011";
        rs2 <= "1100101010110101010101011101010111010100101010101111010001010101";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000001" report "testbench failed for ALU R-format sltu (evalutates true)" severity error;
        ----------------------------------------------------------------------------------------------------------------------------------------------
        -- R formatted instructions (R64I extensions)
        ----------------------------------------------------------------------------------------------------------------------------------------------
        opcode <= "0111011";
        -- addw
        funct3 <= "000";
        funct7 <= "0000000";
        rs1 <= "0101110101111010010101111010101011010101011101110010011010101010";
        rs2 <= "0001010101010110111010101010101011101010101010101101011110101101";
        wait for PROPAGATION_DELAY;
        assert rd <= "1111111111111111111111111111111111000000001000100000000000000000" report "testbench failed for ALU R-format addw" severity error;
        -- subw
        funct3 <= "000";
        funct7 <= "0100000";
        rs1 <= "1110100010010111011011100110100001010001010111010111010101111010";
        rs2 <= "0001110101010100100010001000101011111010111101011001000000111101";
        wait for PROPAGATION_DELAY;
        assert rd <= "0000000000000000000000000000000001010110011001111110100000000000" report "testbench failed for ALU R-format subw" severity error;
        -- sllw
        funct3 <= "000";
        funct7 <= "0100000";
        rs1 <= "1111111111111111111111111111111111111111111111111111111101111111";
        rs2 <= "0000000000000000000000000000000000000000000000000000000000011000";
        wait for PROPAGATION_DELAY;
        assert rd <= "0000000000000000000000000000000001111111000000000000000000000000" report "testbench failed for ALU R-format sllw" severity error;
        -- srlw
        funct3 <= "000";
        funct7 <= "0000000";
        rs1 <= "1111111101111111111111111111111111111111111111111111111111111111";
        rs2 <= "0000000000000000000000000000000000000000000000000000000000011000";
        wait for PROPAGATION_DELAY;
        assert rd <= "0000000000000000000000000000000001111111111111111111111111111111" report "testbench failed for ALU R-format srlw" severity error;
        -- sraw
        funct3 <= "000";
        funct7 <= "0100000";
        rs1 <= "1111111101111111111111111111111111111111111111111111111111111111";
        rs2 <= "0000000000000000000000000000000000000000000000000000000000011000";
        wait for PROPAGATION_DELAY;
        assert rd <= "0000000000000000000000000000000001111111111111111111111111111111" report "testbench failed for ALU R-format srlw" severity error;
        ----------------------------------------------------------------------------------------------------------------------------------------------
        -- I formatted instructions
        ----------------------------------------------------------------------------------------------------------------------------------------------
        opcode <= "0010011";
        -- rd = rs1 + imm (6,735,792,583,923,410,602 + -1483 = 6,735,792,583,923,409,119)
        rs1 <= "0101110101111010010101111010101011010101011101110010011010101010";
        imm <= "101000110101";
        funct3 <= "000";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd <= "0101110101111010010101111010101011010101011101110010000011011111" report "testbench failed for ALU I-format addi" severity error;
        -- rd = rs1 + imm (overflow) (18,446,744,073,709,550,633 + 1879 = 30,376,189,605,124,063,232)
        rs1 <= "1111111111111111111111111111111111111111111111111111110000101001";
        imm <= "011101010111";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000001110000000" report "testbench failed for ALU I-format addi (overflow)" severity error;
        -- rd = rs1 ^ rs2
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        imm <= "111101001011";
        funct3 <= "100";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "0011010101001010101010100010101000101011010101010000101100011110" report "testbench failed for ALU I-format xori" severity error;
        -- rd = rs1 || rs2
        funct3 <= "110";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "1111111111111111111111111111111111111111111111111111111101011111" report "testbench failed for ALU I-format ori (negative imm)" severity error;
        imm <= "011101001011";
        wait for PROPAGATION_DELAY;
        assert rd = "1100101010110101010101011101010111010100101010101111011101011111" report "testbench failed for ALU I-format ori (positive imm)" severity error;
        -- rd = rs1 && rs2
        imm <= "111101001011";
        funct3 <= "111";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "1100101010110101010101011101010111010100101010101111010001000001" report "testbench failed for ALU I-format andi" severity error;
        -- rd = rs1 << imm[6:11]
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        imm <= "000000111111";
        funct3 <= "001";
        funct7 <= "0000001";
        wait for PROPAGATION_DELAY;
        assert rd = "1000000000000000000000000000000000000000000000000000000000000000" report "testbench failed for ALU I-format slli" severity error;
        -- rd = rs1 >> imm[6:11] (zero-filled)
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        imm <= "000000111111";
        funct3 <= "101";
        funct7 <= "0000001";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000001" report "testbench failed for ALU I-format srli" severity error;
        -- rd = rs1 >> imm[6:11] (arithmetic)
        rs1 <= "0000000000000000000000000000000011111111111111111111111111111111";
        imm <= "010000010000";
        funct3 <= "101";
        funct7 <= "0100001";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000001111111111111111" report "testbench failed for ALU I-format srai (sign-extend zero, imm 16)" severity error;        
        rs1 <= "1111111111111111111111111111111100000000000000000000000000000000";
        imm <= "010000010000";
        funct3 <= "101";
        funct7 <= "0100001";
        wait for PROPAGATION_DELAY;
        assert rd = "1111111111111111111111111111111111111111111111110000000000000000" report "testbench failed for ALU I-format srai (sign-extend one, imm 16)" severity error;
        rs1 <= "0100101010110101010101011101010111010100101010101111010001010101";
        imm <= "010000111111";
        funct3 <= "101";
        funct7 <= "0100001";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000000" report "testbench failed for ALU I-format srai (sign-extend zero, imm 64)" severity error;
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        imm <= "010000111111";
        funct3 <= "101";
        funct7 <= "0100001";
        wait for PROPAGATION_DELAY;
        assert rd = "1111111111111111111111111111111111111111111111111111111111111111" report "testbench failed for ALU I-format srai (sign-extend one, imm 64)" severity error;
        -- rd = (rs1 < imm) ? 1 : 0 (signed)
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        imm <= "011111111111";
        funct3 <= "010";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000001" report "testbench failed for ALU I-format slti (evaluates true)" severity error;
        rs1 <= "0101001111101000001001011110101001001010101001001110101010111011";
        imm <= "111111111111";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000000" report "testbench failed for ALU I-format slti (evaluates false)" severity error;
        -- rd = (rs1 < imm) ? 1 : 0 (unsigned)
        rs1 <= "1100101010110101010101011101010111010100101010101111010001010101";
        imm <= "011111111111";
        funct3 <= "011";
        funct7 <= "0000000";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000000" report "testbench failed for ALU I-format sltiu (evaluates false) (1)" severity error;
        rs1 <= "1101001111101000001001011110101001001010101001001110101010111011";
        imm <= "111111111111";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000000" report "testbench failed for ALU I-format sltiu (evaluates false) (2)" severity error;
        rs1 <= "0000000000000000000000000000000000000000000000000000000000000001";
        imm <= "111111111111";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000000000000000000000000000000000001" report "testbench failed for ALU I-format sltiu (evaluates true)" severity error;
        ----------------------------------------------------------------------------------------------------------------------------------------------
        -- I formatted instructions (R64I extensions)
        ----------------------------------------------------------------------------------------------------------------------------------------------
        opcode <= "0011011";
        -- rd = (rs1 + 12)[32:63] msb-extends 64-bit promotion
        funct3 <= "000";
        rs1 <= "1101001111101000001001011110101001001010101001001110101010111011";
        imm <= "010101010011";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000001001010101001001111000000001110" report "testbench failed for ALU I-format addiw (positive imm)" severity error;
        rs1 <= "1101001111101000001001011110101001001010101001001110101010111011";
        imm <= "110101010011";
        funct3 <= "000";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000001001010101001001110100000001110" report "testbench failed for ALU I-format addiw (negative imm)" severity error;
        imm <= "110101010011";
        rs1 <= "1101001111101000001001011110101011001010101001001110101010111011";
        wait for PROPAGATION_DELAY;
        assert rd = "1111111111111111111111111111111111001010101001001110100000001110" report "testbench failed for ALU I-format addiw (sign-extension)" severity error;
        -- rd = (rs1[32:63] << imm)[32:63] msb-extends 64-bit promotion
        rs1 <= "1100101010101010011101011110101011010010001000010101101110100101";
        funct3 <= "001";
        funct7 <= "0000000";
        imm <= "000000010010";
        wait for PROPAGATION_DELAY;
        assert rd = "0000000000000000000000000000000001101110100101000000000000000000" report "testbench failed for ALU I-format slliw" severity error;
        -- rd = (rs1[32:63] >> imm)[32:63] zero-extends 64-bit promotion
        rs1 <= "1100101010101010011101011110101011010010001000010101101110100101";
        imm <= "000000010010";
        funct3 <= "101";
        wait for PROPAGATION_DELAY;
        assert rd = "1111111111111111111111111111111110011101011110101011010010001000" report "testbench failed for ALU I-format srliw" severity error;
        -- rd = (rs1[32:63] >> imm)[32:63] msb-extends 64-bit promotion
        funct7 <= "0100000";
        wait for PROPAGATION_DELAY;
        assert rd = "1111111111111111111111111111111110011101011110101011010010001000" report "testbench failed for ALU I-format sraiw" severity error;
        wait;
    end process;
end architecture;
