library ieee;
use ieee.std_logic_1164.all;

entity Unary8Or is
port (A : in std_logic_vector(7 downto 0);
    B : out std_logic);
end Unary8Or;

architecture Unary8OrLogic of Unary8Or is
begin
    B <= A(7) or A(6) or A(5) or A(4) or A(3) or A(2) or A(1) or A(0);
end Unary8OrLogic;
