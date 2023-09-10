library ieee;
use ieee.std_logic_1164.all;

entity DFFTB is
end DFFTB;

architecture DFFTBLogic of DFFTB is
    constant CLOCK_PERIOD : time := 2 ps;
    constant SIMULATION_LENGTH : time := 1000 ps;
    signal clk, d, q: std_logic;
begin
    DFFinstance : entity work.DFF port map (clk => clk, d => d, q => q); 

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
        wait for CLOCK_PERIOD;
        assert (q = '0') report "testbench failed for dff case 1" severity error;

        d <= '1';
        wait for CLOCK_PERIOD;
        assert (q = '1') report "testbench failed for dff case 2" severity error;

        d <= '0';
        wait for CLOCK_PERIOD;
        assert (q = '0') report "testbench failed for dff case 3" severity error;

        d <= '1';
        wait for CLOCK_PERIOD;
        assert (q = '1') report "testbench failed for dff case 4" severity error;

        d <= '0';
        wait for CLOCK_PERIOD;
        assert (q = '0') report "testbench failed for dff case 5" severity error;

        d <= '1';
        wait for CLOCK_PERIOD;
        assert (q = '1') report "testbench failed for dff case 6" severity error;

        d <= '0';
        wait for CLOCK_PERIOD;
        assert (q = '0') report "testbench failed for dff case 7" severity error;

        d <= '1';
        wait for CLOCK_PERIOD;
        assert (q = '1') report "testbench failed for dff case 8" severity error;
        wait for 10 ps;
        assert (q = '1') report "testbench failed for dff case 9" severity error;

        wait;
    end process;

end DFFTBLogic;