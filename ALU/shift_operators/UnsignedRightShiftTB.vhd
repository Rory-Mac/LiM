library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UnsignedRightShiftTB is
end UnsignedRightShiftTB;

architecture UnsignedRightShiftTBLogic of UnsignedRightShiftTB is
    signal sel : unsigned(0 to 4);
    signal d, q : signed(0 to 31);
begin
    UnsignedRightShiftTBLogic : entity work.UnsignedRightShift port map (d => d, sel => sel, q => q);

    UnsignedRightShiftTestbench : process
    constant waitPeriod : time := 1 ps;
    begin
        d <= "10000000000000000000000000000000";
        sel <= "00001";
        wait for waitPeriod;
        assert (q = "01000000000000000000000000000000") report "testbench failed for unsigned right shift case 1" severity error;
        d <= "01000000000000000000000000000000";
        sel <= "00010";
        wait for waitPeriod;
        assert (q = "00010000000000000000000000000000") report "testbench failed for unsigned right shift case 2" severity error;
        d <= "00010000000000000000000000000000";
        sel <= "00100";
        wait for waitPeriod;
        assert (q = "00000001000000000000000000000000") report "testbench failed for unsigned right shift case 3" severity error;
        d <= "00000001000000000000000000000000";
        sel <= "01000";
        wait for waitPeriod;
        assert (q = "00000000000000010000000000000000") report "testbench failed for unsigned right shift case 4" severity error;
        d <= "00000000000000010000000000000000";
        sel <= "10000";
        wait for waitPeriod;
        assert (q = "00000000000000000000000000000001") report "testbench failed for unsigned right shift case 5" severity error;
        d <= "11010000000000000000000000000000";
        sel <= "00001";
        wait for waitPeriod;
        assert (q = "01101000000000000000000000000000") report "testbench failed for unsigned right shift case 6" severity error;
        d <= "01101000000000000000000000000000";
        sel <= "00101";
        wait for waitPeriod;
        assert (q = "00000011010000000000000000000000") report "testbench failed for unsigned right shift case 7" severity error;
        d <= "00000011010000000000000000000000";
        sel <= "10001";
        wait for waitPeriod;
        assert (q = "00000000000000000000000110100000") report "testbench failed for unsigned right shift case 8" severity error;
        d <= "11011010101101010101001111010110";
        sel <= "01010";
        wait for waitPeriod;
        assert (q = "00000000001101101010110101010100") report "testbench failed for unsigned right shift case 9" severity error;
        d <= "00000000001101101010110101010100";
        sel <= "00011";
        wait for waitPeriod;
        assert (q = "00000000000001101101010110101010") report "testbench failed for unsigned right shift case 10" severity error;
        d <= "11111111111111111111111111111111";
        sel <= "11111";
        wait for waitPeriod;
        assert (q = "00000000000000000000000000000001") report "testbench failed for unsigned right shift case 11" severity error;

        wait;
    end process;

end architecture;