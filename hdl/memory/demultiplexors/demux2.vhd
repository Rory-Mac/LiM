library ieee;
use ieee.std_logic_1164.all;

entity Demux2 is
port (A, Sel: in std_logic;
    X1, X2: out std_logic);
end Demux2;

architecture Demux2Logic of Demux2 is
begin
    X1 <= A when Sel = '0' else '0';
    X2 <= A when Sel = '1' else '0';
end Demux2Logic;
