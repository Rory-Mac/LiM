library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IRTB is
end IRTB;

architecture IRTBLogic of IRTB is
    constant CLOCK_PERIOD : time := 2 ps;
    constant SIMULATION_LENGTH : time := 1000 ps;
    signal clk, load : std_logic;
    signal d_in, d_out : std_logic_vector(0 to 31);
begin
    IRinstance : entity work.IR port map (clk => clk, load => load, d_in => d_in, d_out => d_out);
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
        wait for CLOCK_PERIOD;
        assert (d_out = "00000000000000000000000000000000") report "testbench failed for instruction register case 1" severity error;

        load <= '1';
        wait for CLOCK_PERIOD;
        assert (d_out = "11111111111111111111111111111111") report "testbench failed for instruction register case 2" severity error;
        wait for 10 * CLOCK_PERIOD;
        assert (d_out = "11111111111111111111111111111111") report "testbench failed for instruction register case 3" severity error;

        wait;
    end process;

end architecture;