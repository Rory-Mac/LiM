##### System Calls

The SYSTEM opcode used to interact with the kernel's system call interface is very simple. The opcode stores no
information in the bitfields themselves. Instead, the caller loads a digit encoding the type of ecall into
the a0 register and additional arguments into the a1-a7 registers (if necessary). The SYSTEM opcode acts as
an unconditional jump to the hard-coded address of the kernel IO handler. System calls can be made with the
'ecall' assembly instruction which clobbers the return address register (ra/x1). The a0-ecall encodings are 
specified below.

| a0         | encoded ecall      |
|------------|--------------------|
| 1          | read int into a0   |
| 2          | print int from a1  |
| 3          | read char into a0  |
| 4          | print char from a1 |

Segmentation of physical memory is expected to be changed to make use of onboard DDR3L memory in the 
near-future with 32-bit addressing. At present, BRAM is used with 32-bit addressing, though only
2^17 bits worth of memory registers are addressed on the current architecture.

| address                  | decimal                  | segment                  |
|--------------------------|--------------------------|--------------------------|
| 0x00000000 - 0x0000FFCF  | 0-63487                  | application memory       |
| 0x0000FFCF - 0x0000FFFF  | 63487-65535 (2048)       | kernel memory            |
| 0x0000FFFF - 0x0000FFFFF | 65536-131071             | MMIO                     |

##### Assembler Flags and Assumptions

Assembly files are stored in "/Assembler/assembly_files" with the '.s' standard extension.
The optional '-a' flag will tell the assembler to create an analysis file for debugging 
purposes in place of an executable.