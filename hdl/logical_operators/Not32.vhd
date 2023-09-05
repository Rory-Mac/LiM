library ieee;
use ieee.std_logic_1164.all;

entity Not32 is
port (A: in std_logic_vector(31 downto 0);
    B: out std_logic_vector(31 downto 0));
end Not32;

architecture Not32Arch of Not32 is
begin
    B <= not A;
end Not32Arch;