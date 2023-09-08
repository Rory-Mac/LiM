library ieee;
use ieee.std_logic_1164.all;

entity Demux16TB is
end Demux16TB;

architecture Demux16TBLogic of Demux16TB is
    signal A : std_logic;
    signal Sel : std_logic_vector(0 to 3);
    signal X : std_logic_vector(0 to 15);

begin
    Demux16Instance : entity work.Demux16 port map (A => A, Sel => Sel, X => X);

    TestBenchProcess : process
    constant waitPeriod : time := 1 ps;
    begin
        A <= '1';
        Sel <= "0000";
        wait for waitPeriod;
        assert (X = "1000000000000000")
        report "test failed for 16-bit demux case 1" severity error;

        A <= '1';
        Sel <= "1011";
        wait for waitPeriod;
        assert (X = "0000000000010000")
        report "test failed for 16-bit demux case 2" severity error;

        A <= '1';
        Sel <= "1111";
        wait for waitPeriod;
        assert (X = "0000000000000001")
        report "test failed for 16-bit demux case 3" severity error;

        A <= '0';
        Sel <= "1111";
        wait for waitPeriod;
        assert (X = "0000000000000000")
        report "test failed for 16-bit demux case 4" severity error;

        wait;
    end process;

end Demux16TBLogic;
