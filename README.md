# LiM-Virtual-Platform

LiM-Virtual-Platform is a project I undertook in the attempt to familiarise myself with the many levels of abstraction that modern computer science entails. 
The project involved writing and synthesising a RISC-V compliant architecture (R64I) to an FPGA development board using vhdl, and creating an accompanying 
assembler written in python. The project can be used as reference material to any hobbyist wanting to build their own virtual machine from scratch.  
The base project has plenty of room for extension:  
- Control and Status Register Instructions, Interrupts
- RiSC-V "M" Standard Extension for Integer Multiplication and Division (evolve design to that of multi-cycle or pipelined processor)
- RiSC-V "F"/"D" Standard Extension for Single-Precision/Double-Precision Floating-Point
- Ethernet MMIO and network stack
- Functional Compiler, Linker and File System
- Multithreading and Process Management
