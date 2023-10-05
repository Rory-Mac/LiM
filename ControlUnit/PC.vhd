library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xil_defaultlib;
use xil_defaultlib.ISAListings.all;

entity PC is
port (clk : in std_logic;
    opcode : in std_logic_vector(0 to 6);
    funct3 : in std_logic_vector(0 to 2);
    rs1, rs2 : in signed(0 to 63);
    rd : out unsigned(0 to 63);
    imm : in signed(0 to 11);
    d_in : in unsigned(0 to 63);
    d_out : out unsigned(0 to 63));
end PC;

architecture PClogic of PC is
signal pc_value : unsigned(0 to 63) := (others => '1');
signal next_value : unsigned(0 to 63) := (others => '0');
signal beq_signal, bne_signal, blt_signal, bge_signal, bltu_signal, bgeu_signal : std_logic_vector(0 to 63) := (others => '0');
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if opcode = BRANCH then
                if (funct3 = B_BEQ and rs1 = rs2) or
                (funct3 = B_BNE and rs1 /= rs2) or
                (funct3 = B_BLT and rs1 < rs2) or
                (funct3 = B_BGE and rs1 >= rs2) or
                (funct3 = B_BLTU and unsigned(rs1) < unsigned(rs2)) or
                (funct3 = B_BGEU and unsigned(rs1) >= unsigned(rs2)) then
                    pc_value <= d_in;
                else
                    pc_value <= pc_value + 1;
                end if;
            elsif opcode = JAL then
                rd <= pc_value + 1;
                pc_value <= d_in + unsigned(resize(imm, 64));
            elsif opcode = JALR then
                rd <= pc_value + 1;
                pc_value <= unsigned(rs1 + resize(imm, 64));
            else
                pc_value <= pc_value + 1;
            end if;
        end if;
    end process;
    d_out <= pc_value;
end architecture;
