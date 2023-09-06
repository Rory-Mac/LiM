library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FullAdderTestBench is
end FullAdderTestBench;

architecture FullAdderTestBenchBehaviour of FullAdderTestBench is
    signal A: std_logic;
    signal B: std_logic;
    signal Cin: std_logic;
    signal Cout: std_logic;
    signal S: std_logic;
begin
    FAinstance : entity work.FullAdder port map (A => A, B => B, Cin => Cin, S => S, Cout => Cout);
    TestBenchProcess : process
    constant waitPeriod: time := 1 ps;
    begin
        A <= '0';
        B <= '0';
        Cin <= '0';
        wait for waitPeriod;
        assert (S = '0' and Cout = '0')
        report "test failed for full-adder 000 input case" severity error;

        A <= '0';
        B <= '0';
        Cin <= '1';
        wait for waitPeriod;
        assert (S = '1' and Cout = '0')
        report "test failed for full-adder 001 input case" severity error;

        A <= '0';
        B <= '1';
        Cin <= '0';
        wait for waitPeriod;
        assert (S = '1' and Cout = '0')
        report "test failed for full-adder 010 input case" severity error;

        A <= '0';
        B <= '1';
        Cin <= '1';
        wait for waitPeriod;
        assert (S = '0' and Cout = '1')
        report "test failed for full-adder 011 input case" severity error;

        A <= '1';
        B <= '0';
        Cin <= '0';
        wait for waitPeriod;
        assert (S = '1' and Cout = '0')
        report "test failed for full-adder 100 input case" severity error;

        A <= '1';
        B <= '0';
        Cin <= '1';
        wait for waitPeriod;
        assert (S = '0' and Cout = '1')
        report "test failed for full-adder 101 input case" severity error;

        A <= '1';
        B <= '1';
        Cin <= '0';
        wait for waitPeriod;
        assert (S = '0' and Cout = '1')
        report "test failed for full-adder 110 input case" severity error;

        A <= '1';
        B <= '1';
        Cin <= '1';
        wait for waitPeriod;
        assert (S = '1' and Cout = '1')
        report "test failed for full-adder 111 input case" severity error;

        wait;
    end process;

end FullAdderTestBenchBehaviour;
