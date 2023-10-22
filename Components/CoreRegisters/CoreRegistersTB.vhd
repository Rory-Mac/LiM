library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xil_defaultlib;
use xil_defaultlib.ISAListings.all;

entity CoreRegistersTB is
end CoreRegistersTB;

architecture CoreRegistersTBLogic of CoreRegistersTB is
    constant CLOCK_PERIOD : time := 2 ps;
    constant SIMULATION_LENGTH : time := 1000 ps;
    signal clk : std_logic;
    signal opcode : std_logic_vector(0 to 6);
    signal upper_imm : signed(63 downto 0);
    signal ra, lv : signed(63 downto 0);
    signal rs_sel, rt_sel, rd_sel : std_logic_vector(0 to 4);
    signal rd_in, rs_out, rt_out : signed(0 to 63);
begin
    CoreRegistersInstance : entity work.CoreRegisters port map (
        clk => clk, 
        opcode => opcode,
        upper_imm => upper_imm,
        ra => ra,
        lv => lv,
        rs_sel => rs_sel,
        rt_sel => rt_sel,
        rd_sel => rd_sel,
        rd_in => rd_in,
        rs_out => rs_out,
        rt_out => rt_out
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

    CoreRegistersTestBench : process
    begin
        -- load and read unique value to register
        opcode <= OP; -- relevant opcode
        rd_in <= "1111000011110000111100001111000011110000111100001111000011110000";
        rd_sel <= "10010";
        rs_sel <= "10010";
        rt_sel <= "10011";
        wait for CLOCK_PERIOD;
        rd_in <= "0000000000000000000000000000000000000000000000000000000000000000";
        rd_sel <= "10011";
        wait for 2 * CLOCK_PERIOD;
        assert (rs_out = "1111000011110000111100001111000011110000111100001111000011110000") report "testbench failed for CoreRegisters case 1" severity error; 
        assert (rt_out = "0000000000000000000000000000000000000000000000000000000000000000") report "testbench failed for CoreRegisters case 2" severity error; 
        wait for CLOCK_PERIOD;
        assert (rs_out = "1111000011110000111100001111000011110000111100001111000011110000") report "testbench failed for CoreRegisters case 3" severity error; 
        assert (rt_out = "0000000000000000000000000000000000000000000000000000000000000000") report "testbench failed for CoreRegisters case 4" severity error; 
        -- load and read unique values to registers
        rd_sel <= "11111";
        rd_in <= "0000000000000000000000000000000000000000000000000000000000000001";
        wait for CLOCK_PERIOD;
        rd_sel <= "11110";
        rd_in <= "0000000000000000000000000000000000000000000000000000000000000010";
        wait for CLOCK_PERIOD;
        rd_sel <= "11101";
        rd_in <= "0000000000000000000000000000000000000000000000000000000000000011";
        wait for CLOCK_PERIOD;
        rd_sel <= "11100";
        rd_in <= "0000000000000000000000000000000000000000000000000000000000000100";
        wait for CLOCK_PERIOD; 
        opcode <= STORE; -- irrelevant opcode
        rs_sel <= "11111";
        rt_sel <= "11110";
        wait for CLOCK_PERIOD;
        assert (rs_out = "0000000000000000000000000000000000000000000000000000000000000001") report "testbench failed for CoreRegisters case 5" severity error; 
        assert (rt_out = "0000000000000000000000000000000000000000000000000000000000000010") report "testbench failed for CoreRegisters case 6" severity error;
        rs_sel <= "11101";
        rt_sel <= "11100";
        wait for CLOCK_PERIOD;
        assert (rs_out = "0000000000000000000000000000000000000000000000000000000000000011") report "testbench failed for CoreRegisters case 7" severity error; 
        assert (rt_out = "0000000000000000000000000000000000000000000000000000000000000100") report "testbench failed for CoreRegisters case 8" severity error; 
        -- check that state is stored across time
        wait for 10 * CLOCK_PERIOD;
        assert (rs_out = "0000000000000000000000000000000000000000000000000000000000000011") report "testbench failed for CoreRegisters case 9" severity error; 
        assert (rt_out = "0000000000000000000000000000000000000000000000000000000000000100") report "testbench failed for CoreRegisters case 10" severity error; 
        -- check that load fails if load bit not set
        opcode <= OP; -- irrelevant opcode
        rd_sel <= "00001";
        rs_sel <= "00001";
        rd_in <= "0000000000000000000000000000000000000000000000000000000000000000";
        wait for CLOCK_PERIOD;
        opcode <= STORE; -- irrelevant opcode
        rd_in <= "1111111111111111111111111111111111111111111111111111111111111111";
        wait for CLOCK_PERIOD;
        assert (rs_out = "0000000000000000000000000000000000000000000000000000000000000000") report "testbench failed for CoreRegisters case 11" severity error; 
        -- check that hard-coded zero cannot be written to
        rd_sel <= "00000";
        opcode <= OP;
        rd_in <= "1111111111111111111111111111111111111111111111111111111111111111";
        wait for CLOCK_PERIOD;
        assert (rs_out = "0000000000000000000000000000000000000000000000000000000000000000") report "testbench failed for CoreRegisters case 12" severity error; 
        -- test lui
        opcode <= LUI;
        upper_imm <= "1111111111111111111111111111111111101001001110110011000000000000";
        rs_sel <= "00010";
        rd_sel <= "00010";
        wait for CLOCK_PERIOD;
        assert (rs_out = "1111111111111111111111111111111111101001001110110011000000000000") report "testbench failed for CoreRegisters case 13" severity error;
        upper_imm <= "0000000000000000000000000000000001101001001110110011000000000000";
        rd_sel <= "00010";
        wait for CLOCK_PERIOD;
        assert (rs_out = "0000000000000000000000000000000001101001001110110011000000000000") report "testbench failed for CoreRegisters case 14" severity error;
        wait;
    end process;
end CoreRegistersTBLogic;