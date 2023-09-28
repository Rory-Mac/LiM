library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xil_defaultlib;
use xil_defaultlib.ISAListings.all;

entity ALU is
port (
    rs1, rs2 : in signed(0 to 63);
    imm : in signed(0 to 11);
    opcode : in std_logic_vector(0 to 6);
    funct3 : in std_logic_vector(0 to 2);
    funct7 : in std_logic_vector(0 to 6);
    rd : out signed(0 to 63)
);
end entity;

architecture ALULogic of ALU is
    signal register_ADD, register_SUB, register_XOR, register_OR, register_AND, register_SLL, register_SRL, register_SRA : signed(0 to 63);
    signal imm_zero_promoted, imm_msb_promoted, imm_ADD, imm_XOR, imm_OR, imm_AND, imm_SLL, imm_SRL, imm_SRA : signed(0 to 63);
    signal imm_ADDIW, imm_SLLIW, imm_SRLIW, imm_SRAIW : signed(0 to 63);
begin
    -- create register-register signals
    register_ADD <= rs1 + rs2;
    register_SUB <= rs1 - rs2;
    register_XOR <= rs1 xor rs2;
    register_OR <= rs1 or rs2;
    register_AND <= rs1 and rs2;
    register_SLL <= shift_left(rs1, to_integer(unsigned(rs2(58 to 63))));
    register_SRL <= signed(shift_right(unsigned(rs1), to_integer(unsigned(rs2(58 to 63)))));
    register_SRA <= shift_right(rs1, to_integer(unsigned(rs2(58 to 63))));
    -- create register-immediate signals
    imm_zero_promoted <= signed(resize(unsigned(imm), 64));
    imm_msb_promoted <= resize(imm, 64);
    imm_ADD <= rs1 + imm_msb_promoted;
    imm_XOR <= rs1 xor imm_msb_promoted;
    imm_OR <= rs1 or imm_msb_promoted;
    imm_AND <= rs1 and imm_msb_promoted;
    imm_SLL <= shift_left(rs1, to_integer(unsigned(imm(6 to 11))));
    imm_SRL <= signed(shift_right(unsigned(rs1), to_integer(unsigned(imm(6 to 11)))));
    imm_SRA <= shift_right(rs1, to_integer(unsigned(imm(6 to 11))));
    -- create register-immediate signals (R64I arithmetic extensions)
    imm_ADDIW <= resize(signed(imm_ADD(32 to 63)), 64);
    imm_SLLIW <= resize(signed(imm_SLL(32 to 63)), 64);
    imm_SRLIW <= resize(signed(imm_SRL(32 to 63)), 64);
    imm_SRAIW <= resize(signed(imm_SRA(32 to 63)), 64);
    -- process R-formatted register-register arithmetic instructions
    process (rs1, rs2, imm, opcode, funct3, funct7,
        register_ADD, imm_ADD, imm_zero_promoted, imm_msb_promoted, imm_ADDIW, register_ADD, register_SUB,
        register_XOR, register_OR, register_AND, register_SLL, register_SRL, register_SRA, imm_zero_promoted,
        imm_msb_promoted, imm_ADD, imm_XOR, imm_OR, imm_AND, imm_SLL, imm_SRL, imm_SRA, imm_ADDIW, imm_SLLIW, 
        imm_SRLIW, imm_SRAIW) is
    begin
        if opcode = OP then
            case funct3 is
                when R_ADD =>
                    if funct7 = "0000000" then
                        rd <= register_ADD;
                    elsif funct7 = "0100000" then
                        rd <= register_SUB;
                    end if;
                when R_XOR => rd <= register_XOR;
                when R_OR => rd <= register_OR;
                when R_AND => rd <= register_AND;
                when R_SLL => rd <= register_SLL;
                when R_SRL =>
                    if funct7(1) = '0' then
                        rd <= register_SRL;
                    elsif funct7(1) = '1' then
                        rd <= register_SRA;
                    end if;
                when R_SLT =>
                    if rs1 <= rs2 then
                        rd <= (63 => '1', others => '0');
                    else
                        rd <= (others => '0');
                    end if;
                when R_SLTU =>
                    if unsigned(rs1) <= unsigned(rs2) then
                        rd <= (63 => '1', others => '0');
                    else
                        rd <= (others => '0');
                    end if;
                when others =>
                    null;
            end case;
        -- process I-formatted register-immediate arithmetic instructions
        elsif opcode = OP_IMM then
            case funct3 is
                when I_ADD => rd <= imm_ADD;
                when I_XOR => rd <= imm_XOR;
                when I_OR => rd <= imm_OR;
                when I_AND => rd <= imm_AND;
                when I_SLL => rd <= imm_SLL;
                when I_SRL =>
                    if funct7(1) = '0' then
                        rd <= imm_SRL;
                    elsif funct7(1) = '1' then
                        rd <= imm_SRA;
                    end if;
                when I_SLT =>
                    if rs1 <= imm_msb_promoted then
                        rd <= (63 => '1', others => '0');
                    else
                        rd <= (others => '0');
                    end if;
                when I_SLTU =>
                    if unsigned(rs1) <= unsigned(imm_zero_promoted) then
                        rd <= (63 => '1', others => '0');
                    else
                        rd <= (others => '0');
                    end if;
                when others =>
                    null;
            end case;
        -- process I-formatted register-immediate arithmetic instructions (R64I extensions operate on low 32 bits)
        elsif opcode = OP_IMM_32 then
            case funct3 is
                when I_ADDIW => rd <= imm_ADDIW;
                when I_SLLIW => rd <= imm_SLLIW;
                when I_SRLIW =>
                    if funct7 = "0000000" then
                        rd <= imm_SRLIW;
                    elsif funct7 = "0100000" then
                        rd <= imm_SRAIW;
                    end if;
                when others =>
                    null;
            end case;
        end if;
    end process;
end architecture;