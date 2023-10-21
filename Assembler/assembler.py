import re
import sys
import os

#-------------------------------------------------------------------------------------------------------------------------
# All regular expressions used in the assembly pipeline are declared here
#-------------------------------------------------------------------------------------------------------------------------
core_register = r"(zero\|ra\|sp\|gp\|tp\|t[0-6]\|fp\|s[0-11]\|a[0-7])"
symbol_expression = r"[a-zA-Z0-9_]+"
multiline_pseudoinstruction = r"^\s*(ret\|call\|tail\|la\|li\|(l[bhwd]\s+" + core_register + r",\s+[a-zA-Z0-9_]{3,}))\s*$"
comments = r"((--)\|#).*"
whitespace = r"\s+"
leading_trailing_whitespace = r"^\s+\|\s+$"
#-------------------------------------------------------------------------------------------------------------------------
# Dictionary maps mapping instruction symbols to binary representations are declared here  
#-------------------------------------------------------------------------------------------------------------------------
instruction_opcodes = dict.fromkeys(["ADD", "SUB", "XOR", "OR", "AND", "SLL", "SRL", "SRA", "SLT", "SLTU"], "OP")
instruction_opcodes.update(dict.fromkeys["ADDW", "SUBW", "SLLW", "SRLW", "SRAW"], "OP_32")
instruction_opcodes.update(dict.fromkeys["ADDI", "SUBI", "XORI", "ORI", "ANDI", "SLLI", "SRLI", "SRAI", "SLTI", "SLTIU"], "OP_IMM")
instruction_opcodes.update(dict.fromkeys["ADDIW", "SUBIW", "SLLIW", "SRLIW", "SRAIW",], "OP_IMM_32")
instruction_opcodes.update(dict.fromkeys["LB", "LH", "LW", "LBU", "LHU", "LD", "LWU"], "LOAD")
instruction_opcodes.update(dict.fromkeys["SB", "SH", "SW", "SD"], "STORE")
instruction_opcodes.update(dict.fromkeys["SYSTEM", "ECALL", "EBREAK"], "SYSTEM")
instruction_opcodes["JAL"] = "JAL"
instruction_opcodes["JALR"] = "JALR"
instruction_opcodes["LUI"] = "LUI"
instruction_opcodes["AUIPC"] = "AUIPC"
instruction_opcodes["SYSTEM"] = "SYSTEM"
opcodes = {
    "OP" : "0110011",
    "OP_32" : "0111011",
    "OP_IMM" : "0010011",
    "OP_IMM_32" : "0011011",
    "LOAD" : "0000011",
    "STORE" : "0100011",
    "BRANCH" : "1100011",
    "JAL" : "1101111",
    "JALR" : "1100111",
    "LUI" : "0110111",
    "AUIPC" : "0010111",
    "SYSTEM" : "1110011",
}
R_type = ["ADD", "SUB", "XOR", "OR", "AND", "SLL", "SRL", "SRA", "SLT", "SLTU"]
R_type_bits = {
    "ADD" : {"funct3" : "000", "funct7" : "0000000"},
    "SUB" : {"funct3" : "000", "funct7" : "0100000"},
    "XOR" : {"funct3" : "100", "funct7" : "0000000"},
    "OR" : {"funct3" : "110", "funct7" : "0000000"},
    "AND" : {"funct3" : "111", "funct7" : "0000000"},
    "SLL" : {"funct3" : "001", "funct7" : "0000000"},
    "SRL" : {"funct3" : "101", "funct7" : "0000000"},
    "SRA" : {"funct3" : "101", "funct7" : "0100000"},
    "SLT" : {"funct3" : "010", "funct7" : "0000000"},
    "SLTU" : {"funct3" : "011", "funct7" : "0000000"},
}
I_type = ["ADDI", "XORI", "ORI", "ANDI", "SLLI", "SRLI", "SRAI", "SLTI", "SLTIU", "JALR"]
I_type_bits = {
    "ADDI" : {"funct3" : "000"},
    "XORI" : {"funct3" : "100"},
    "ORI" : {"funct3" : "110"},
    "ANDI" : {"funct3" : "111"},
    "SLLI" : {"funct3" : "001", "funct7" : "000000"},
    "SRLI" : {"funct3" : "101", "funct7" : "000000"},
    "SRAI" : {"funct3" : "101", "funct7" : "010000"},
    "SLTI" : {"funct3" : "010"},
    "SLTIU" : {"funct3" : "011"},
    "JALR" : {"funct3" : "000"},
}
I_type_load = ["LB", "LH", "LW", "LBU", "LHU"]
I_type_load_bits = {
    "LB" : {"funct3" : "000"},
    "LH" : {"funct3" : "001"},
    "LW" : {"funct3" : "010"},
    "LBU" : {"funct3" : "100"},
    "LHU" : {"funct3" : "101"},
}
S_type = ["SB", "SH", "SW"]
S_type_bits = {
    "SB" : {"funct3" : "000"},
    "SH" : {"funct3" : "001"},
    "SW" : {"funct3" : "010"},
}
B_type = ["BEQ", "BNE", "BLT", "BGE", "BLTU", "BGEU"]
B_type_bits = {
    "BEQ" : {"funct3" : "000"},
    "BNE" : {"funct3" : "001"},
    "BLT" : {"funct3" : "100"},
    "BGE" : {"funct3" : "101"},
    "BLTU" : {"funct3" : "110"},
    "BGEU" : {"funct3" : "111"},
}
U_type = ["LUI", "AUIPC"]
J_type = ["JAL"]
SYSTEM_type = ["SYSTEM", "ECALL", "EBREAK"]
registers = {
    "zero" : "00000",
    "ra" : "00001",
    "sp" : "00010",
    "gp" : "00011",
    "tp" : "00100",
    "t0" : "00101",
    "t1" : "00110",
    "t2" : "00111",
    "s0" : "01000",
    "fp" : "01000",
    "s1" : "01001",
    "a0" : "01010",
    "a1" : "01011",
    "a2" : "01100",
    "a3" : "01101",
    "a4" : "01110",
    "a5" : "01111",
    "a6" : "10000",
    "a7" : "10001",
    "s2" : "10010",
    "s3" : "10011",
    "s4" : "10100",
    "s5" : "10101",
    "s6" : "10110",
    "s7" : "10111",
    "s8" : "11000",
    "s9" : "11001",
    "s10" : "11010",
    "s11" : "11011",
    "t3" : "11100",
    "t4" : "11101",
    "t5" : "11110",
    "t6" : "11111",
}
#-------------------------------------------------------------------------------------------------------------------------
# command line flags and arguments
#-------------------------------------------------------------------------------------------------------------------------
asm_filepath = os.getcwd() + "/Assembler/assembly_files" + sys.argv[1]
temp1_filepath = asm_filepath[-2] + "_1.temp"
temp2_filepath = asm_filepath[-2] + "_2.temp"
a_flag = "-a" in sys.argv
output_file = asm_filepath[-2] + ".txt" if a_flag else asm_filepath[-2] + ".exe" 
exe_filepath = asm_filepath[-2] + ".exe"
#-------------------------------------------------------------------------------------------------------------------------
# perform first passover (symbol to address translation + comment removal)
#-------------------------------------------------------------------------------------------------------------------------
with open(asm_filepath, 'r') as read_file:
    with open(temp1_filepath, 'w') as write_file:
        instruction_counter = 0
        symbol_table = {}
        for line in read_file:
            if instruction == "": continue
            instruction = re.sub(leading_trailing_whitespace + r"\|,", "", re.sub(whitespace, " ", re.sub(comments, "", line)))
            # manage function declarations
            instruction_words = re.match(symbol + ":")
            if instruction_words:
                instruction_words.split(r"\s", instruction)
                symbol = instruction_words[0][:-1]
                if symbol in symbol_table: 
                    raise Exception("Duplicate function declaration: " + symbol)
                symbol_table[symbol] = instruction_counter + 1
                continue
            write_file.write(instruction)
            # manage pseudo-instructions (a subset of pseudo-instructions assemble to two instructions rather than one)
            instruction_words = re.match(multiline_pseudoinstruction)
            if instruction_words != None:
                instruction_counter += 2
                continue
            instruction_counter += 1
