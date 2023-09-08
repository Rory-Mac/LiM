library ieee;
use ieee.std_logic_1164.all;

entity Demux32TB is
end Demux32TB;

architecture Demux32TBLogic of Demux32TB is
    signal A : std_logic;
    signal Sel : std_logic_vector(0 to 4);
    signal X : std_logic_vector(0 to 31);

begin
    Demux32Instance : entity work.Demux32 port map (A => A, Sel => Sel, X => X);

    TestBenchProcess : process
    constant waitPeriod : time := 1 ps;
    begin
        A <= '1';
        Sel <= "00000";
        wait for waitPeriod;
        assert (X = "10000000000000000000000000000000")
        report "test failed for 32-bit demux case 1" severity error;

        A <= '1';
        Sel <= "10111";
        wait for waitPeriod;
        assert (X = "00000000000000000000000100000000")
        report "test failed for 32-bit demux case 2" severity error;

        A <= '1';
        Sel <= "11111";
        wait for waitPeriod;
        assert (X = "00000000000000000000000000000001")
        report "test failed for 32-bit demux case 3" severity error;

        A <= '0';
        Sel <= "1111";
        wait for waitPeriod;
        assert (X = "00000000000000000000000000000000")
        report "test failed for 32-bit demux case 4" severity error;

        wait;
    end process;

end Demux32TBLogic;
