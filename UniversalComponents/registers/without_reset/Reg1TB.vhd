library ieee;
use ieee.std_logic_1164.all;

entity Reg1TB is
end Reg1TB;

architecture Reg1TBLogic of Reg1TB is
    constant CLOCK_PERIOD : time := 2 ps;
    constant SIMULATION_LENGTH : time := 1000 ps;
    signal clk, d, l, q: std_logic;
begin
    Reg1instance : entity work.Reg1 port map (clk => clk, d => d, l => l, q => q); 

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

    Reg1TestBench : process
    begin
        d <= '0';
        l <= '0';
        wait for CLOCK_PERIOD;
        assert (q = 'U') report "testbench failed for Reg1 case 1" severity error;

        d <= '0';
        l <= '1';
        wait for CLOCK_PERIOD;
        assert (q = '0') report "testbench failed for Reg1 case 2" severity error;

        d <= '1';
        l <= '0';
        wait for CLOCK_PERIOD;
        assert (q = '0') report "testbench failed for Reg1 case 3" severity error;
        wait for 10 * CLOCK_PERIOD;
        assert (q = '0') report "testbench failed for Reg1 case 4" severity error;

        d <= '1';
        l <= '1';
        wait for CLOCK_PERIOD;
        assert (q = '1') report "testbench failed for Reg1 case 5" severity error;
        wait for 10 * CLOCK_PERIOD;
        assert (q = '1') report "testbench failed for Reg1 case 6" severity error;

        wait;
    end process;

end Reg1TBLogic;