#-------------------------------------------------------------------------------------------------------------------------
# perform second passover (deconstruct pseudo-instructions)
#-------------------------------------------------------------------------------------------------------------------------
with open(temp1_filepath, 'r') as read_file:
    with open(temp2_filepath, 'w') as write_file:
        for line in read_file:
            instruction_words = instruction.split(whitespace)
            if instruction_words[0] == "la":
                destination_register = instruction_words[1]
                symbol = instruction_words[2]
                upper_twenty_bits = str(bin(int(symbol)))[0:19]
                lower_twelve_bits = str(bin(int(symbol)))[20:31]
                write_file.write(f"auipc {destination_register} {upper_twenty_bits}\n")
                write_file.write(f"addi {destination_register} {lower_twelve_bits}({destination_register})\n")
            elif instruction_words[0] in ["lb", "lh", "lw", "ld"]:
                operator = instruction_words[0]
                destination_register = instruction_words[1]
                symbol = instruction_words[2]
                upper_twenty_bits = str(bin(int(symbol)))[0:19]
                lower_twelve_bits = str(bin(int(symbol)))[20:31]
                write_file.write(f"auipc {destination_register} {upper_twenty_bits}\n")
                write_file.write(f"{operator} {destination_register} {lower_twelve_bits}({destination_register})\n")
            elif instruction_words[0] in ["sb", "sh", "sw", "sd"]:
                operator = instruction_words[0]
                destination_register = instruction_words[1]
                symbol = instruction_words[2]
                address_register = instruction_words[3]
                upper_twenty_bits = str(bin(int(symbol)))[0:19]
                lower_twelve_bits = str(bin(int(symbol)))[20:31]
                write_file.write(f"auipc {address_register} {upper_twenty_bits}\n")
                write_file.write(f"{operator} {destination_register} {lower_twelve_bits}({address_register})\n")
            elif instruction_words[0] == "nop":
                write_file.write(f"addi zero, zero, 0\n")
            elif instruction_words[0] == "li":
                destination_register = instruction_words[1]
                immediate = instruction_words[2]
                upper_twenty_bits = str(bin(int(immediate)))[0:19]
                lower_twelve_bits = str(bin(int(immediate)))[20:31]
                write_file.write(f"lui {destination_register} {upper_twenty_bits}\n")
                write_file.write(f"addi {destination_register} {destination_register} {lower_twelve_bits}\n")
            elif instruction_words[0] == "mv":
                destination_register = instruction_words[1]
                source_register = instruction_words[2]
                write_file.write(f"addi {destination_register} {source_register} 0\n")
            elif instruction_words[0] == "not":
                destination_register = instruction_words[1]
                source_register = instruction_words[2]
                write_file.write(f"xori {destination_register} {source_register} -1\n")
            elif instruction_words[0] == "neg":
                destination_register = instruction_words[1]
                source_register = instruction_words[2]
                write_file.write(f"sub {destination_register} zero {source_register}\n")
            elif instruction_words[0] == "negw":
                destination_register = instruction_words[1]
                source_register = instruction_words[2]
                write_file.write(f"subw {destination_register} zero {source_register}\n")
            elif instruction_words[0] == "sext.w":
                destination_register = instruction_words[1]
                source_register = instruction_words[2]
                write_file.write(f"addiw {destination_register} {source_register} zero\n")
            elif instruction_words[0] == "seqz":
                destination_register = instruction_words[1]
                source_register = instruction_words[2]
                write_file.write(f"sltiu {destination_register} {source_register} 1\n")
            elif instruction_words[0] == "snez":
                destination_register = instruction_words[1]
                source_register = instruction_words[2]
                write_file.write(f"sltu {destination_register} zero {source_register}\n")
            elif instruction_words[0] == "sltz":
                destination_register = instruction_words[1]
                source_register = instruction_words[2]
                write_file.write(f"slt {destination_register} {source_register} zero\n")
            elif instruction_words[0] == "sgtz":
                destination_register = instruction_words[1]
                source_register = instruction_words[2]
                write_file.write(f"slt {destination_register} zero {source_register}\n")
            elif instruction_words[0] == "beqz":
                source_register = instruction_words[1]
                offset = instruction_words[2]
                write_file.write(f"beq {source_register} zero {offset}\n")
            elif instruction_words[0] == "bnez":
                source_register = instruction_words[1]
                offset = instruction_words[2]
                write_file.write(f"bne {source_register} zero {offset}\n")
            elif instruction_words[0] == "blez":
                source_register = instruction_words[1]
                offset = instruction_words[2]
                write_file.write(f"bge zero {source_register} {offset}\n")
            elif instruction_words[0] == "bgez":
                source_register = instruction_words[1]
                offset = instruction_words[2]
                write_file.write(f"bge {source_register} zero {offset}\n")
            elif instruction_words[0] == "bltz":
                source_register = instruction_words[1]
                offset = instruction_words[2]
                write_file.write(f"blt {source_register} zero {offset}\n")
            elif instruction_words[0] == "bgtz":
                source_register = instruction_words[1]
                offset = instruction_words[2]
                write_file.write(f"blt zero {source_register} {offset}\n")
            elif instruction_words[0] == "bgt":
                source_register1 = instruction_words[1]
                source_register2 = instruction_words[2]
                offset = instruction_words[3]
                write_file.write(f"blt {source_register2} {source_register1} {offset}\n")
            elif instruction_words[0] == "ble":
                source_register1 = instruction_words[1]
                source_register2 = instruction_words[2]
                offset = instruction_words[3]
                write_file.write(f"bge {source_register2} {source_register1} {offset}\n")
            elif instruction_words[0] == "bgtu":
                source_register1 = instruction_words[1]
                source_register2 = instruction_words[2]
                offset = instruction_words[3]
                write_file.write(f"bltu {source_register2} {source_register1} {offset}\n")
            elif instruction_words[0] == "bleu":
                source_register1 = instruction_words[1]
                source_register2 = instruction_words[2]
                offset = instruction_words[3]
                write_file.write(f"bgeu {source_register2} {source_register1} {offset}\n")
            elif instruction_words[0] == "j":
                offset = instruction_words[1]
                write_file.write(f"jal zero {offset}\n")
            elif instruction_words[0] == "jal":
                offset = instruction_words[1]
                write_file.write(f"jal ra {offset}\n")
            elif instruction_words[0] == "jr":
                source_register = instruction_words[1]
                write_file.write(f"jalr zero {source_register} 0\n")
            elif instruction_words[0] == "jalr":
                source_register = instruction_words[1]
                write_file.write(f"jalr ra {source_register} 0\n")
            elif instruction_words[0] == "ret":
                write_file.write("jalr zero ra 0\n")
            elif instruction_words[0] == "call":
                offset = instruction_words[1]
                upper_twenty_bits = str(bin(int(offset)))[0:19]
                lower_twelve_bits = str(bin(int(offset)))[20:31]
                write_file.write(f"auipc t0 {upper_twenty_bits}\n")
                write_file.write(f"jalr ra t0 {lower_twelve_bits}\n")
            elif instruction_words[0] == "tail":
                offset = instruction_words[1]
                upper_twenty_bits = str(bin(int(offset)))[0:19]
                lower_twelve_bits = str(bin(int(offset)))[20:31]
                write_file.write(f"auipc t0 {upper_twenty_bits}\n")
                write_file.write(f"jalr zero t0 {lower_twelve_bits}\n")
            elif instruction_words[0] == "tail":
                offset = instruction_words[1]
                upper_twenty_bits = str(bin(int(offset)))[0:19]
                lower_twelve_bits = str(bin(int(offset)))[20:31]
                write_file.write(f"auipc t0 {upper_twenty_bits}\n")
                write_file.write(f"jalr zero t0 {lower_twelve_bits}\n")
