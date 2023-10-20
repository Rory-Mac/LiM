# LiM-Virtual-Platform

LiM-Virtual-Platform is a project I undertook to become more familiar with the many levels of abstraction that comprise computer science and digital technology. The
project involved constructing and synthesising a RISC-V compliant hardware architecture (R64I) to an FPGA development board using VHDL and the vivado software suite,
as well as an assembler written in python, and a compiler written in Haskell. This repo can be used as reference material to any other hobbyists wishing to build their own 
virtual machines from the ground up. Room for project extension includes,
- use of Vivado's MIG Wizard to create AXI interface between fabric logic and onboard DDRL3 Memory (64KB -> 256MB available memory + cleaner 32-bit addressing)
- use of AXI/Ethernet interface for simple RTL between fabric logic and host OS, foremost application would be simple video graphics and keypress IO
- control/status registers, interrupt handling and address decoder circuitry
- RiSC-V "M" Standard Extension for Integer Multiplication and Division (evolve single-cycle processor to multi-cycle or pipelined processor)
- RiSC-V "F"/"D" Standard Extension for Single-Precision/Double-Precision Floating-Point
- add Linker and File System
- add simple OS for multithreading and process management, use bootROM in place of BRAM initialisation