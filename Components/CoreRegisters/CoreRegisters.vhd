library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xil_defaultlib;
use xil_defaultlib.ISAListings.all;
use xil_defaultlib.array_package.all;

entity CoreRegisters is
port (clk: in std_logic;
    opcode : in std_logic_vector(0 to 6);
    upper_imm : in signed(63 downto 0);
    ra, lv : in signed(63 downto 0);
    rs_sel, rt_sel, rd_sel : in std_logic_vector(0 to 4);
    rd_in : in signed(0 to 63);
    rs_out, rt_out: out signed(0 to 63));
end CoreRegisters;

architecture alternate of CoreRegisters is
    signal stored_values : vector_array(0 to 31);
begin
    stored_values(0) <= (others => '0');
    process (clk)
    begin
        if rising_edge(clk) then
            if rd_sel = "00000" then null;
            elsif (opcode = OP or opcode = OP_32 or opcode = OP_IMM or opcode = OP_IMM_32) then
                stored_values(to_integer(unsigned(rd_sel))) <= rd_in;
            elsif (opcode = JAL or opcode = JALR) then
                stored_values(to_integer(unsigned(rd_sel))) <= ra;
            elsif (opcode = LOAD) then
                stored_values(to_integer(unsigned(rd_sel))) <= lv;
            elsif opcode = LUI then 
                stored_values(to_integer(unsigned(rd_sel))) <= upper_imm;
            end if;
        end if;
    end process;
    rs_out <= stored_values(to_integer(unsigned(rs_sel)));
    rt_out <= stored_values(to_integer(unsigned(rt_sel)));
end architecture;