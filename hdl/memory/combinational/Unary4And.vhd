library ieee;
use ieee.std_logic_1164.all;

entity Unary4And is
port (A : in std_logic_vector(3 downto 0);
    B : out std_logic);
end Unary4And;

architecture Unary4AndLogic of Unary4And is
begin
    B <= A(3) and A(2) and A(1) and A(0);
end Unary4AndLogic;
