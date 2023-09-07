library ieee;
use ieee.std_logic_1164.all;

entity Mux2 is
port (A, B, Sel : in std_logic;
    X : out std_logic);
end Mux2;

architecture Mux2Logic of Mux2 is
begin
    X <= A when Sel = '0' else B;
end Mux2Logic;
