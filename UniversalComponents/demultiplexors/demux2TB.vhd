library ieee;
use ieee.std_logic_1164.all;

entity Demux2TB is
end Demux2TB;

architecture Demux2TBLogic of Demux2TB is
    signal A, Sel : std_logic;
    signal X : std_logic_vector(0 to 1);
begin
    Demux2Instance : entity work.Demux2 port map (A => A, Sel => Sel, X1 => X(0), X2=> X(1));

    TestBenchProcess : process
    constant waitPeriod : time := 1 ps;
    begin
        A <= '0';
        Sel <= '0';
        wait for waitPeriod;
        assert (X = "00")
        report "test failed for 2-bit demux case 1" severity error;

        A <= '0';
        Sel <= '1';
        wait for waitPeriod;
        assert (X = "00")
        report "test failed for 2-bit demux case 2" severity error;
        wait;

        A <= '1';
        Sel <= '0';
        wait for waitPeriod;
        assert (X = "10")
        report "test failed for 2-bit demux case 3" severity error;

        A <= '1';
        Sel <= '1';
        wait for waitPeriod;
        assert (X = "01")
        report "test failed for 2-bit demux case 4" severity error;

        wait;
    end process;

end Demux2TBLogic;
