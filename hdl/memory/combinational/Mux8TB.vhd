library ieee;
use ieee.std_logic_1164.all;

entity Mux8TestBench is 
end Mux8TestBench;

architecture Mux8TestBenchBehaviour of Mux8TestBench is
    signal A: std_logic_vector (7 downto 0);
    signal S1, S2, S3: std_logic;
    signal X: std_logic;
begin
    Mux8Instance : entity work.Mux8 port map (A => A, S1 => S1, S2 => S2, S3 => S3, X => X);

    TestBenchProcess : process
    constant waitPeriod : time := 1 ns;
    begin
        A <= "10010101";
        S1 <= '0';
        S2 <= '0';
        S3 <= '0';
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 1" severity error;

        S1 <= '0';
        S2 <= '0';
        S3 <= '1';
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 2" severity error;

        S1 <= '0';
        S2 <= '1';
        S3 <= '0';
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 3" severity error;

        S1 <= '0';
        S2 <= '1';
        S3 <= '1';
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 4" severity error;

        S1 <= '1';
        S2 <= '0';
        S3 <= '0';
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 5" severity error;

        S1 <= '1';
        S2 <= '0';
        S3 <= '1';
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 6" severity error;

        S1 <= '1';
        S2 <= '1';
        S3 <= '0';
        wait for waitPeriod;
        assert (X = '0')
        report "test failed for 8-bit multiplexor case 7" severity error;

        S1 <= '1';
        S2 <= '1';
        S3 <= '1';
        wait for waitPeriod;
        assert (X = '1')
        report "test failed for 8-bit multiplexor case 8" severity error;

        wait;
    end process;
end Mux8TestBenchBehaviour;