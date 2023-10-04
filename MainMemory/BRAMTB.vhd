library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xil_defaultlib;
use xil_defaultlib.ISAListings.all;

entity BRAMTB is
end BRAMTB;

architecture BRAMTBLogic of BRAMTB is
    constant CLOCK_PERIOD : time := 2 ns;
    constant SIMULATION_LENGTH : time := 1000 ns;
    signal clk, w_data, w_instr : std_logic;
    signal opcode : std_logic_vector(0 to 6);
    signal funct3 : std_logic_vector(0 to 2);
    signal data_addr, instr_addr : std_logic_vector(15 downto 0);
    signal data_in, instr_in, instr_out : std_logic_vector(63 downto 0); 
    signal data_out : signed(63 downto 0);
begin
    BRAMinstance : entity work.BRAM_Access_wrapper port map (
        clk => clk,
        funct3 => funct3,
        opcode => opcode,
        data_addr(15 downto 0) => data_addr(15 downto 0),
        data_in(63 downto 0) => data_in(63 downto 0),
        data_out(63 downto 0) => data_out(63 downto 0),
        instr_addr(15 downto 0) => instr_addr(15 downto 0),
        instr_in(63 downto 0) => instr_in(63 downto 0),
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

    BRAMTestBench : process
    begin
        -- store byte
        opcode <= STORE;
        funct3 <= S_SB;
        data_in <= "1111111111111111111111111111111111111111111111111111111101010101";
        data_addr <= "0000100000000000";
        wait for CLOCK_PERIOD;
        assert data_out = "0000000000000000000000000000000000000000000000000000000001010101" report "testbench failed for BRAM case 26" severity error;
        data_in <= "0000000000000000000000000000000000000000000000000000000010101010";
        wait for CLOCK_PERIOD;
        assert data_out = "1111111111111111111111111111111111111111111111111111111110101010" report "testbench failed for BRAM case 27" severity error;
        -- load byte
        opcode <= LOAD;
        funct3 <= I_LB;
        wait for CLOCK_PERIOD;
        assert load_value <= "1111111111111111111111111111111111111111111111111111111110101010";
        -- load byte unsigned
        funct3 <= I_LBU;
        wait for CLOCK_PERIOD;
        assert load_value <= "0000000000000000000000000000000000000000000000000000000010101010";
        -- store halfword
        opcode <= STORE;
        funct3 <= S_SH;
        data_in <= "1111111111111111111111111111111111111111111111110101010101010101";
        data_addr <= "0000100000000001";
        wait for CLOCK_PERIOD;
        assert data_out = "0000000000000000000000000000000000000000000000000101010101010101" report "testbench failed for BRAM case 28" severity error;
        data_in <= "0000000000000000000000000000000000000000000000001010101010101010";
        wait for CLOCK_PERIOD;
        assert data_out = "1111111111111111111111111111111111111111111111111010101010101010" report "testbench failed for BRAM case 29" severity error;
        -- load halfword
        opcode <= LOAD;
        funct3 <= I_LH;
        wait for CLOCK_PERIOD;
        assert load_value <= "1111111111111111111111111111111111111111111111111010101010101010";
        -- load halfword unsigned
        funct3 <= I_LHU;
        wait for CLOCK_PERIOD;
        assert load_value <= "0000000000000000000000000000000000000000000000001010101010101010";
        -- store word
        opcode <= STORE;
        funct3 <= S_SW;
        data_in <= "1111111111111111111111111111111101010101010101010101010101010101";
        data_addr <= "0000100000000010";
        wait for CLOCK_PERIOD;
        assert data_out = "0000000000000000000000000000000001010101010101010101010101010101" report "testbench failed for BRAM case 30" severity error;
        data_in <= "0000000000000000000000000000000010101010101010101010101010101010";
        wait for CLOCK_PERIOD;
        assert data_out = "1111111111111111111111111111111110101010101010101010101010101010" report "testbench failed for BRAM case 31" severity error;
        -- load word
        opcode <= LOAD;
        funct3 <= I_LW;
        wait for CLOCK_PERIOD;
        assert load_value <= "1111111111111111111111111111111110101010101010101010101010101010";
        -- load word unsigned
        funct3 <= I_LWU;
        wait for CLOCK_PERIOD;
        assert load_value <= "0000000000000000000000000000000010101010101010101010101010101010";
        -- store double
        opcode <= STORE;
        funct3 <= S_SD;
        data_in <= "0101010101010101010101010101010101010101010101010101010101010101";
        data_addr <= "0000100000000011";
        wait for CLOCK_PERIOD;
        assert data_out = "0101010101010101010101010101010101010101010101010101010101010101" report "testbench failed for BRAM case 32" severity error;
    end process;
end BRAMTBLogic;