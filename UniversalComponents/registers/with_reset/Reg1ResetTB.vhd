library ieee;
use ieee.std_logic_1164.all;

entity Reg1ResetTB  is
end Reg1ResetTB;

architecture Reg1ResetTBLogic of Reg1ResetTB is
    constant CLOCK_PERIOD : time := 2 ps;
    constant SIMULATION_LENGTH : time := 1000 ps;
    signal clk, d, l, r, q: std_logic;
begin
    Reg1instance : entity work.Reg1Reset port map (clk => clk, d => d, l => l, r => r, q => q); 

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
        assert (q = 'U') report "testbench failed for Reg1 reset case 1" severity error;

        d <= '0';
        l <= '1';
        wait for CLOCK_PERIOD;
        assert (q = '0') report "testbench failed for Reg1 reset case 2" severity error;

        d <= '1';
        l <= '0';
        wait for CLOCK_PERIOD;
        assert (q = '0') report "testbench failed for Reg1 reset case 3" severity error;
        wait for 10 * CLOCK_PERIOD;
        assert (q = '0') report "testbench failed for Reg1 reset case 4" severity error;

        d <= '1';
        l <= '1';
        wait for CLOCK_PERIOD;
        assert (q = '1') report "testbench failed for Reg1 reset case 5" severity error;
        wait for 10 * CLOCK_PERIOD;
        assert (q = '1') report "testbench failed for Reg1 reset case 6" severity error;
        
        r <= '1';
        wait for CLOCK_PERIOD;
        assert (q = '0') report "testbench failed for Reg1 reset case 7" severity error;
        wait for 10 * CLOCK_PERIOD;
        assert (q = '0') report "testbench failed for Reg1 reset case 8" severity error;

        r <= '0';
        wait for CLOCK_PERIOD;
        assert (q = '1') report "testbench failed for Reg1 reset case 9" severity error;

        wait;
    end process;

end architecture;