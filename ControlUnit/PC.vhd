library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PC is
port (clk, load, inc, rst : in std_logic;
    d_in : in std_logic_vector(0 to 31);
    d_out : out std_logic_vector(0 to 31));
end PC;

architecture PClogic of PC is
signal pc_value : std_logic_vector(0 to 31) := (others => '0');
begin
    process (clk)
    begin
        if rst = '1' then
            pc_value <= (others => '0');
        elsif rising_edge(clk) then
            if load = '1' then
                pc_value <= d_in;
            elsif inc = '1' then
                pc_value <= pc_value + 1;
            end if;
        end if;
    end process;
    d_out <= pc_value;
end architecture;
