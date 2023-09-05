library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RippleCarryAdder32TestBench is
end RippleCarryAdder32TestBench;

architecture RippleCarryAdder32TestBenchBehaviour of RippleCarryAdder32TestBench is
    signal A: std_logic_vector(31 downto 0);
    signal B: std_logic_vector(31 downto 0);
    signal Cin: std_logic;
    signal Sum: std_logic_vector(31 downto 0);
    signal Cout: std_logic;
begin
    RippleCarryInstance : entity work.RippleCarryAdder32 port map (A => A, B => B, Cin => Cin, Sum => Sum, Cout => Cout);
    TestBenchProcess : process
    constant waitPeriod: time := 1 ps;
    begin
        A <= "00000000000000000000000000000001";
        B <= "00000000000000000000000000000001";
        Cin <= '0';
        wait for waitPeriod;
        assert (Sum = "00000000000000000000000000000010" and Cout = '0')
        report "test failed for ripple-carry-adder case 1" severity error;

        A <= "01001001011010111011101011101101";
        B <= "01100101010100101010101010010101";
        Cin <= '0';
        wait for waitPeriod;
        assert (Sum = "10101110101111100110010110000010" and Cout = '0')
        report "test failed for ripple-carry-adder case 2" severity error;

        A <= "11001001011010111011101011101101";
        B <= "01100101010100101010101010010101";
        Cin <= '0';
        wait for waitPeriod;
        assert (Sum = "00101110101111100110010110000010" and Cout = '1')
        report "test failed for ripple-carry-adder case 3" severity error;
        wait;
    end process;

end RippleCarryAdder32TestBenchBehaviour;
