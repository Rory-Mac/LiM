library ieee;
use ieee.std_logic_1164.all;

entity Mux8TB is 
end Mux8TB;

architecture Mux8TBBehaviour of Mux8TB is
    signal A : std_logic_vector (0 to 7);
    signal Sel : std_logic_vector (0 to 2);
    signal X : std_logic;
begin
    Mux8Instance : entity work.Mux8 port map (A => A, Sel => Sel, X => X);

    TestBenchProcess : process
    constant waitPeriod : time := 1 ps;
    begin
        A <= "11010100";
        Sel <= "000";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 1" severity error;
        
        Sel <= "001";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 2" severity error;
        
        Sel <= "010";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 3" severity error;

        Sel <= "011";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 4" severity error;
        
        Sel <= "100";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 5" severity error;
        
        Sel <= "101";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 6" severity error;
        
        Sel <= "110";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 7" severity error;

        Sel <= "111";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 8" severity error;

        wait;
    end process;
end Mux8TBBehaviour;