import re
import sys
import os

OP_operator = r"ADD\|SUB\|XOR\|OR\|AND\|SLL\|SRL\|SRA\|SLT\|SLTU" # R-formatted
OP_32_operator = r"ADDW\|SUBW\|SLLW\|SRLW\|SRAW" # R-formatted
OP_IMM_operator = r"ADDI\|SUBI\|XORI\|ORI\|ANDI\|SLLI\|SRLI\|SRAI\|SLTI\|SLTIU" # I-formatted
OP_IMM_32_operator = r"ADDIW\|SUBIW\|SLLIW\|SRLIW\|SRAIW" # I-formatted
LOAD_operator = r"LB\|LH\|LW\|LBU\|LHU\|LD\|LWU" # I-formatted
STORE_operator = r"SB\|SH\|SW\|SD" # S-formatted
core_register = r"(zero\|ra\|sp\|gp\|tp\|t[0-6]\|fp\|s[0-11]\|a[0-7])"
symbol_expression = r"[a-zA-Z0-9_]+"
multiline_pseudoinstruction = r"^\s*(ret\|call\|tail\|la\|li\|(l[bhwd]\s+" + core_register + r",\s+[a-zA-Z0-9_]{3,}))\s*$"

core_register_map = {
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

def remove_comments(line):
    return re.sub(r"((--)\|#).*", "", line)

# first passover: symbol to address translation + comment removal
with open(os.getcwd() + "/Assembler/" + sys.argv[1], 'r') as read_file:
    with open(os.getcwd() + "/Assembler/" + sys.argv[1][-2] + "_1.temp", 'w') as write_file:
        instruction_counter = 0
        symbol_map = {} # symbol-address map
        for line in read_file:
            if instruction == "": continue
            instruction = re.sub(r"^\s+\|\s+$\|,", r"", re.sub(r"\s+", " ", remove_comments(line))) # remove leading/trailing/excess whitespace + commas
            # manage function declarations
            instruction_words = re.match(symbol + ":")
            if instruction_words:
                instruction_words.split(r"\s", instruction)
                symbol = instruction_words[0][:-1]
                if symbol in symbol_map: 
                    raise Exception("Duplicate function declaration: " + symbol)
                symbol_map[symbol] = instruction_counter + 1
                continue
            write_file.write(instruction)
            # manage pseudo-instructions (a subset of pseudo-instructions assemble to two instructions rather than one)
            instruction_words = re.match(multiline_pseudoinstruction)
            if instruction_words != None:
                instruction_counter += 2
                continue
            instruction_counter += 1

# second passover: deconstruct pseudo-instructions
with open(os.getcwd() + "/Assembler/" + sys.argv[1][-2] + "_1.temp", 'r') as read_file:
    with open(os.getcwd() + "/Assembler/" + sys.argv[1][-2] + "_2.temp", 'w') as write_file:
        for line in read_file:
            instruction_words = instruction.split(r" ")
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




# third passover: binary translation
