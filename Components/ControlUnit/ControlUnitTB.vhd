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
        instruction <= "00000001111111100000010000110011" -- add s0, t3, t6
        wait for CLOCK_PERIOD;
        assert opcode <= "0110011" report "testbench failed for control unit R-format decoding (1)";
        assert rd_sel <= "01000" report "testbench failed for control unit R-format decoding (2)";
        assert funct3 <= "000" report "testbench failed for control unit R-format decoding (3)";
        assert rs_sel <= "11100" report "testbench failed for control unit R-format decoding (4)";
        assert rt_sel <= "11111" report "testbench failed for control unit R-format decoding (5)";
        assert funct7 <= "0000000" report "testbench failed for control unit R-format decoding (6)";
        -- test instruction decoding (I-format)
        instruction <= "01000001011100101101000100010011" -- srai t2, t0, 23
        wait for CLOCK_PERIOD;
        assert opcode <= "0010011" report "testbench failed for control unit I-format decoding (1)";
        assert rd_sel <= "00111" report "testbench failed for control unit I-format decoding (2)";
        assert funct3 <= "101" report "testbench failed for control unit I-format decoding (3)";
        assert rs_sel <= "00101" report "testbench failed for control unit I-format decoding (4)"; -- encodes shamt
        assert rt_sel <= "10111" report "testbench failed for control unit I-format decoding (5)"; 
        assert funct7 <= "0100000" report "testbench failed for control unit I-format decoding (6)";
        assert I_imm <= "0000000000000000000000000000000000000000000000000000010000010111" report "testbench failed for control unit I-Imm decoding";
        -- test instruction decoding (S-format)
        instruction <= "01111111100000001011111110100011" -- sd ra 1024(s8)     (1024 -> 010000000000)
        wait for CLOCK_PERIOD;
        assert opcode <= "0100011" report "testbench failed for control unit S-format decoding (1)";
        assert rd_sel <= "00000" report "testbench failed for control unit S-format decoding (2)"; -- encodes offset[4:0]
        assert funct3 <= "011" report "testbench failed for control unit S-format decoding (3)";
        assert rs_sel <= "00001" report "testbench failed for control unit S-format decoding (4)";
        assert rt_sel <= "11000" report "testbench failed for control unit S-format decoding (5)"; -- encodes memory address for storage
        assert funct7 <= "0100000" report "testbench failed for control unit S-format decoding (6)"; -- encodes offset[11:5]
        assert S_imm <= "0000000000000000000000000000000000000000000000000000010000010111" report "testbench failed for control unit S-Imm decoding";
        -- test instruction decoding (B-format)
        instruction <= "10000000100101000000000001100011" -- beq s0, s1, -3972 (100001111100 - binary, 1 000111 1100 0 - IR bit fields, 100001111100 - final Imm)
        wait for CLOCK_PERIOD;
        assert opcode <= "1100011" report "testbench failed for control unit B-format decoding (1)";
        assert rd_sel <= "00000" report "testbench failed for control unit B-format decoding (2)"; -- encodes offset[4:1][11] 
        assert funct3 <= "000" report "testbench failed for control unit B-format decoding (3)"; 
        assert rs_sel <= "01000" report "testbench failed for control unit B-format decoding (4)"; 
        assert rt_sel <= "01001" report "testbench failed for control unit B-format decoding (5)"; 
        assert funct7 <= "1000000" report "testbench failed for control unit B-format decoding (6)"; -- encodes offset[4:1][11]
        assert B_imm <= "1111111111111111111111111111111111111111111111111111000011111000" report "testbench failed for control unit B-Imm decoding";
        -- test instruction decoding (U-format)
        instruction <= "00000001011000101010000011100011" -- auipc ra, 5674 (1011000101010 - binary)
        wait for CLOCK_PERIOD;
        assert opcode <= "1100011" report "testbench failed for control unit B-format decoding (1)";
        assert rd_sel <= "00001" report "testbench failed for control unit B-format decoding (2)"; 
        assert funct3 <= "010" report "testbench failed for control unit B-format decoding (3)"; -- encodes imm[14:12]
        assert rs_sel <= "00101" report "testbench failed for control unit B-format decoding (4)"; -- encodes imm[19:15]
        assert rt_sel <= "10110" report "testbench failed for control unit B-format decoding (5)"; -- encodes imm[24:20]
        assert funct7 <= "0000000" report "testbench failed for control unit B-format decoding (6)"; -- encodes imm[31:25]
        assert U_imm <= "0000000000000000000000000000000000000000000000000001011000101010" report "testbench failed for control unit U-Imm decoding";
        -- test instruction decoding (J-format)
        instruction <= "010101100111" -- jal a0, -864 (11111111111001010000 - binary, 1 1001010000 1 11111111 - imm bit fields, 1100101 00001 11111 111 - non-imm split)
        wait for CLOCK_PERIOD;
        assert opcode <= "1100111" report "testbench failed for control unit J-format decoding (1)";
        assert rd_sel <= "00000" report "testbench failed for control unit J-format decoding (2)"; 
        assert funct3 <= "111" report "testbench failed for control unit J-format decoding (3)"; -- encodes jump address [14:12]
        assert rs_sel <= "11111" report "testbench failed for control unit J-format decoding (4)"; -- encodes jump address [19:15]
        assert rt_sel <= "00001" report "testbench failed for control unit J-format decoding (5)"; -- encodes jump address [4:1][11]
        assert funct7 <= "1100101" report "testbench failed for control unit J-format decoding (6)"; -- encodes jump address [20][10:5]
        assert J_imm <= "0000000000000000000000000000000011111111111001010000000000000000" report "testbench failed for control unit J-Imm decoding";
        -- set program counter to zero
        -- test PC incrementation for non-branch instructions
        opcode <= OP;
        rs1 <= "1001001010001000001010110101110101010010101111101000010101010111";
        rs2 <= "1001001010001000001010110101110101010010101111101000010101010111";
        wait for CLOCK_PERIOD;
        assert d_out <= "0000000000000000" report "testbench failed for program counter case 1";
        opcode <= OP_IMM_32;
        wait for CLOCK_PERIOD;
        assert d_out <= "0000000000000001" report "testbench failed for program counter case 2";
        opcode <= STORE;
        wait for 8 * CLOCK_PERIOD;
        assert d_out <= "0000000000001001" report "testbench failed for program counter case 3";
        -- test conditional branch if equal
        opcode <= BRANCH;
        funct3 <= B_BEQ;
        rs1 <= "0000000000000000000000000000000000000000000000000000000000000000";
        rs2 <= "0000000000000000000000000000000000000000000000000000000000000000";
        imm <= "000000000011";
        wait for CLOCK_PERIOD;
        assert d_out <= "0000000000001100" report "testbench failed for program counter case 4";
        rs2 <= "1111111111111111111111111111111111111111111111111111111111111111";
        wait for CLOCK_PERIOD;
        assert d_out <= "0000000000001101" report "testbench failed for program counter case 5";
        -- test conditional branch if not equal
        opcode <= BRANCH;
        funct3 <= B_BNE;
        rs1 <= "0000000000000000000000000000000000000000000000000000000000000000";
        rs2 <= "1111111111111111111111111111111111111111111111111111111111111111";
        imm <= "010000000000";
        wait for CLOCK_PERIOD;
        assert d_out <= "0000010000001101" report "testbench failed for program counter case 6";
        rs2 <= "0000000000000000000000000000000000000000000000000000000000000000";
        wait for CLOCK_PERIOD;
        assert d_out <= "0000010000001110" report "testbench failed for program counter case 7";
        -- test conditional branch if less than, signed and unsigned
        opcode <= BRANCH;
        funct3 <= B_BLTU;
        rs1 <= "0000000000000000000000000000000000000000000000000000000000000000";
        rs2 <= "1111111111111111111111111111111111111111111111111111111111111111";
        imm <= "000001010000";
        wait for CLOCK_PERIOD;
        assert d_out <= "0000010001011110" report "testbench failed for program counter case 8";
        funct3 <= B_BLT;
        wait for CLOCK_PERIOD;
        assert d_out <= "0000010001011111" report "testbench failed for program counter case 9";
        rs2 <= "0111111111111111111111111111111111111111111111111111111111111111";
        wait for CLOCK_PERIOD;
        assert d_out <= "0000010010101111" report "testbench failed for program counter case 10";
        funct3 <= B_BLTU;
        rs1 <= "1000000000000000000000000000000000000000000000000000000000000000";
        wait for CLOCK_PERIOD;
        assert d_out <= "0000010010110000" report "testbench failed for program counter case 11";
        -- test conditional branch if greater than or equal to, signed and unsigned
        opcode <= BRANCH;
        funct3 <= B_BGEU;
        rs1 <= "1111111111111111111111111111111111111111111111111111111111111111";
        rs2 <= "0000000000000000000000000000000000000000000000000000000000000000";
        imm <= "010000000000";
        wait for CLOCK_PERIOD;
        assert d_out <= "0000100010110000" report "testbench failed for program counter case 12";
        funct3 <= B_BGE;
        wait for CLOCK_PERIOD;
        assert d_out <= "0000100010110001" report "testbench failed for program counter case 13";
        rs1 <= "0111111111111111111111111111111111111111111111111111111111111111";
        wait for CLOCK_PERIOD;
        assert d_out <= "0000110010110001" report "testbench failed for program counter case 14";
        funct3 <= B_BGEU;
        rs2 <= "1000000000000000000000000000000000000000000000000000000000000000";
        wait for CLOCK_PERIOD;
        assert d_out <= "0000110010110010" report "testbench failed for program counter case 15";
        -- test jal
        opcode <= JAL;
        upper_imm <= "00000000000000001010";
        wait for CLOCK_PERIOD;
        assert d_out <= "0001010010111100" report "testbench failed for program counter case 16";
        assert rd <= "0000000000000000000000000000000000000000000000000001010010110011" report "testbench failed for program counter case 17";
        -- test jalr
        opcode <= JALR;
        rs1 <= "1111000000000000000000000000000000000000000000000000000000000000";
        imm <= "000000001010";
        wait for CLOCK_PERIOD;
        assert d_out <= "0001010011000110" report "testbench failed for program counter case 18";
        assert rd <= "0000000000000000000000000000000000000000000000000001010010111101" report "testbench failed for program counter case 19";
        rs1 <= "0000000000000000000000000000000000000000000000000000000000000001";
        imm <= "100000000000";
        wait for CLOCK_PERIOD;
        assert d_out <= "1111100000000001" report "testbench failed for program counter case 20";
        assert rd <= "0000000000000000000000000000000000000000000000000001010011000111" report "testbench failed for program counter case 21";
        -- test auipc
        opcode <= AUIPC;
        upper_imm <= "01100100010101101011";
        wait for CLOCK_PERIOD;
        assert d_out <= "0011110101101100" report "testbench failed for program counter case 22";
        wait;
    end process;
end architecture;
