library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CoreRegistersTB is
end CoreRegistersTB;

architecture CoreRegistersTBLogic of CoreRegistersTB is
    constant CLOCK_PERIOD : time := 2 ps;
    constant SIMULATION_LENGTH : time := 1000 ps;
    signal clk, load : std_logic;
    signal rs1sel, rs2sel, rdsel : std_logic_vector(0 to 4);
    signal data_in, data_out1, data_out2 : std_logic_vector(0 to 63);
begin
    CoreRegistersInstance : entity work.CoreRegisters port map (
        clk => clk, 
        load => load,
        rs1sel => rs1sel,
        rs2sel => rs2sel,
        rdsel => rdsel,
        data_in => data_in,
        data_out1 => data_out1,
        data_out2 => data_out2
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
        -- check that registers are uninitialised
        load <= '0';
        data_in <= "0000000000000000000000000000000000000000000000000000000000000000";
        for i in 0 to 31 loop
            rs1sel <= std_logic_vector(to_unsigned(i, 5));
            wait for CLOCK_PERIOD;
            assert (data_out1 = "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU") report "testbench failed for CoreRegisters case 1" severity error;
        end loop;
        for i in 0 to 31 loop
            rs2sel <= std_logic_vector(to_unsigned(i,5));
            assert (data_out2 = "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU") report "testbench failed for CoreRegisters case 2" severity error;
        end loop;
        -- initialise registers to zero 
        load <= '1';
        for i in 0 to 31 loop
            rdsel <= std_logic_vector(to_unsigned(i, 5));
            wait for CLOCK_PERIOD;
        end loop;
        -- check that registers are initialised to zero
        load <= '0';
        for i in 0 to 31 loop
            rs1sel <= std_logic_vector(to_unsigned(i, 5));
            wait for CLOCK_PERIOD;
            assert (data_out1 = "0000000000000000000000000000000000000000000000000000000000000000") report "testbench failed for CoreRegisters case 3" severity error; 
        end loop;
        for i in 0 to 31 loop
            rs2sel <= std_logic_vector(to_unsigned(i, 5));
            wait for CLOCK_PERIOD;
            assert (data_out2 = "0000000000000000000000000000000000000000000000000000000000000000") report "testbench failed for CoreRegisters case 4" severity error; 
        end loop;
        -- load and read unique value to register
        load <= '1';
        data_in <= "1111000011110000111100001111000011110000111100001111000011110000";
        rdsel <= "10010";
        rs1sel <= "10010";
        rs2sel <= "10011";
        wait for CLOCK_PERIOD;
        assert (data_out1 = "0000000000000000000000000000000000000000000000000000000000000000") report "testbench failed for CoreRegisters case 5" severity error; 
        assert (data_out2 = "0000000000000000000000000000000000000000000000000000000000000000") report "testbench failed for CoreRegisters case 6" severity error; 
        wait for CLOCK_PERIOD;
        assert (data_out1 = "1111000011110000111100001111000011110000111100001111000011110000") report "testbench failed for CoreRegisters case 7" severity error; 
        assert (data_out2 = "0000000000000000000000000000000000000000000000000000000000000000") report "testbench failed for CoreRegisters case 8" severity error; 
        -- load and read unique values to registers
        rdsel <= "11111";
        data_in <= "0000000000000000000000000000000000000000000000000000000000000001";
        wait for CLOCK_PERIOD;
        rdsel <= "11110";
        data_in <= "0000000000000000000000000000000000000000000000000000000000000010";
        wait for CLOCK_PERIOD;
        rdsel <= "11101";
        data_in <= "0000000000000000000000000000000000000000000000000000000000000011";
        wait for CLOCK_PERIOD;
        rdsel <= "11100";
        data_in <= "0000000000000000000000000000000000000000000000000000000000000100";
        wait for CLOCK_PERIOD; 
        load <= '0';
        rs1sel <= "11111";
        rs2sel <= "11110";
        wait for CLOCK_PERIOD;
        assert (data_out1 = "0000000000000000000000000000000000000000000000000000000000000001") report "testbench failed for CoreRegisters case 9" severity error; 
        assert (data_out2 = "0000000000000000000000000000000000000000000000000000000000000010") report "testbench failed for CoreRegisters case 10" severity error;
        rs1sel <= "11101";
        rs2sel <= "11100";
        wait for CLOCK_PERIOD;
        assert (data_out1 = "0000000000000000000000000000000000000000000000000000000000000011") report "testbench failed for CoreRegisters case 11" severity error; 
        assert (data_out2 = "0000000000000000000000000000000000000000000000000000000000000100") report "testbench failed for CoreRegisters case 12" severity error; 
        -- check that state is stored across time
        wait for 10 * CLOCK_PERIOD;
        assert (data_out1 = "0000000000000000000000000000000000000000000000000000000000000011") report "testbench failed for CoreRegisters case 13" severity error; 
        assert (data_out2 = "0000000000000000000000000000000000000000000000000000000000000100") report "testbench failed for CoreRegisters case 14" severity error; 
        -- check that load fails if load bit not set
        load <= '0';
        rdsel <= "00000";
        rs1sel <= "00000";
        data_in <= "1111111111111111111111111111111111111111111111111111111111111111";
        wait for CLOCK_PERIOD;
        assert (data_out1 = "0000000000000000000000000000000000000000000000000000000000000000") report "testbench failed for CoreRegisters case 15" severity error; 
        wait;
    end process;
end CoreRegistersTBLogic;