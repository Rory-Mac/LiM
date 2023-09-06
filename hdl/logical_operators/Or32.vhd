library ieee;
use ieee.std_logic_1164.all;

entity Or32 is
port (A, B : in std_logic_vector(31 downto 0);
    C : out std_logic_vector(31 downto 0));
end Or32;

architecture Or32Logic of Or32 is
begin
    C <= A or B;
end Or32Logic;
