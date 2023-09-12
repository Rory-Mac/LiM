library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UnsignedLeftShiftTB is
end UnsignedLeftShiftTB;

architecture UnsignedLeftShiftTBLogic of UnsignedLeftShiftTB is
    signal sel : unsigned(0 to 4);
    signal d, q : signed(0 to 31);
begin
    UnsignedLeftShiftInstance : entity work.UnsignedLeftShift port map (d => d, sel => sel, q => q);

    UnsignedLeftShiftTestbench : process
    constant waitPeriod : time := 1 ps;
    begin
        d <= "00000000000000000000000000000001";
        sel <= "00001";
        wait for waitPeriod;
        assert (q = "00000000000000000000000000000010") report "testbench failed for unsigned left shift case 1" severity error;
        d <= "00000000000000000000000000000010";
        sel <= "00010";
        wait for waitPeriod;
        assert (q = "00000000000000000000000000001000") report "testbench failed for unsigned left shift case 2" severity error;
        d <= "00000000000000000000000000001000";
        sel <= "00100";
        wait for waitPeriod;
        assert (q = "00000000000000000000000010000000") report "testbench failed for unsigned left shift case 3" severity error;
        d <= "00000000000000000000000010000000";
        sel <= "01000";
        wait for waitPeriod;
        assert (q = "00000000000000001000000000000000") report "testbench failed for unsigned left shift case 4" severity error;
        d <= "00000000000000001000000000000000";
        sel <= "10000";
        wait for waitPeriod;
        assert (q = "10000000000000000000000000000000") report "testbench failed for unsigned left shift case 5" severity error;
        d <= "00000000000000000000000000001011";
        sel <= "00001";
        wait for waitPeriod;
        assert (q = "00000000000000000000000000010110") report "testbench failed for unsigned left shift case 6" severity error;
        d <= "00000000000000000000000000010110";
        sel <= "00101";
        wait for waitPeriod;
        assert (q = "00000000000000000000001011000000") report "testbench failed for unsigned left shift case 7" severity error;
        d <= "00000000000000000000001011000000";
        sel <= "10000";
        wait for waitPeriod;
        assert (q = "00000010110000000000000000000000") report "testbench failed for unsigned left shift case 8" severity error;
        d <= "00000010110000000000000000000000";
        sel <= "01000";
        wait for waitPeriod;
        assert (q = "11000000000000000000000000000000") report "testbench failed for unsigned left shift case 9" severity error;
        d <= "11000000000000000000000000000000";
        sel <= "00011";
        wait for waitPeriod;
        assert (q = "00000000000000000000000000000000") report "testbench failed for unsigned left shift case 10" severity error;
        d <= "11111111111111111111111111111111";
        sel <= "11111";
        wait for waitPeriod;
        assert (q = "10000000000000000000000000000000") report "testbench failed for unsigned left shift case 11" severity error;

        wait;
    end process;

end architecture;