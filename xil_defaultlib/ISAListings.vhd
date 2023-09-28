library ieee;
use ieee.std_logic_1164.all;

package ISAListings is
    -- opcode definitions
    constant OP : std_logic_vector := "0110011";
    constant OP_IMM : std_logic_vector := "0010011";
    constant OP_IMM_32 : std_logic_vector := "0011011";
    -- funct3 bits for R-formatted instructions
    constant R_ADD : std_logic_vector := "000"; -- funct7 bits 0000000
    constant R_SUB : std_logic_vector := "000"; -- funct7 bits 0100000
    constant R_XOR : std_logic_vector := "100";
    constant R_OR : std_logic_vector := "110";
    constant R_AND : std_logic_vector := "111";
    constant R_SLL : std_logic_vector := "001";
    constant R_SRL : std_logic_vector := "101"; -- funct7 bits 000000i
    constant R_SRA : std_logic_vector := "101"; -- funct7 bits 010000i
    constant R_SLT : std_logic_vector := "010";
    constant R_SLTU : std_logic_vector := "011";
    -- funct3 bits for I-formatted arithmetic instructions
    constant I_ADD : std_logic_vector := "000";
    constant I_XOR : std_logic_vector := "100";
    constant I_OR : std_logic_vector := "110";
    constant I_AND : std_logic_vector := "111";
    constant I_SLL : std_logic_vector := "001";
    constant I_SRL : std_logic_vector := "101"; -- funct7 bits 010000i
    constant I_SRA : std_logic_vector := "101"; -- funct7 bits 010000i
    constant I_SLT : std_logic_vector := "010";
    constant I_SLTU : std_logic_vector := "011";
    -- funct3 bits for I-formatted 64-bit arithmetic extensions
    constant I_ADDIW : std_logic_vector := "000";
    constant I_SLLIW : std_logic_vector := "001";
    constant I_SRLIW : std_logic_vector := "101"; -- funct7 bits 0100000
    constant I_SRAIW : std_logic_vector := "101"; -- funct7 bits 0100000
end package;