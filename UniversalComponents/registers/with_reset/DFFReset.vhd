library ieee;
use ieee.std_logic_1164.all;

entity DFFReset is
port (clk, d, r : in std_logic;
    q: out std_logic);
end DFFReset;

architecture DFFResetLogic of DFFReset is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if (r = '1') then 
                q <= '0';
            else
                q <= d;
            end if;
        end if;
    end process;
end architecture;