library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
signal imm_zero_extended : signed(0 to 63);
signal imm_msb_extended : signed(0 to 63);
begin
    process (rs1, rs2, imm, funct3, funct7, opcode, imm_zero_extended, imm_msb_extended)
    begin
        imm_zero_extended <= x"0000000000000" & imm;
        if imm(0) = '1' then
            imm_msb_extended <= x"FFFFFFFFFFFFF" & imm;
        elsif imm(0) = '0' then
            imm_msb_extended <= x"0000000000000" & imm;
        end if;
        if opcode = "0110011" then
            case funct3 is
                when "000" =>
                    if funct7 = "0000000" then
                        rd <= rs1 + rs2;
                    elsif funct7 = "0100000" then
                        rd <= rs1 - rs2;
                    end if;
                when "100" =>
                    rd <= rs1 xor rs2;
                when "110" =>
                    rd <= rs1 or rs2;
                when "111" =>
                    rd <= rs1 and rs2;
                when "001" =>
                    rd <= shift_left(rs1, to_integer(unsigned(rs2(58 to 63))));
                when "101" =>
                    if funct7 = "0000000" then
                        rd <= signed(shift_right(unsigned(rs1), to_integer(unsigned(rs2(58 to 63)))));
                    elsif funct7 = "0100000" then
                        rd <= shift_right(rs1, to_integer(unsigned(rs2(58 to 63))));
                    end if;
                when "010" =>
                    if rs1 <= rs2 then
                        rd <= (63 => '1', others => '0');
                    else
                        rd <= (others => '0');
                    end if;
                when "011" =>
                    if unsigned(rs1) <= unsigned(rs2) then
                        rd <= (63 => '1', others => '0');
                    else
                        rd <= (others => '0');
                    end if;
                when others =>
                    NULL;
            end case;
        elsif opcode = "0010011" then
            case funct3 is
                when "000" =>
                    rd <= rs1 + imm_msb_extended;
                when "100" =>
                    rd <= rs1 xor imm_msb_extended;
                when "110" =>
                    rd <= rs1 or imm_msb_extended;
                when "111" =>
                    rd <= rs1 and imm_msb_extended;
                when "001" =>
                    rd <= shift_left(rs1, to_integer(unsigned(imm)));
                when "101" =>
                    if funct7(1) = '0' then
                        rd <= signed(shift_right(unsigned(rs1), to_integer(unsigned(imm))));
                    elsif funct7(1) = '1' then
                        rd <= shift_right(rs1, to_integer(unsigned(imm)));
                    end if;
                when "010" =>
                    if rs1 <= imm_msb_extended then
                        rd <= (63 => '1', others => '0');
                    else
                        rd <= (others => '0');
                    end if;
                when "011" =>
                    if unsigned(rs1) <= unsigned(imm_zero_extended) then
                        rd <= (63 => '1', others => '0');
                    else
                        rd <= (others => '0');
                    end if;
                when others =>
                    NULL;
            end case;
        end if;
    end process;
end architecture;