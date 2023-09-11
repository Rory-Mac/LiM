library ieee;
use ieee.std_logic_1164.all;

entity Reg32ResetTB is
end Reg32ResetTB;

architecture Reg32ResetTBLogic of Reg32ResetTB is
    constant CLOCK_PERIOD : time := 2 ps;
    constant SIMULATION_LENGTH : time := 1000 ps;
    signal clk, l, r: std_logic;
    signal d, q: std_logic_vector (0 to 31);
begin
    Reg32ResetInstance : entity work.Reg32Reset port map (clk => clk, d => d, l => l, r => r, q => q); 

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

    Reg32ResetTestBench : process
    begin
        d <= "00000000000000000000000000000000";
        l <= '0';
        wait for CLOCK_PERIOD;
        assert (q = "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU") report "testbench failed for Reg32Reset case 1" severity error;

        d <= "00000000000000000000000000000000";
        l <= '1';
        wait for CLOCK_PERIOD;
        assert (q = "00000000000000000000000000000000") report "testbench failed for Reg32Reset case 2" severity error;

        d <= "11111111111111111111111111111111";
        l <= '0';
        wait for CLOCK_PERIOD;
        assert (q = "00000000000000000000000000000000") report "testbench failed for Reg32Reset case 3" severity error;
        wait for 10 * CLOCK_PERIOD;
        assert (q = "00000000000000000000000000000000") report "testbench failed for Reg32Reset case 4" severity error;

        d <= "11111111111111111111111111111111";
        l <= '1';
        wait for CLOCK_PERIOD;
        assert (q = "11111111111111111111111111111111") report "testbench failed for Reg32Reset case 5" severity error;
        wait for 10 * CLOCK_PERIOD;
        assert (q = "11111111111111111111111111111111") report "testbench failed for Reg32Reset case 6" severity error;

        r <= '1';
        wait for CLOCK_PERIOD;
        assert (q = "00000000000000000000000000000000") report "testbench failed for Reg32Reset case 7" severity error;
        wait for 10 * CLOCK_PERIOD;
        assert (q = "00000000000000000000000000000000") report "testbench failed for Reg32Reset case 8" severity error;

        r <= '0';
        wait for CLOCK_PERIOD;
        assert (q = "11111111111111111111111111111111") report "testbench failed for Reg32Reset case 9" severity error;
        
        wait;
    end process;

end architecture;