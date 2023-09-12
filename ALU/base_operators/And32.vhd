library ieee;
use ieee.std_logic_1164.all;

entity And32 is
port (A, B : in std_logic_vector(31 downto 0);
    C : out std_logic_vector(31 downto 0));
end And32;

architecture And32Logic of And32 is
begin 
    C <= A and B;    
end And32Logic;
