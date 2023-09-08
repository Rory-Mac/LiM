library ieee;
use ieee.std_logic_1164.all;

entity DFF is
port (clk, d : in std_logic;
    q: out std_logic);
end DFF;

architecture DFFLogic of DFF is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            q <= d;
        end if;
    end process;
end architecture;