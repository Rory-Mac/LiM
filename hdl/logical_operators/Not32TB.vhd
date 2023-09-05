library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Not32TB is
end Not32TB;

architecture Not32TestBenchBehaviour of Not32TB is
    signal A: std_logic_vector(31 downto 0);
    signal B: std_logic_vector(31 downto 0);
begin
    Not32instance : entity work.Not32 port map (A => A, B=>B);
    TestBenchProcess : process
    constant waitPeriod: time := 1 ps;
    begin
        A <= "00000000000000000000000000000000";
        wait for waitPeriod;
        assert (B = "11111111111111111111111111111111")
        report "test failed for negation mapping 32-bit input of 0 to 1" severity error;

        A <= "11111111111111111111111111111111";
        wait for waitPeriod;
        assert (B = "00000000000000000000000000000000")
        report "test failed for negation mapping 32-bit input of 1 to 0" severity error;

        A <= "10100010110101001010011101111101";
        wait for waitPeriod;
        assert (B = "01011101001010110101100010000010")
        report "test failed for negation of arbitrary 32-bit input" severity error;

        wait;
    end process;

end Not32TestBenchBehaviour;
