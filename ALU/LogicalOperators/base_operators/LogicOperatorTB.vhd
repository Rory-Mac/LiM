library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LogicOperatorTB is
end LogicOperatorTB;

architecture LogicOperatorTBbehaviour of LogicOperatorTB is
    constant waitPeriod: time := 1 ps;
    signal A_and, B_and, C_and: std_logic_vector(31 downto 0);
    signal A_or, B_or, C_or: std_logic_vector(31 downto 0);
    signal A_xor, B_xor, C_xor: std_logic_vector(31 downto 0);
begin
    And32instance : entity work.And32 port map (A => A_and, B => B_and, C => C_and);
    Or32instance : entity work.Or32 port map (A => A_or, B => B_or, C => C_or);
    Xor32instance : entity work.Xor32 port map (A => A_xor, B => B_xor, C => C_xor);

    And32TestBenchProcess : process
    begin
        A_and <= "01011111011101110111011011101101";
        B_and <= "11101011011101101011110111011110";
        wait for waitPeriod;
        assert (C_and = "01001011011101100011010011001100")
        report "test failed for 32-bit AND operation";

        wait;
    end process;

    Or32TestBenchProcess : process
    begin
        A_or <= "10010101001010101000101001011101";
        B_or <= "00111010000101110100001010111000";
        wait for waitPeriod;
        assert (C_or = "10111111001111111100101011111101")
        report "test failed for 32-bit OR operation";

        wait;
    end process;

    Xor32TestBenchProcess : process
    begin
        A_xor <= "10101000100110110110101101110101";
        B_xor <= "11010011101010111010101001011010";
        wait for waitPeriod;
        assert (C_xor = "01111011001100001100000100101111")
        report "test failed for 32-bit XOR operation";

        wait;
    end process;

end LogicOperatorTBbehaviour;
