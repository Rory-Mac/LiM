library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PCTB is
end PCTB;

architecture PCTBLogic of PCTB is
    constant CLOCK_PERIOD : time := 2 ps;
    constant SIMULATION_LENGTH : time := 1000 ps;
    signal clk, load, inc, rst : std_logic;
    signal d_in, d_out : std_logic_vector(0 to 31);
begin
    PCInstance : entity work.PC port map (clk => clk, load => load, inc => inc, rst => rst, d_in => d_in, d_out => d_out);
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
        d_in <= "11111111111111111111111111111111";
        load <= '0';
        inc <= '0';
        rst <= '0';
        wait for CLOCK_PERIOD;
        assert (d_out = "00000000000000000000000000000000") report "testbench failed for program counter case 1" severity error;

        load <= '1';
        inc <= '1';
        wait for CLOCK_PERIOD;
        assert (d_out = "11111111111111111111111111111111") report "testbench failed for program counter case 2" severity error;

        d_in <= "00000000000000000000000000000000";
        wait for CLOCK_PERIOD;
        assert (d_out = "00000000000000000000000000000000") report "testbench failed for program counter case 3" severity error;

        load <= '0';
        wait for CLOCK_PERIOD;
        assert (d_out = "00000000000000000000000000000001") report "testbench failed for program counter case 4" severity error;
        wait for 31 * CLOCK_PERIOD;
        assert (d_out = "00000000000000000000000000100000") report "testbench failed for program counter case 5" severity error;

        rst <= '1';
        wait for CLOCK_PERIOD;
        assert (d_out = "00000000000000000000000000000000") report "testbench failed for program counter case 6" severity error;
        wait for 32 * CLOCK_PERIOD;
        assert (d_out = "00000000000000000000000000000000") report "testbench failed for program counter case 7" severity error;

        rst <= '0';
        wait for 32 * CLOCK_PERIOD;
        assert (d_out = "00000000000000000000000000100000") report "testbench failed for program counter case 8" severity error;
        wait;
    end process;

end architecture;