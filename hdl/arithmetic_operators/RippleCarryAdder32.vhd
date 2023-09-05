library ieee;
use ieee.std_logic_1164.all;
use work.FullAdder;

entity RippleCarryAdder32 is
port (A, B : in std_logic_vector(31 downto 0);
    Cin : in std_logic;
    Sum : out std_logic_vector(31 downto 0);
    Cout : out std_logic);
end RippleCarryAdder32;

architecture RippleCarryAdder32design of RippleCarryAdder32 is
    signal Carry : std_logic_vector(32 downto 0);
begin
    Carry(0) <= Cin;
    generateFullAdders : for i in 0 to 31 generate
        FullAdderInstance : entity FullAdder port map (A => A(i), B => B(i), Cin => Carry(i), S => Sum(i), Cout => Carry(i+1));
    end generate generateFullAdders;

    Cout <= Carry(32);
end RippleCarryAdder32design;