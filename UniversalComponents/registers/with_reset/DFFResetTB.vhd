library ieee;
use ieee.std_logic_1164.all;

entity DFFResetTB is
end DFFResetTB;

architecture DFFResetTBLogic of DFFResetTB is
    constant CLOCK_PERIOD : time := 2 ps;
    constant SIMULATION_LENGTH : time := 1000 ps;
    signal clk, d, r, q: std_logic;
begin
    DFFinstance : entity work.DFFReset port map (clk => clk, d => d, r => r, q => q); 

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

    DFFTestBench : process
    begin
        d <= '0';
        r <= '0';
        wait for CLOCK_PERIOD;
        assert (q = '0') report "testbench failed for dff reset case 1" severity error;

        d <= '1';
        r <= '0';
        wait for CLOCK_PERIOD;
        assert (q = '1') report "testbench failed for dff reset case 2" severity error;

        d <= '0';
        r <= '0';
        wait for CLOCK_PERIOD;
        assert (q = '0') report "testbench failed for dff reset case 3" severity error;

        d <= '1';
        r <= '0';
        wait for CLOCK_PERIOD;
        assert (q = '1') report "testbench failed for dff reset case 4" severity error;

        d <= '0';
        r <= '0';
        wait for CLOCK_PERIOD;
        assert (q = '0') report "testbench failed for dff reset case 5" severity error;

        d <= '1';
        r <= '0';
        wait for CLOCK_PERIOD;
        assert (q = '1') report "testbench failed for dff reset case 6" severity error;

        d <= '0';
        r <= '0';
        wait for CLOCK_PERIOD;
        assert (q = '0') report "testbench failed for dff reset case 7" severity error;

        d <= '1';
        r <= '0';
        wait for CLOCK_PERIOD;
        assert (q = '1') report "testbench failed for dff reset case 8" severity error;
        wait for 10 ps;
        assert (q = '1') report "testbench failed for dff reset case 9" severity error;

        d <= '1';
        r <= '1';
        wait for CLOCK_PERIOD;
        assert (q = '0') report "testbench failed for dff reset case 10" severity error;
        r <= '0';
        wait for CLOCK_PERIOD;
        assert (q = '1') report "testbench failed for dff reset case 11" severity error;

        wait;
    end process;

end DFFResetTBLogic;