#-------------------------------------------------------------------------------------------------------------------------
# perform third passover (binary translation)
#-------------------------------------------------------------------------------------------------------------------------
with open(temp2_filepath, 'r') as read_file:
    with open(output_file, 'w') as write_file:
        write_file.write("memory_initialization_radix=2;\n")
        write_file.write("memory_initialization_vector=\n")
        for line in read_file:
            instruction_words = re.split(whitespace, line)
            operation = instruction_words[0]
            if operation in R_type:
                rd = instruction_words[1]
                rs = instruction_words[2]
                rt = instruction_words[3]
                binary_encoding = R_type_bits[operation]["funct7"] + registers[rt] + R_type_bits[operation]["funct3"] + registers[rs] + registers[rd] \
                    + opcodes[instruction_opcodes[operation]]
            elif operation in I_type:
                rd = instruction_words[1]
                rs = instruction_words[2]
                imm = instruction_words[3]
                if operation in ["SLLI", "SRLI", "SRAI"]:
                    binary_encoding = I_type_bits[operation]["funct7"] + str(bin(imm))[-6] + I_type_bits[operation]["funct3"] + registers[rs] \
                        + opcodes[instruction_opcodes[operation]]
                else:
                    binary_encoding = str(bin(imm))[-16:] + I_type_bits[operation]["funct3"] + registers[rs] + opcodes[instruction_opcodes[operation]]
            elif operation in S_type:
                rt = instruction_words[1]
                rs, offset = re.split(r"\s", re.sub(r"(\|)", " ", instruction_words[2]))
                offset = str(bin(offset))
                binary_encoding = str(bin(offset))[-11:-5] + registers[rt] + registers[rs] + S_type_bits[operation]["funct3"] + str(bin(offset))[-4:] \
                    + opcodes[instruction_opcodes[operation]]
            elif operation in B_type:
                rs = instruction_words[1]
                rt = instruction_words[2]
                offset = instruction_words[3]
                binary_encoding = str(bin(offset))[12] + str(bin(offset))[-10:-5] + registers[rt] + registers[rs] + B_type_bits[operation]["funct3"] \
                    + str(bin(offset))[-4:] + str(bin(offset))[11] + opcodes[instruction_opcodes[operation]]
            elif operation in U_type:
                rd = instruction_words[1]
                offset = str(bin(instruction_words[2]))[-20:]
                binary_encoding = offset + registers[rd] + opcodes[instruction_opcodes[operation]]
            elif operation in J_type:
                rd = instruction_words[1]
                offset = str(bin(instruction_words[2]))[-20:]
                binary_encoding = offset[-20] + offset[-10:] + offset[-11] + offset[-19:-12] + registers[rd] + opcodes[instruction_opcodes[operation]]
            if a_flag:
                write_file.write(f"{line} {binary_encoding}\n")
            else:
                write_file.write(bin(binary_encoding))