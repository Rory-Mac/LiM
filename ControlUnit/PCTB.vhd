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
    signal d_in, d_out : unsigned(0 to 63);
    signal rs1, rs2 : signed(0 to 63);
begin
    PCInstance : entity work.PC port map (clk => clk, opcode => opcode, funct3 => funct3, rs1 => rs1, rs2 => rs2, d_in => d_in, d_out => d_out);
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
        assert d_out <= "0000000000000000000000000000000000000000000000000000000000000000" report "testbench failed for program counter case 1";
        opcode <= OP_IMM_32;
        wait for CLOCK_PERIOD;
        assert d_out <= "0000000000000000000000000000000000000000000000000000000000000001" report "testbench failed for program counter case 2";
        opcode <= STORE;
        wait for 8 * CLOCK_PERIOD;
        assert d_out <= "0000000000000000000000000000000000000000000000000000000000001001" report "testbench failed for program counter case 3";
        -- test conditional branch if equal
        opcode <= BRANCH;
        funct3 <= B_BEQ;
        rs1 <= "0000000000000000000000000000000000000000000000000000000000000000";
        rs2 <= "0000000000000000000000000000000000000000000000000000000000000000";
        d_in <= "010101001010100101010010101001010100101010010101001010101001011";
        wait for CLOCK_PERIOD;
        assert d_out <= "010101001010100101010010101001010100101010010101001010101001011" report "testbench failed for program counter case 4";
        rs2 <= "1111111111111111111111111111111111111111111111111111111111111111";
        wait for CLOCK_PERIOD;
        assert d_out <= "010101001010100101010010101001010100101010010101001010101001100" report "testbench failed for program counter case 5";
        -- test conditional branch if not equal
        opcode <= BRANCH;
        funct3 <= B_BNE;
        rs1 <= "0000000000000000000000000000000000000000000000000000000000000000";
        rs2 <= "1111111111111111111111111111111111111111111111111111111111111111";
        d_in <= "010101001010100101010010101001010100101010010101001010101001011";
        wait for CLOCK_PERIOD;
        assert d_out <= "010101001010100101010010101001010100101010010101001010101001011" report "testbench failed for program counter case 6";
        rs2 <= "0000000000000000000000000000000000000000000000000000000000000000";
        wait for CLOCK_PERIOD;
        assert d_out <= "010101001010100101010010101001010100101010010101001010101001100" report "testbench failed for program counter case 7";
        -- test conditional branch if less than, signed and unsigned
        opcode <= BRANCH;
        funct3 <= B_BLTU;
        rs1 <= "0000000000000000000000000000000000000000000000000000000000000000";
        rs2 <= "1111111111111111111111111111111111111111111111111111111111111111";
        d_in <= "010101001010100101010010101001010100101010010101001010101001011";
        wait for CLOCK_PERIOD;
        assert d_out <= "010101001010100101010010101001010100101010010101001010101001011" report "testbench failed for program counter case 8";
        funct3 <= B_BLT;
        wait for CLOCK_PERIOD;
        assert d_out <= "010101001010100101010010101001010100101010010101001010101001100" report "testbench failed for program counter case 9";
        rs2 <= "0111111111111111111111111111111111111111111111111111111111111111";
        wait for CLOCK_PERIOD;
        assert d_out <= "010101001010100101010010101001010100101010010101001010101001011" report "testbench failed for program counter case 10";
        funct3 <= B_BLTU;
        rs1 <= "1000000000000000000000000000000000000000000000000000000000000000";
        wait for CLOCK_PERIOD;
        assert d_out <= "010101001010100101010010101001010100101010010101001010101001100" report "testbench failed for program counter case 11";
        -- test conditional branch if greater than or equal to, signed and unsigned
        opcode <= BRANCH;
        funct3 <= B_BGEU;
        rs1 <= "1111111111111111111111111111111111111111111111111111111111111111";
        rs2 <= "0000000000000000000000000000000000000000000000000000000000000000";
        d_in <= "010101001010100101010010101001010100101010010101001010101001011";
        wait for CLOCK_PERIOD;
        assert d_out <= "010101001010100101010010101001010100101010010101001010101001011" report "testbench failed for program counter case 12";
        funct3 <= B_BGEU;
        wait for CLOCK_PERIOD;
        assert d_out <= "010101001010100101010010101001010100101010010101001010101001100" report "testbench failed for program counter case 13";
        rs1 <= "0111111111111111111111111111111111111111111111111111111111111111";
        wait for CLOCK_PERIOD;
        assert d_out <= "010101001010100101010010101001010100101010010101001010101001011" report "testbench failed for program counter case 14";
        funct3 <= B_BGEU;
        rs2 <= "1000000000000000000000000000000000000000000000000000000000000000";
        wait for CLOCK_PERIOD;
        assert d_out <= "010101001010100101010010101001010100101010010101001010101001100" report "testbench failed for program counter case 15";
    end process;

end architecture;