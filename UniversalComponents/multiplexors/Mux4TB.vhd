library ieee;
use ieee.std_logic_1164.all;

entity Mux4TB is 
end Mux4TB;

architecture Mux4TBBehaviour of Mux4TB is
    signal A : std_logic_vector (0 to 3);
    signal Sel : std_logic_vector (0 to 1);
    signal X : std_logic;
begin
    Mux4Instance : entity work.Mux4 port map (A => A, Sel => Sel, X => X);

    TestBenchProcess : process
    constant waitPeriod : time := 1 ps;
    begin
        A <= "1010";
        Sel <= "00";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 4-bit multiplexor case 1" severity error;
        
        Sel <= "01";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 4-bit multiplexor case 2" severity error;
        
        Sel <= "10";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 4-bit multiplexor case 3" severity error;

        Sel <= "11";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 4-bit multiplexor case 4" severity error;
        
        A <= "0101";
        Sel <= "00";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 4-bit multiplexor case 5" severity error;
        
        Sel <= "01";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 4-bit multiplexor case 6" severity error;
        
        Sel <= "10";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 4-bit multiplexor case 7" severity error;

        Sel <= "11";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 4-bit multiplexor case 8" severity error;

        wait;
    end process;
end Mux4TBBehaviour;