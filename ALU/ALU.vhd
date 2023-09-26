library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
port (
    rs1, rs2 : in std_logic_vector(0 to 63);
    imm : in std_logic_vector(0 to 11);
    opcode : in std_logic_vector(0 to 6);
    funct3 : in std_logic_vector(0 to 2);
    funct7 : in std_logic_vector(0 to 6);
    rd : out std_logic_vector(0 to 63)
);
end entity;

architecture ALULogic of ALU is
signal imm_msb_extended : signed(0 to 63);
signal imm_zero_extended : unsigned(0 to 63); 
begin
    imm_msb_extended <= resize(signed(imm), 64);
    imm_zero_extended <= resize(unsigned(imm), 64);
    process (opcode)
    begin
        if opcode = "0110011" then
            case funct3 is
                when "000" =>
                    if funct7 = "00000000" then
                        rd <= signed(rs1) + signed(rs2);
                    elsif funct7 = "0100000" then
                        rd <= signed(rs1) - signed(rs2);
                    end if;
                when "100" =>
                    rd <= rs1 xor rs2;
                when "110" =>
                    rd <= rs1 or rs2;
                when "111" =>
                    rd <= rs1 and rs2;
                when "001" =>
                    rd <= shift_left(rs1, unsigned(rs2(58 to 63)));
                when "101" =>
                    if funct7 = "0000000" then
                        rd <= shift_right(unsigned(rs1), unsigned(rs2(58 to 63)));
                    elsif funct7 = "0100000" then
                        rd <= shift_right(signed(rs1), unsigned(rs2(58 to 63)));
                    end if;
                when "010" =>
                    if signed(rs1) <= signed(rs2) then
                        rd <= (63 => 1, others => 0);
                    else
                        rd <= (others => 0);
                    end if;
                when "011" =>
                    if unsigned(rs1) <= unsigned(rs2) then
                        rd <= (63 => 1, others => 0);
                    else
                        rd <= (others => 0);
                    end if;
            end case;
        elsif opcode = "0010011" then
            case funct3 is
                when "000" =>
                    rd <= signed(rs1) + imm_msb_extended;
                when "100" =>
                    rd <= rs1 xor imm_msb_extended;
                when "110" =>
                    rd <= rs1 or imm_msb_extended;
                when "111" =>
                    rd <= rs1 and imm_msb_extended;
                when "001" =>
                    rd <= shift_left(rs1, unsigned(imm));
                when "101" =>
                    if funct7 = "0000000" then
                        rd <= shift_right(unsigned(rs1), unsigned(imm));
                    elsif funct7 = "0100000" then
                        rd <= shift_right(signed(rs1), unsigned(imm));
                    end if;
                when "010" =>
                    if signed(rs1) <= imm_msb_extended then
                        rd <= (63 => 1, others => 0);
                    else
                        rd <= (others => 0);
                    end if;
                when "011" =>
                    if unsigned(rs1) <= imm_zero_extended then
                        rd <= (63 => 1, others => 0);
                    else
                        rd <= (others => 0);
                    end if;
            end case;
        end if;
    end process;
end architecture;