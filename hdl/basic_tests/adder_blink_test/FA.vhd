library ieee;
use ieee.std_logic_1164.all;
use work.HalfAdder.all;

entity FullAdder is
port (A, B, Cin: in std_logic;
    S, Cout: out std_logic);
end FullAdder;

architecture FullAdderLogic of FullAdder is
signal A1, B1, S1, C1, A2, B2, S2, C2 : std_logic;
begin
    HA1 : entity HalfAdder port map (A => A1, B => B1, S => S1, C => C1);
    HA2 : entity HalfAdder port map (A => A2, B => B2, S => S2, C => C2);
    A1 <= A;
    B1 <= B;
    A2 <= S1;
    B2 <= Cin;
    S <= S2;
    Cout <= C1 or C2;
end FullAdderLogic;

