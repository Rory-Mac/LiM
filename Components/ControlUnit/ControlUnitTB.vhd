library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xil_defaultlib;
use xil_defaultlib.ISAListings.all;

entity ControlUnitTB is
end ControlUnitTB;

architecture ControlUnitTBLogic of ControlUnitTB is
    constant CLOCK_PERIOD : time := 2 ps;
    constant SIMULATION_LENGTH : time := 1000 ps;
    signal clk, eq, lt, ltu : std_logic;
    signal instruction : signed(31 downto 0);
    signal pc_out : unsigned(0 to 15);
    -- decoded instruction signals (operands + control bits)
    signal opcode : std_logic_vector(6 downto 0);
    signal rd_sel : std_logic_vector(4 downto 0);
    signal funct3 : std_logic_vector(2 downto 0);
    signal rs_sel : std_logic_vector(4 downto 0);
    signal rt_sel : std_logic_vector(4 downto 0);
    signal funct7 : std_logic_vector(6 downto 0);
    -- decoded instruction signals (immediates + offsets)
    signal I_imm : signed(63 downto 0);
    signal S_imm : signed(63 downto 0);
    signal B_imm : signed(63 downto 0);
    signal U_imm : signed(63 downto 0);
    signal J_imm : signed(63 downto 0);
    -- additional signals
    signal ja : signed(0 to 63); -- value to be loaded from core register specified by rs_sel (to be used by jalr instruction)
    signal ra : signed(0 to 63); -- value to be stored in core register specified by rd_sel (used by jump instructions)
