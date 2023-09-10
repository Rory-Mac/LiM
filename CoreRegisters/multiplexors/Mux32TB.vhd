library ieee;
use ieee.std_logic_1164.all;

entity Mux32TB is 
end Mux32TB;

architecture Mux32TBBehaviour of Mux32TB is
    signal A : std_logic_vector (0 to 31);
    signal Sel : std_logic_vector (0 to 4);
    signal X : std_logic;
begin
    Mux32Instance : entity work.Mux32 port map (A => A, Sel => Sel, X => X);

    TestBenchProcess : process
    constant waitPeriod : time := 1 ps;
    begin
        A <= "11101010010011001010100101011101";
        Sel <= "00000";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 1" severity error;
        
        Sel <= "00001";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 2" severity error;
        
        Sel <= "00010";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 3" severity error;

        Sel <= "00011";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 4" severity error;
        
        Sel <= "00100";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 5" severity error;
        
        Sel <= "00101";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 6" severity error;
        
        Sel <= "00110";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 7" severity error;

        Sel <= "00111";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 8" severity error;

        Sel <= "01000";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 9" severity error;
        
        Sel <= "01001";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 10" severity error;
        
        Sel <= "01010";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 11" severity error;

        Sel <= "01011";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 12" severity error;
        
        Sel <= "01100";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 13" severity error;
        
        Sel <= "01101";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 14" severity error;
        
        Sel <= "01110";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 15" severity error;

        Sel <= "01111";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 16" severity error;

        Sel <= "10000";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 17" severity error;
        
        Sel <= "10001";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 18" severity error;
        
        Sel <= "10010";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 19" severity error;

        Sel <= "10011";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 20" severity error;
        
        Sel <= "10100";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 21" severity error;
        
        Sel <= "10101";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 22" severity error;
        
        Sel <= "10110";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 23" severity error;

        Sel <= "10111";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 24" severity error;

        Sel <= "11000";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 25" severity error;
        
        Sel <= "11001";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 26" severity error;
        
        Sel <= "11010";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 27" severity error;

        Sel <= "11011";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 28" severity error;
        
        Sel <= "11100";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 29" severity error;
        
        Sel <= "11101";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 30" severity error;
        
        Sel <= "11110";
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 31" severity error;

        Sel <= "11111";
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 32" severity error;

        wait;
    end process;
end Mux32TBBehaviour;