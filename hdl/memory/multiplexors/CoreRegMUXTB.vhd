library ieee;
use ieee.std_logic_1164.all;
use work.array_package.all;

entity CoreRegMUXTB is 
end CoreRegMUXTB;

architecture CoreRegMUXTBlogic of CoreRegMUXTB is
    signal A : vector_array(0 to 31);
    signal Sel : std_logic_vector(0 to 4);
    signal X : std_logic_vector(0 to 31);
begin
    CoreRegMUXinstance : entity work.CoreRegMUX port map (A => A, Sel => Sel, X => X);

    TestBenchProcess : process
    constant waitPeriod : time := 1 ps;
    begin
        A(0) <= "11111111000000001111111100000000";
        for i in 1 to 15 loop
            A(i) <= "00000000000000000000000000000000";
        end loop;
        A(16) <= "10101010101010101010101010101010";
        for i in 17 to 30 loop
            A(i) <= "00000000000000000000000000000000";
        end loop;
        A(31) <= "11111111111111111111111111111111";
        Sel <= "00000";
        wait for waitPeriod;
        assert (X = "11111111000000001111111100000000")
        report "test failed for core register multiplexor case 1" severity error;

        Sel <= "10000";
        wait for waitPeriod;
        assert (X = "10101010101010101010101010101010")
        report "test failed for core register multiplexor case 2" severity error;

        Sel <= "11111";
        wait for waitPeriod;
        assert (X = "11111111111111111111111111111111")
        report "test failed for core register multiplexor case 3" severity error;

        wait;
    end process;
end CoreRegMUXTBlogic;