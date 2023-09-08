library ieee;
use ieee.std_logic_1164.all;

entity Demux4TB is
end Demux4TB;

architecture Demux4TBLogic of Demux4TB is
    signal A : std_logic;
    signal Sel : std_logic_vector(0 to 1);
    signal X : std_logic_vector(0 to 3);

begin
    Demux4Instance : entity work.Demux4 port map (A => A, Sel => Sel, X => X);

    TestBenchProcess : process
    constant waitPeriod : time := 1 ps;
    begin
        A <= '1';
        Sel <= "00";
        wait for waitPeriod;
        assert (X = "1000")
        report "test failed for 4-bit demux case 1" severity error;

        A <= '1';
        Sel <= "01";
        wait for waitPeriod;
        assert (X = "0100")
        report "test failed for 4-bit demux case 2" severity error;

        A <= '1';
        Sel <= "10";
        wait for waitPeriod;
        assert (X = "0010")
        report "test failed for 4-bit demux case 3" severity error;

        A <= '1';
        Sel <= "11";
        wait for waitPeriod;
        assert (X = "0001")
        report "test failed for 4-bit demux case 4" severity error;

        A <= '0';
        Sel <= "00";
        wait for waitPeriod;
        assert (X = "0000")
        report "test failed for 4-bit demux case 5" severity error;

        wait;
    end process;

end Demux4TBLogic;
