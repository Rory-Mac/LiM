# LiM-Virtual-Platform

LiM-Virtual-Platform is a project I undertook to become more familiar with the many levels of abstraction that comprise computer science and digital technology. The
project involved constructing and synthesising a RISC-V compliant hardware architecture (R64I) to an FPGA development board using vhdl and the vivado software suite,
as well as an accompanying assembler in python. LiM-Virtual-Platform can be used as reference material to any hobbyists wanting to build their own virtual machines from
scratch. The ideas I have for extending the project are numerous and include
- Ethernet MMIO for video graphics and keypresses, with accompanying control/status registers and interrupt handling
- use of external memory module to act as 32-bit RAM (current project utilises onboard BRAM with 16-bit byte-addressing)
- RiSC-V "M" Standard Extension for Integer Multiplication and Division (evolve single-cycle processor to multi-cycle or pipelined processor)
- RiSC-V "F"/"D" Standard Extension for Single-Precision/Double-Precision Floating-Point
- Create Functional Compiler, Linker and File System
- Multithreading and Process Management
- Evolve assembler/compiler to self-assembler/self-compiler
