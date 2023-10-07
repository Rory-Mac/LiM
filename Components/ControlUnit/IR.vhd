library ieee;
use ieee.std_logic_1164.all;

entity IR is
port (clk, load: in std_logic;
    d_in : in std_logic_vector(0 to 31);
    d_out : out std_logic_vector(0 to 31));
end IR;

architecture IRLogic of IR is
signal instruction : std_logic_vector(0 to 31) := (others => '0');
begin
    process (clk)
    begin
        if rising_edge(clk) and load = '1' then
            instruction <= d_in;
        end if;
    end process;
    d_out <= instruction;
end architecture;
