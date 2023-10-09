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
multiline_pseudoinstruction = r"^\s*(ret\|call\|tail\|la\|(l[bhwd]\s+" + core_register + r",\s+[a-zA-Z0-9_]{3,}))\s*$"

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
                write_file.write("auipc " + destination_register + " " + upper_twenty_bits + "\n")
                write_file.write("addi " + destination_register + " " + destination_register + " " + lower_twelve_bits + "\n")
            elif instruction_words[0] == "lb":
                



# second passover: decompose pseudo-instructions and remove comments
with open(os.getcwd() + "/Assembler/" + sys.argv[1], 'r') as read_file:
    with open(os.getcwd() + "/Assembler/" + sys.argv[1][-2] + "_1.temp", 'w') as write_file:
        for line in read_file:
            instruction = remove_comments(line)
            if instruction != "": continue
            # decompose pseudoinstructions
            instruction_match = re.match(r"^\s*la\s*" + core_register + symbol_expression, instruction)
            if instruction_match != None:
                instruction_words = re.split(r"\s+", instruction_match)
                rd = instruction_words[1]
                symbol = instruction_match[2]
                write_file.write("auipc " + rd + ", " + symbol + "\n")
                write_file.write("addi " + rd + ", " + rd + ", " + symbol + "\n")






# third passover: assemble into binary instructions
