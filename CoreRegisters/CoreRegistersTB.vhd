library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CoreRegistersTB is
end CoreRegistersTB;

architecture CoreRegistersTBLogic of CoreRegistersTB is
    constant CLOCK_PERIOD : time := 2 ps;
    constant SIMULATION_LENGTH : time := 1000 ps;
    signal clk, load : std_logic;
    signal sel1, sel2 : std_logic_vector(0 to 4);
    signal data_in, data_out1, data_out2 : std_logic_vector(0 to 31);
begin
    CoreRegistersInstance : entity work.CoreRegisters port map (
        clk => clk, 
        load => load,
        sel1 => sel1,
        sel2 => sel2,
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
        load <= '0';
        data_in <= "00000000000000000000000000000000";
        sel2 <= "00000"; 
        for i in 0 to 31 loop
            sel1 <= std_logic_vector(to_unsigned(i, 5));
            wait for CLOCK_PERIOD;
            assert (data_out1 = "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU") report "testbench failed for CoreRegisters case 1" severity error;
            assert (data_out2 = "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU") report "testbench failed for CoreRegisters case 1" severity error;
        end loop;
        load <= '1';
        for i in 0 to 31 loop
            sel1 <= std_logic_vector(to_unsigned(i, 5));
            wait for CLOCK_PERIOD;
            assert (data_out1 = "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU") report "testbench failed for CoreRegisters case 2" severity error;
            wait for CLOCK_PERIOD;
            assert (data_out1 = "00000000000000000000000000000000") report "testbench failed for CoreRegisters case 2" severity error;
        end loop;
        for i in 0 to 31 loop
            data_in <= std_logic_vector(to_unsigned(i, 32));
            sel1 <= std_logic_vector(to_unsigned(i, 5));
            wait for CLOCK_PERIOD;
            assert (data_out1 = "00000000000000000000000000000000") report "testbench failed for CoreRegisters case 3" severity error;
            assert (data_out2 = "00000000000000000000000000000000") report "testbench failed for CoreRegisters case 3" severity error;
            wait for CLOCK_PERIOD;
            assert (data_out1 = std_logic_vector(to_unsigned(i, 32))) report "testbench failed for CoreRegisters case 2" severity error;
        end loop;
        load <= '0';
        for i in 0 to 31 loop
            sel1 <= std_logic_vector(to_unsigned(i, 5));
            wait for CLOCK_PERIOD;
            assert (data_out1 = std_logic_vector(to_unsigned(i, 32))) report "testbench failed for CoreRegisters case 4" severity error;
            assert (data_out2 = "00000000000000000000000000000000") report "testbench failed for CoreRegisters case 4" severity error;
        end loop;
        sel1 <= "01110";
        sel2 <= "11100";
        wait for CLOCK_PERIOD;
        assert data_out1 = "00000000000000000000000000001110" report "testbench failed for CoreRegisters case 5" severity error;
        assert data_out2 = "00000000000000000000000000011100" report "testbench failed for CoreRegisters case 5" severity error;
        
        sel1 <= "00010";
        sel2 <= "11111";
        wait for CLOCK_PERIOD;
        assert data_out1 = "00000000000000000000000000000010" report "testbench failed for CoreRegisters case 6" severity error;
        assert data_out2 = "00000000000000000000000000011111" report "testbench failed for CoreRegisters case 6" severity error;

        wait;
    end process;

end CoreRegistersTBLogic;