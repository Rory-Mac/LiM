library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.array_package.all;

entity CoreRegisters is
port (clk, load : in std_logic;
    rs1sel, rs2sel, rdsel : in std_logic_vector (0 to 4);
    data_in : in std_logic_vector (0 to 63);
    data_out1, data_out2 : out std_logic_vector (0 to 63));
end CoreRegisters;

architecture alternate of CoreRegisters is
    signal stored_values : vector_array(0 to 31);
begin
    process (clk)
    begin
        if rising_edge(clk) and load = '1' then
            stored_values(to_integer(unsigned(rdsel))) <= data_in;
        end if;
        data_out1 <= stored_values(to_integer(unsigned(rs1sel)));
        data_out2 <= stored_values(to_integer(unsigned(rs2sel)));
    end process;
end architecture;