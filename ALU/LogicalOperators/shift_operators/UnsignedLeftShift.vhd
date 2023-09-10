library ieee;
use ieee.std_logic_1164.all;
use work.array_package.all;

entity UnsignedLeftShift is
port (d : in std_logic_vector(0 to 31);
    sel : in std_logic_vector(1 to 5);
    q : out std_logic_vector(0 to 31));
end entity;

architecture UnsignedLeftShiftLogic of UnsignedLeftShift is
    signal muxA, muxB, mux_out: vector_array(1 to 5);
    signal mux_sels: std_logic_vector(1 to 5);
begin
    generateMuxLayers : for i in 1 to 5 generate
        generateMuxLayer : for j in 0 to 31 generate
            MuxInstance : entity work.Mux2 port map (A => muxA(i)(j), B => muxB(i)(j), Sel => mux_sels(i), X => mux_out(i)(j));
        end generate;
    end generate;

    reverseSelectors : for i in 1 to 5 generate
        mux_sels(i) <= sel(6 - i);
    end generate;

    muxA(1) <= d;
    muxB(1)(0 to 30) <= d(1 to 31);
    muxB(1)(31) <= '0';
    muxA(2) <= mux_out(1);
    muxB(2)(0 to 29) <= mux_out(1)(2 to 31);
    muxB(2)(30 to 31) <= (others => '0');
    muxA(3) <= mux_out(2);
    muxB(3)(0 to 27) <= mux_out(2)(4 to 31);
    muxB(3)(28 to 31) <= (others => '0');
    muxA(4) <= mux_out(3);
    muxB(4)(0 to 23) <= mux_out(3)(8 to 31);
    muxB(4)(24 to 31) <= (others => '0');
    muxA(5) <= mux_out(4);
    muxB(5)(0 to 15) <= mux_out(4)(16 to 31);
    muxB(5)(16 to 31) <= (others => '0');
    q <= mux_out(5);

end architecture;