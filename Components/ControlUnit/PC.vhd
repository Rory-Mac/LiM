library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xil_defaultlib;
use xil_defaultlib.ISAListings.all;

entity ControlUnit is
port (clk : in std_logic;
    opcode : in std_logic_vector(0 to 6);
    funct3 : in std_logic_vector(0 to 2);
    rs1, rs2 : in signed(0 to 63);
    rd : out signed(0 to 63);
    imm : in signed(0 to 11);
    upper_imm : in signed(0 to 19);

    instruction : in signed(31 downto 0);
    instr_addr : out unsigned(0 to 15));
end entity;

architecture ControlUnitLogic of ControlUnit is
    signal program_counter : unsigned(0 to 15) := (others => '1');
    signal instruction_register : unsigned(31 downto 0);
    signal beq_signal, bne_signal, blt_signal, bge_signal, bltu_signal, bgeu_signal : std_logic_vector(0 to 63) := (others => '0');
    signal auipc_signal : signed(0 to 31);
    signal jalr_signal : unsigned(0 to 63);
begin
    auipc_signal <= "000000000000" & upper_imm;
    jalr_signal <= unsigned(rs1 + resize(imm, 64));
    instr_addr <= program_counter;
    process (clk, program_counter, beq_signal, bne_signal, blt_signal, bge_signal, bltu_signal, bgeu_signal, auipc_signal, jalr_signal)
    begin
        if rising_edge(clk) then
            instruction_register <= instruction;
            if opcode = BRANCH then
                if (funct3 = B_BEQ and rs1 = rs2) or
                (funct3 = B_BNE and rs1 /= rs2) or
                (funct3 = B_BLT and rs1 < rs2) or
                (funct3 = B_BGE and rs1 >= rs2) or
                (funct3 = B_BLTU and unsigned(rs1) < unsigned(rs2)) or
                (funct3 = B_BGEU and unsigned(rs1) >= unsigned(rs2)) then
                    program_counter <= program_counter + unsigned(resize(imm, 16));
                else
                    program_counter <= program_counter + 1;
                end if;
            elsif opcode = JAL then
                rd <= resize(signed(program_counter + 1), 64);
                program_counter <= program_counter + unsigned(upper_imm(4 to 19));
            elsif opcode = JALR then
                rd <= resize(signed(program_counter + 1), 64);
                program_counter <= jalr_signal(48 to 63);
            elsif opcode = AUIPC then
                program_counter <= program_counter + unsigned(auipc_signal(16 to 31));
            else
                program_counter <= program_counter + 1;
            end if;
        end if;
    end process;
end architecture;
