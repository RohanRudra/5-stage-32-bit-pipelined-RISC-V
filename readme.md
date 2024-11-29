# 5-Stage RISC-V 32-bit Pipelined Processor

## Overview
This project implements a **5-stage 32-bit Pipelined RISC-V processor**. The pipeline architecture is designed to increase instruction throughput by dividing the instruction execution process into five distinct stages:
1. **Instruction Fetch (IF)**: Fetches the instruction from the instruction memory.
2. **Instruction Decode (ID)**: Decodes the instruction and reads register operands.
3. **Execute (EX)**: Performs arithmetic or logical operations in the ALU.
4. **Memory Access (MEM)**: Accesses data memory for load or store operations.
5. **Write Back (WB)**: Writes the result back to the register file.

The processor is compliant with the RISC-V ISA, supporting arithmetic, logical, memory, and control-flow instructions.

---

## 🚀 Features
- **32-bit Processor**: Fully implements a 32-bit data.
- **5-Stage Pipelining**: Pipeline stages include IF, ID, EX, MEM, and WB.
- **Data Forwarding and Hazard Detection**:
  - Implements forwarding to resolve data hazards.
  - Includes control hazard handling for branch instructions.
- **Instruction and Data Memory**: Separate memory modules for instructions and data.
- **RISC-V Base ISA Support**: 
  - Arithmetic instructions: `add`, `sub`
  - Logical instructions: `and`, `or`
  - Memory instructions: `lw`, `sw`
  - Branch instructions: `beq`

---

## 📍 Architecture Flow Diagram
<img src="https://github.com/RohanRudra/RISC-V-Pipelined/blob/master/Flow%20Diagram.png"/>


---


