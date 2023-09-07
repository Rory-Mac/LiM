library ieee;
use ieee.std_logic_1164.all;

entity Mux2TB is 
end Mux2TB;

architecture Mux2TBBehaviour of Mux2TB is
    signal A, B, Sel, X: std_logic;
begin
    Mux2Instance : entity work.Mux2 port map (A => A, B => B, Sel => Sel, X => X);

    TestBenchProcess : process
    constant waitPeriod : time := 1 ns;
    begin
        A <= '1';
        B <= '0';
        Sel <= '0';
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 2-bit multiplexor case 1" severity error;

        Sel <= '1';
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 2-bit multiplexor case 2" severity error;

        wait;
    end process;
end Mux2TBBehaviour;