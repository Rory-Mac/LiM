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
    rd : out signed(0 to 63);
    imm : in signed(0 to 11);
    upper_imm : in signed(0 to 19);
    d_out : out unsigned(0 to 15));
end PC;

architecture PClogic of PC is
signal pc_value : unsigned(0 to 15) := (others => '1');
signal next_value : unsigned(0 to 63) := (others => '0');
signal beq_signal, bne_signal, blt_signal, bge_signal, bltu_signal, bgeu_signal : std_logic_vector(0 to 63) := (others => '0');
signal auipc_signal : signed(0 to 31);
signal jalr_signal : unsigned(0 to 63);
begin
    auipc_signal <= "000000000000" & upper_imm;
    jalr_signal <= unsigned(rs1 + resize(imm, 64));
    d_out <= pc_value;
    process (clk, pc_value, next_value, beq_signal, bne_signal, blt_signal, bge_signal, bltu_signal, bgeu_signal, auipc_signal, jalr_signal)
    begin
        if rising_edge(clk) then
            if opcode = BRANCH then
                if (funct3 = B_BEQ and rs1 = rs2) or
                (funct3 = B_BNE and rs1 /= rs2) or
                (funct3 = B_BLT and rs1 < rs2) or
                (funct3 = B_BGE and rs1 >= rs2) or
                (funct3 = B_BLTU and unsigned(rs1) < unsigned(rs2)) or
                (funct3 = B_BGEU and unsigned(rs1) >= unsigned(rs2)) then
                    pc_value <= pc_value + unsigned(resize(imm, 16));
                else
                    pc_value <= pc_value + 1;
                end if;
            elsif opcode = JAL then
                rd <= resize(signed(pc_value + 1), 64);
                pc_value <= pc_value + unsigned(upper_imm(4 to 19));
            elsif opcode = JALR then
                rd <= resize(signed(pc_value + 1), 64);
                pc_value <= jalr_signal(48 to 63);
            elsif opcode = AUIPC then
                pc_value <= pc_value + unsigned(auipc_signal(16 to 31));
            else
                pc_value <= pc_value + 1;
            end if;
        end if;
    end process;
end architecture;
