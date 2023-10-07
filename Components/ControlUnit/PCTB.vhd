library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xil_defaultlib;
use xil_defaultlib.ISAListings.all;

entity PCTB is
end PCTB;

architecture PCTBLogic of PCTB is
    constant CLOCK_PERIOD : time := 2 ps;
    constant SIMULATION_LENGTH : time := 1000 ps;
    signal clk : std_logic;
    signal opcode : std_logic_vector(0 to 6);
    signal funct3 : std_logic_vector(0 to 2);
    signal d_out : unsigned(0 to 15);
    signal rs1, rs2, rd : signed(0 to 63);
    signal imm : signed(0 to 11);
    signal upper_imm : signed(0 to 19);
begin
    PCInstance : entity work.PC port map (
        clk => clk, opcode => opcode, funct3 => funct3, imm => imm, upper_imm => upper_imm, rs1 => rs1, rs2 => rs2, rd => rd, d_out => d_out);
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

    PCTestBench : process
    begin
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
