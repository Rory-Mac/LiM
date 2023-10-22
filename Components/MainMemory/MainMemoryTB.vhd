library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xil_defaultlib;
use xil_defaultlib.ISAListings.all;

entity MainMemoryTB is
end MainMemoryTB;

architecture MainMemoryTBLogic of MainMemoryTB is
    constant CLOCK_PERIOD : time := 2 ns;
    constant SIMULATION_LENGTH : time := 1000 ns;
    signal clk, w_data, w_instr : std_logic;
    signal opcode : std_logic_vector(0 to 6);
    signal funct3 : std_logic_vector(0 to 2);
    signal LS_offset : signed(0 to 11);
    signal LS_addr : std_logic_vector(63 downto 0);
    signal instr_addr : std_logic_vector(15 downto 0);
    signal data_in, instr_in, instr_out : std_logic_vector(63 downto 0); 
    signal data_out : signed(63 downto 0);
begin
    MainMemory_instance : entity work.MainMemory_wrapper port map (
        clk => clk,
        opcode => opcode,
        funct3 => funct3,
        LS_offset => LS_offset,
        LS_addr(63 downto 0) => LS_addr(63 downto 0),
        instr_addr(15 downto 0) => instr_addr(15 downto 0),
        data_in(63 downto 0) => data_in(63 downto 0),
        data_out(63 downto 0) => data_out(63 downto 0),
        instr_out(63 downto 0) => instr_out(63 downto 0)
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

    MainMemoryTestBench : process
    begin
        -- store byte
        opcode <= STORE;
        funct3 <= S_SB;
        data_in <= "1111111111111111111111111111111111111111111111111111111101010101";
        LS_addr <= "0000000000000000000000000000000000000000000000000000100000000000";
        LS_offset <= "000000000000";
        wait for CLOCK_PERIOD;
        assert data_out = "0000000000000000000000000000000000000000000000000000000001010101" report "testbench failed for MainMemory case 1" severity error;
        data_in <= "0000000000000000000000000000000000000000000000000000000010101010";
        wait for CLOCK_PERIOD;
        assert data_out = "1111111111111111111111111111111111111111111111111111111110101010" report "testbench failed for MainMemory case 2" severity error;
        -- load byte
        opcode <= LOAD;
        funct3 <= I_LB;
        wait for CLOCK_PERIOD;
        assert data_out <= "1111111111111111111111111111111111111111111111111111111110101010";
        -- load byte unsigned
        funct3 <= I_LBU;
        wait for CLOCK_PERIOD;
        assert data_out <= "0000000000000000000000000000000000000000000000000000000010101010";
        -- store halfword
        opcode <= STORE;
        funct3 <= S_SH;
        data_in <= "1111111111111111111111111111111111111111111111110101010101010101";
        LS_addr <= "0000000000000000000000000000000000000000000000000000100000000001";
        wait for CLOCK_PERIOD;
        assert data_out = "0000000000000000000000000000000000000000000000000101010101010101" report "testbench failed for MainMemory case 3" severity error;
        data_in <= "0000000000000000000000000000000000000000000000001010101010101010";
        wait for CLOCK_PERIOD;
        assert data_out = "1111111111111111111111111111111111111111111111111010101010101010" report "testbench failed for MainMemory case 4" severity error;
        -- load halfword
        opcode <= LOAD;
        funct3 <= I_LH;
        wait for CLOCK_PERIOD;
        assert data_out <= "1111111111111111111111111111111111111111111111111010101010101010";
        -- load halfword unsigned
        funct3 <= I_LHU;
        wait for CLOCK_PERIOD;
        assert data_out <= "0000000000000000000000000000000000000000000000001010101010101010";
        -- store word
        opcode <= STORE;
        funct3 <= S_SW;
        data_in <= "1111111111111111111111111111111101010101010101010101010101010101";
        LS_addr <= "0000000000000000000000000000000000000000000000000000100000000010";
        wait for CLOCK_PERIOD;
        assert data_out = "0000000000000000000000000000000001010101010101010101010101010101" report "testbench failed for MainMemory case 5" severity error;
        data_in <= "0000000000000000000000000000000010101010101010101010101010101010";
        wait for CLOCK_PERIOD;
        assert data_out = "1111111111111111111111111111111110101010101010101010101010101010" report "testbench failed for MainMemory case 6" severity error;
        -- load word
        opcode <= LOAD;
        funct3 <= I_LW;
        wait for CLOCK_PERIOD;
        assert data_out <= "1111111111111111111111111111111110101010101010101010101010101010";
        -- load word unsigned
        funct3 <= I_LWU;
        wait for CLOCK_PERIOD;
        assert data_out <= "0000000000000000000000000000000010101010101010101010101010101010";
        -- store double
        opcode <= STORE;
        funct3 <= S_SD;
        data_in <= "0101010101010101010101010101010101010101010101010101010101010101";
        LS_addr <= "0000000000000000000000000000000000000000000000000000100000000011";
        wait for CLOCK_PERIOD;
        assert data_out = "0101010101010101010101010101010101010101010101010101010101010101" report "testbench failed for MainMemory case 7" severity error;
        -- store with offset
        opcode <= STORE;
        funct3 <= S_SW;
        data_in <= "0000000000000000111111111111111100000000000000001111111111111111";
        LS_addr <= "0000000000000000000000000000000000000000000000001000000000000000";
        LS_offset <= "000010000000";
        wait for CLOCK_PERIOD;
        assert data_out = "0000000000000000000000000000000000000000000000001111111111111111" report "testbench failed for MainMemory case 8" severity error;
        -- load with offset + state preservation across clock cycles
        opcode <= OP; -- opcode non-activating to MainMemory component
        wait for 10 * CLOCK_PERIOD;
        opcode <= LOAD;
        funct3 <= I_LW;
        LS_addr <= "0000000000000000000000000000000000000000000000001000000000000000";
        LS_offset <= "000010000000";
        wait for CLOCK_PERIOD;
        assert data_out = "0000000000000000000000000000000000000000000000001111111111111111" report "testbench failed for MainMemory case 9" severity error;
        wait;
    end process;
end architecture;