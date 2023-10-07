import regex

OP_operators = r"ADD|SUB|XOR|OR|AND|SLL|SRL|SRA|SLT|SLTU" # R-formatted
OP_32_operators = r"ADDW|SUBW|SLLW|SRLW|SRAW" # R-formatted
OP_IMM_operators = r"ADDI|SUBI|XORI|ORI|ANDI|SLLI|SRLI|SRAI|SLTI|SLTIU" # I-formatted
OP_IMM_32_operators = r"ADDIW|SUBIW|SLLIW|SRLIW|SRAIW" # I-formatted
LOAD_operators = r"LB|LH|LW|LBU|LHU|LD|LWU" # I-formatted
STORE_operators = r"SB|SH|SW|SD" # S-formatted








