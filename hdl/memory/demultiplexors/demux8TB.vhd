library ieee;
use ieee.std_logic_1164.all;

entity Demux8TB is
end Demux8TB;

architecture Demux8TBLogic of Demux8TB is
    signal A : std_logic;
    signal Sel : std_logic_vector(0 to 2);
    signal X : std_logic_vector(0 to 7);

begin
    Demux8Instance : entity work.Demux8 port map (A => A, Sel => Sel, X => X);

    TestBenchProcess : process
    constant waitPeriod : time := 1 ps;
    begin
        A <= '1';
        Sel <= "000";
        wait for waitPeriod;
        assert (X = "10000000")
        report "test failed for 8-bit demux case 1" severity error;

        A <= '1';
        Sel <= "110";
        wait for waitPeriod;
        assert (X = "00000010")
        report "test failed for 8-bit demux case 2" severity error;

        A <= '0';
        Sel <= "111";
        wait for waitPeriod;
        assert (X = "00000000")
        report "test failed for 8-bit demux case 3" severity error;

        wait;
    end process;

end Demux8TBLogic;
