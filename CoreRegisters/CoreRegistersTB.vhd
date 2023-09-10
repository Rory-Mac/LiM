library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CoreRegistersTB is
end CoreRegistersTB;

architecture CoreRegistersTBLogic of CoreRegistersTB is
    constant CLOCK_PERIOD : time := 2 ps;
    constant SIMULATION_LENGTH : time := 1000 ps;
    signal clk, l : std_logic;
    signal sel : std_logic_vector(0 to 4);
    signal d, q : std_logic_vector(0 to 31);
begin
    CoreRegistersInstance : entity work.CoreRegisters port map (clk => clk, l => l, sel => sel, d => d, q => q);
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
        l <= '0';
        d <= "00000000000000000000000000000000";
        for i in 0 to 31 loop
            sel <= std_logic_vector(to_unsigned(i, 5));
            wait for CLOCK_PERIOD;
            assert (q = "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU") report "testbench failed for CoreRegisters case 1" severity error;
        end loop;
        l <= '1';
        for i in 0 to 31 loop
            sel <= std_logic_vector(to_unsigned(i, 5));
            wait for CLOCK_PERIOD;
            assert (q = "00000000000000000000000000000000") report "testbench failed for CoreRegisters case 2" severity error;
        end loop;
        for i in 0 to 31 loop
            d <= std_logic_vector(to_unsigned(i, 32));
            sel <= std_logic_vector(to_unsigned(i, 5));
            wait for CLOCK_PERIOD;
            assert (q = std_logic_vector(to_unsigned(i, 32))) report "testbench failed for CoreRegisters case 3" severity error;
        end loop;
        l <= '0';
        for i in 0 to 31 loop
            sel <= std_logic_vector(to_unsigned(i, 5));
            wait for CLOCK_PERIOD;
            assert (q = std_logic_vector(to_unsigned(i, 32))) report "testbench failed for CoreRegisters case 4" severity error;
        end loop;

        wait;
    end process;

end CoreRegistersTBLogic;