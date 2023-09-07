library ieee;
use ieee.std_logic_1164.all;

entity Mux16TB is 
end Mux16TB;

architecture Mux16TBBehaviour of Mux16TB is
    signal A : std_logic_vector (0 to 15);
    signal Sel : std_logic_vector (0 to 3);
    signal X : std_logic;
begin
    Mux16Instance : entity work.Mux16 port map (A => A, Sel => Sel, X => X);

    TestBenchProcess : process
    constant waitPeriod : time := 1 ps;
    begin
        A <= "1101010011010100";
        Sel <= "0000";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 1" severity error;
        
        Sel <= "0001";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 2" severity error;
        
        Sel <= "0010";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 3" severity error;

        Sel <= "0011";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 4" severity error;
        
        Sel <= "0100";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 5" severity error;
        
        Sel <= "0101";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 6" severity error;
        
        Sel <= "0110";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 7" severity error;

        Sel <= "0111";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 8" severity error;

        Sel <= "1000";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 9" severity error;
        
        Sel <= "1001";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 10" severity error;
        
        Sel <= "1010";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 11" severity error;

        Sel <= "1011";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 12" severity error;
        
        Sel <= "1100";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 13" severity error;
        
        Sel <= "1101";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 14" severity error;
        
        Sel <= "1110";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 15" severity error;

        Sel <= "1111";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 16" severity error;

        wait;
    end process;
end Mux16TBBehaviour;