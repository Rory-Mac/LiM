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
    signal A, B: signed(0 to 63); 
begin
    A <= signed(rs1);
    process (opcode)
    begin
        # if R-formatted instruction, take rs2 as B signal
        if opcode = "0110011" then
            B <= signed(rs2);
        # if I-formatted instruction, take signed imm as B signal unless sltu
        elsif opcode = "0010011" then
            if funct3 = "011" then
                B <= unsigned(imm);
            else
                B <= signed(imm);
            end if;
        end if;
    end process;
    process (A, B)
    begin 
        case funct3 is 
            when "000" => 
                if funct7(2) = '1' then
                    rd <= A - B;
                elsif funct7(2) = '0' then
                    rd <= A + B;
                end if;
            when "001" =>
                rd <= shift_left(to_unsigned(A), B(58 to 63));
            when "010" => 
                if A <= B then
                    rd <= (0 => '1', others => '0');
                else
                    rd <= (others => '0');
                end if;
            when "011" =>
                if to_unsigned(A) <= to_unsigned(B) then
                    rd <= (0 => '1', others => '0');
                else
                    rd <= (others => '1');
                end if;
            when "100" =>
                rd <= A xor B;
            when "101" =>
                if funct7(2) = '1' then
                    rd <= shift_right(to_unsigned(A), B(58 to 63));
                elsif funct7(2) = '0' then
                    rd <= shift_right(A, B(58 to 63));
                end if;
            when "110" =>
                rd <= A or B;
            when "111" =>
                rd <= A and B;
            when others =>
                rd <= (others => 'U');
        end case;
    end process;
end architecture;