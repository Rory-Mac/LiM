library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Adder32TB is
end Adder32TB;

architecture Adder32TBLogic of Adder32TB is
    signal A: signed(31 downto 0);
    signal B: signed(31 downto 0);
    signal Sum: signed(31 downto 0);
begin
    AdderInstance : entity work.Adder32 port map (A => A, B => B, Sum => Sum);

    TestBenchProcess : process
    constant waitPeriod: time := 1 ps;
    begin
        A <= "00000000000000000000000000000001";
        B <= "00000000000000000000000000000001";
        wait for waitPeriod;
        assert (Sum = "00000000000000000000000000000010")
        report "test failed for 32-bit adder case 1" severity error;

        A <= "01001001011010111011101011101101";
        B <= "01100101010100101010101010010101";
        wait for waitPeriod;
        assert (Sum = "10101110101111100110010110000010")
        report "test failed for 32-bit adder case 2" severity error;

        A <= "11001001011010111011101011101101";
        B <= "01100101010100101010101010010101";
        wait for waitPeriod;
        assert (Sum = "00101110101111100110010110000010")
        report "test failed for 32-bit adder case 3" severity error;
        wait;
    end process;

end architecture;
