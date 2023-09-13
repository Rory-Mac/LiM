library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Adder32 is
port (A, B : in signed(31 downto 0);
    Sum : out signed(31 downto 0));
end Adder32;

architecture Adder32Logic of Adder32 is
begin
    Sum <= A + B;
end architecture;