begin
    ControlUnitInstance : entity work.ControlUnit port map (
        clk => clk, instruction => instruction, pc_out => pc_out, eq => eq, lt => lt, ltu => ltu, opcode => opcode, rd_sel => rd_sel, funct3 => funct3, 
        rs_sel => rs_sel, rt_sel => rt_sel, funct7 => funct7, I_imm => I_imm, S_imm => S_imm, B_imm => B_imm, U_imm => U_imm, J_imm => J_imm, ja => ja, ra => ra
    );
    ClockProcess : process
    begin
        while now < SIMULATION_LENGTH loop
            clk <= '0';
            wait for CLOCK_PERIOD / 2;
            clk <= '1';
            wait for CLOCK_PERIOD / 2;
        end loop;
        wait;
    end process;

    ControlUnitTestSuite : process
    begin
        -- test instruction decoding (R-format)
        instruction <= "00000001111111100000010000110011"; -- add s0, t3, t6
        wait for CLOCK_PERIOD;
        assert opcode <= "0110011" report "testbench failed for control unit R-format decoding (1)";
        assert rd_sel <= "01000" report "testbench failed for control unit R-format decoding (2)";
        assert funct3 <= "000" report "testbench failed for control unit R-format decoding (3)";
        assert rs_sel <= "11100" report "testbench failed for control unit R-format decoding (4)";
        assert rt_sel <= "11111" report "testbench failed for control unit R-format decoding (5)";
        assert funct7 <= "0000000" report "testbench failed for control unit R-format decoding (6)";
        -- test instruction decoding (I-format)
        instruction <= "01000001011100101101000100010011"; -- srai t2, t0, 23
        wait for CLOCK_PERIOD;
        assert opcode <= "0010011" report "testbench failed for control unit I-format decoding (1)";
        assert rd_sel <= "00111" report "testbench failed for control unit I-format decoding (2)";
        assert funct3 <= "101" report "testbench failed for control unit I-format decoding (3)";
        assert rs_sel <= "00101" report "testbench failed for control unit I-format decoding (4)"; -- encodes shamt
        assert rt_sel <= "10111" report "testbench failed for control unit I-format decoding (5)"; 
        assert funct7 <= "0100000" report "testbench failed for control unit I-format decoding (6)";
        assert I_imm <= "0000000000000000000000000000000000000000000000000000010000010111" report "testbench failed for control unit I-Imm decoding";
        -- test instruction decoding (S-format)
        instruction <= "01000000000111000011000000100011"; -- sd ra 1024(s8)     (1024 -> 010000000000 -> 0100000 00000)
        wait for CLOCK_PERIOD;
        assert opcode <= "0100011" report "testbench failed for control unit S-format decoding (1)";
        assert rd_sel <= "00000" report "testbench failed for control unit S-format decoding (2)"; -- encodes offset[4:0]
        assert funct3 <= "011" report "testbench failed for control unit S-format decoding (3)";
        assert rs_sel <= "11000" report "testbench failed for control unit S-format decoding (4)";
        assert rt_sel <= "00001" report "testbench failed for control unit S-format decoding (5)"; -- encodes memory address for storage
        assert funct7 <= "0100000" report "testbench failed for control unit S-format decoding (6)"; -- encodes offset[11:5]
        assert S_imm <= "0000000000000000000000000000000000000000000000000000010000010111" report "testbench failed for control unit S-Imm decoding";
        -- test instruction decoding (B-format)
        instruction <= "10000000100101000000000001100011"; -- beq s0, s1, -3972 (100001111100 - binary, 1 000111 1100 0 - IR bit fields, 100001111100 - final Imm)
        wait for CLOCK_PERIOD;
        assert opcode <= "1100011" report "testbench failed for control unit B-format decoding (1)";
        assert rd_sel <= "00000" report "testbench failed for control unit B-format decoding (2)"; -- encodes offset[4:1][11] 
        assert funct3 <= "000" report "testbench failed for control unit B-format decoding (3)"; 
        assert rs_sel <= "01000" report "testbench failed for control unit B-format decoding (4)"; 
        assert rt_sel <= "01001" report "testbench failed for control unit B-format decoding (5)"; 
        assert funct7 <= "1000000" report "testbench failed for control unit B-format decoding (6)"; -- encodes offset[4:1][11]
        assert B_imm <= "1111111111111111111111111111111111111111111111111111000011111000" report "testbench failed for control unit B-Imm decoding";
        -- test instruction decoding (U-format)
        instruction <= "00000001011000101010000011100011"; -- auipc ra, 5674    (5674 -> 00000001011000101010)
        wait for CLOCK_PERIOD;
        assert opcode <= "1100011" report "testbench failed for control unit B-format decoding (1)";
        assert rd_sel <= "00001" report "testbench failed for control unit B-format decoding (2)"; 
        assert funct3 <= "010" report "testbench failed for control unit B-format decoding (3)"; -- encodes imm[14:12]
        assert rs_sel <= "00101" report "testbench failed for control unit B-format decoding (4)"; -- encodes imm[19:15]
        assert rt_sel <= "10110" report "testbench failed for control unit B-format decoding (5)"; -- encodes imm[24:20]
        assert funct7 <= "0000000" report "testbench failed for control unit B-format decoding (6)"; -- encodes imm[31:25]
        assert U_imm <= "0000000000000000000000000000000000000001011000101010000000000000" report "testbench failed for control unit U-Imm decoding";
        -- test instruction decoding (J-format)
        instruction <= "11001010000111111111000001100111"; -- jal a0, -864      (-864 -> 11111111111001010000 -> 1 1001010000 1 11111111 -> 1100101 00001 11111 111)
        wait for CLOCK_PERIOD;
        assert opcode <= "1100111" report "testbench failed for control unit J-format decoding (1)";
        assert rd_sel <= "00000" report "testbench failed for control unit J-format decoding (2)"; 
        assert funct3 <= "111" report "testbench failed for control unit J-format decoding (3)"; -- encodes jump address [14:12]
        assert rs_sel <= "11111" report "testbench failed for control unit J-format decoding (4)"; -- encodes jump address [19:15]
        assert rt_sel <= "00001" report "testbench failed for control unit J-format decoding (5)"; -- encodes jump address [4:1][11]
        assert funct7 <= "1100101" report "testbench failed for control unit J-format decoding (6)"; -- encodes jump address [20][10:5]
        assert J_imm <= "0000000000000000000000000000000011111111111001010000000000000000" report "testbench failed for control unit J-Imm decoding";
        -- set program counter to zero
        opcode <= JALR;
        ja <= "0000000000000000000000000000000000000000000000000000000000000000";
        instruction <= "00000000000001010000010001100111"; -- jalr s0, a0, 0
        wait for CLOCK_PERIOD; -- wait one clock cycle for instruction signal to be loaded into instruction register
        wait for CLOCK_PERIOD; -- wait one clock cycle for program counter to update in response to signal change
        assert opcode <= "1100111" report "testbench failed for set program counter to zero with jalr  (1)";
        assert rd_sel <= "01000" report "testbench failed for set program counter to zero with jalr (2)"; 
        assert funct3 <= "000" report "testbench failed for set program counter to zero with jalr (3)"; -- encodes jump address [14:12]
        assert rs_sel <= "01010" report "testbench failed for set program counter to zero with jalr (4)"; -- encodes jump address [19:15]
        assert rt_sel <= "00000" report "testbench failed for set program counter to zero with jalr (5)"; -- encodes jump address [4:1][11]
        assert funct7 <= "0000000" report "testbench failed for set program counter to zero with jalr (6)"; -- encodes jump address [20][10:5]
        assert J_imm <= "0000000000000000000000000000000011111111111001010000000000000000" report "testbench failed for set program counter to zero with jalr (7)";
        assert pc_out <= "0000000000000000" report "testbench failed for set program counter to zero with jalr (8)";
        -- test PC incrementation for non-branch instructions
        opcode <= OP;
        wait for CLOCK_PERIOD;
        assert pc_out <= "0000000000000001" report "testbench failed for increment program counter (1)";
        opcode <= OP_IMM_32;
        wait for CLOCK_PERIOD;
        assert pc_out <= "0000000000000010" report "testbench failed for increment program counter (2)";
        opcode <= STORE;
        wait for 8 * CLOCK_PERIOD;
        assert pc_out <= "0000000000001010" report "testbench failed for increment program counter (3)";
        -- test conditional branch if equal
        opcode <= BRANCH;
        instruction <= "00000000100101000000011001100011"; -- beq s0, s1, 3     (3 -> 12 -> 1100 -> 0 0 000000 0110 -> 0 000000 0110 0) 
        eq <= '1';
        wait for CLOCK_PERIOD;
        assert opcode <= "1100011" report "testbench failed for set program counter with beq (1)";
        assert rd_sel <= "01100" report "testbench failed for set program counter with beq (2)"; 
        assert funct3 <= "000" report "testbench failed for set program counter with beq (3)";
        assert rs_sel <= "01000" report "testbench failed for set program counter with beq (4)";
        assert rt_sel <= "01001" report "testbench failed for set program counter with beq (5)"; -- encodes jump address [4:1][11]
        assert funct7 <= "0000000" report "testbench failed for set program counter with beq (6)"; -- encodes jump address [12][10:5]
        assert B_imm <= "0000000000000000000000000000000000000000000000000000000000001100" report "testbench failed for set program counter with beq (7)";
        assert pc_out <= "0000000000010110" report "testbench failed for set program counter with beq (8)";
        -- test conditional branch if not equal
        opcode <= BRANCH;
        instruction <= "00000000100101000001011001100011"; -- bne s0, s1, 3     (3 -> 12 -> 1100 -> 0 0 000000 0110 -> 0 000000 0110 0)
        eq <= '0';
        wait for CLOCK_PERIOD;
        assert B_imm <= "0000000000000000000000000000000000000000000000000000000000001100" report "testbench failed for set program counter with bne (1)";
        assert pc_out <= "0000000000100010" report "testbench failed for set program counter with bne (2)";
        eq <= '1';
        wait for CLOCK_PERIOD;
        assert pc_out <= "0000000000100011" report "testbench failed for set program counter with bne (3)";
        -- test conditional branch if less than, signed and unsigned
        opcode <= BRANCH;
        instruction <= "00000000100101000110011001100011"; -- bltu s0, s1, 3     (3 -> 12 -> 1100 -> 0 0 000000 0110 -> 0 000000 0110 0)
        ltu <= '1';
        wait for CLOCK_PERIOD;
        assert B_imm <= "0000000000000000000000000000000000000000000000000000000000001100" report "testbench failed for set program counter with bltu (1)";
        assert pc_out <= "0000000000101111" report "testbench failed for set program counter with bltu (2)";
        ltu <= '0';
        wait for CLOCK_PERIOD;
        assert pc_out <= "0000000000110000" report "testbench failed for set program counter with bltu (3)";
        lt <= '1';
        instruction <= "00000000100101000100011001100011"; -- blt s0, s1, 3     (3 -> 12 -> 1100 -> 0 0 000000 0110 -> 0 000000 0110 0)
        wait for CLOCK_PERIOD;
        assert pc_out <= "0000000000111100" report "testbench failed for set program counter with blt (1)";
        lt <= '0';
        wait for CLOCK_PERIOD;
        assert pc_out <= "0000000000111101" report "testbench failed for set program counter with blt (2)";
        -- test conditional branch if greater than or equal to, signed and unsigned
        opcode <= BRANCH;
        instruction <= "00000000100101000111011001100011"; -- bgeu s0, s1, 3     (3 -> 12 -> 1100 -> 0 0 000000 0110 -> 0 000000 0110 0)
        ltu <= '1';
        wait for CLOCK_PERIOD;
        assert pc_out <= "0000000000111110" report "testbench failed for set program counter with bgeu (1)";
        ltu <= '0';
        wait for CLOCK_PERIOD;
        assert pc_out <= "0000000001001010" report "testbench failed for set program counter with bgeu (2)";
        instruction <= "00000000100101000101011001100011"; -- bge s0, s1, 3     (3 -> 12 -> 1100 -> 0 0 000000 0110 -> 0 000000 0110 0)
        lt <= '1';
        wait for CLOCK_PERIOD;
        assert pc_out <= "0000000001001011" report "testbench failed for set program counter with bge (1)";
        lt <= '0';
        wait for CLOCK_PERIOD;
        assert pc_out <= "0000000001010111" report "testbench failed for set program counter with bge (2)";
        -- test jal with offset
        opcode <= JAL;
        instruction <= "00101110011000000000010001101111"; -- jal s0, 742    (742 -> 1011100110 -> 0 00000000 0 0101110011 -> 0 0101110011 0 00000000)
        wait for CLOCK_PERIOD;
        assert ra <= "0000000000000000000000000000000000000000000000000000000001011011" report "testbench failed for set program counter with jal (1)";
        assert pc_out <= "0000001100111101" report "testbench failed for set program counter with jal (2)";
        -- test jalr with offset
        opcode <= JALR;
        instruction <= "00000000000001010000010001100111"; -- jalr s0, a0, 100   (100 -> 1100100)
        ja <= "0000000000000000000000000000000000000000000000000000000000000111";
        wait for CLOCK_PERIOD;
        assert ra <= "0000001101000001" report "testbench failed for set program counter with jalr (1)";
        assert pc_out <= "0000000001101011" report "testbench failed for set program counter with jalr (2)";
        -- test auipc
        opcode <= AUIPC;
        instruction <= "00101110011000000000010000010111"; -- auipc s0, 742    (742 -> 1011100110 -> 0 00000000 0 0101110011 -> 0 0101110011 0 00000000)
        wait for CLOCK_PERIOD;
        assert pc_out <= "0000001101010001" report "testbench failed for set program counter with auipc (1)";
        assert ra <= "0000000001101111" report "testbench failed for set program counter with auipc (2)";
        wait;
    end process;
end architecture;
