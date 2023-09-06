library ieee;
use ieee.std_logic_1164.all;

entity Xor32 is
port (A, B : in std_logic_vector(31 downto 0);
    C : out std_logic_vector(31 downto 0));
end Xor32;

architecture Xor32Logic of Xor32 is
begin
    C <= A xor B;
end Xor32Logic;
