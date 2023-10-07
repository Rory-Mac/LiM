library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.array_package.all;

library xil_defaultlib;
use xil_defaultlib.ISAListings.all;

entity CoreRegisters is
port (clk: in std_logic;
    opcode : in std_logic_vector(0 to 6);
    upper_imm : in std_logic_vector(0 to 19);
    rs1sel, rs2sel, rdsel : in std_logic_vector(0 to 4);
    data_in : in signed(0 to 63);
    data_out1, data_out2 : out signed(0 to 63));
end CoreRegisters;

architecture alternate of CoreRegisters is
    signal stored_values : vector_array(0 to 31);
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if (opcode = OP or opcode = OP_32 or opcode = OP_IMM or opcode = OP_IMM_32) then
                stored_values(to_integer(unsigned(rdsel))) <= data_in;
            elsif opcode = LUI then 
                stored_values(to_integer(unsigned(rdsel))) <= resize(signed(upper_imm & "0000000000000000"), 64);
            end if;
        end if;
        data_out1 <= stored_values(to_integer(unsigned(rs1sel)));
        data_out2 <= stored_values(to_integer(unsigned(rs2sel)));
    end process;
end architecture;