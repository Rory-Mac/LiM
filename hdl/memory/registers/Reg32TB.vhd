library ieee;
use ieee.std_logic_1164.all;

entity Reg32TB is
end Reg32TB;

architecture Reg32TBLogic of Reg32TB is
    constant CLOCK_PERIOD : time := 2 ps;
    constant SIMULATION_LENGTH : time := 1000 ps;
    signal clk, l : std_logic;
    signal d, q: std_logic_vector (0 to 31);
begin
    Reg32instance : entity work.Reg32 port map (clk => clk, d => d, l => l, q => q); 

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

    Reg32TestBench : process
    begin
        d <= "00000000000000000000000000000000";
        l <= '0';
        wait for CLOCK_PERIOD;
        assert (q = "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU") report "testbench failed for Reg1 case 1" severity error;

        d <= "00000000000000000000000000000000";
        l <= '1';
        wait for CLOCK_PERIOD;
        assert (q = "00000000000000000000000000000000") report "testbench failed for Reg1 case 2" severity error;

        d <= "11111111111111111111111111111111";
        l <= '0';
        wait for CLOCK_PERIOD;
        assert (q = "00000000000000000000000000000000") report "testbench failed for Reg1 case 3" severity error;
        wait for 10 * CLOCK_PERIOD;
        assert (q = "00000000000000000000000000000000") report "testbench failed for Reg1 case 4" severity error;

        d <= "11111111111111111111111111111111";
        l <= '1';
        wait for CLOCK_PERIOD;
        assert (q = "11111111111111111111111111111111") report "testbench failed for Reg1 case 5" severity error;
        wait for 10 * CLOCK_PERIOD;
        assert (q = "11111111111111111111111111111111") report "testbench failed for Reg1 case 6" severity error;

        wait;
    end process;

end Reg32TBLogic;