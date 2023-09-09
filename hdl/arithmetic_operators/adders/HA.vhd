library ieee;
use ieee.std_logic_1164.all;

entity HalfAdder is
port (A, B: in std_logic;
    S, C: out std_logic);
end HalfAdder;

architecture HalfAdderLogic of HalfAdder is
begin
    S <= A xor B;
    C <= A and B;
end HalfAdderLogic;

