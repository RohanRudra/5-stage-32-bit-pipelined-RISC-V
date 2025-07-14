# 5-Stage 32-bit Pipelined MIPS Processor

## 📘 Overview
This project implements a **5-stage 32-bit pipelined MIPS processor**. The pipelined architecture improves instruction throughput by breaking down instruction execution into five sequential stages:

1. **Instruction Fetch (IF)**: Fetches the instruction from instruction memory.
2. **Instruction Decode (ID)**: Decodes the instruction and reads operands from the register file.
3. **Execute (EX)**: Performs arithmetic or logic operations using the ALU.
4. **Memory Access (MEM)**: Reads from or writes to data memory for load/store instructions.
5. **Write Back (WB)**: Writes computation or memory results back to the register file.

This processor supports a basic subset of the **MIPS ISA**, making it suitable for understanding pipelining concepts and CPU architecture.

---

## 🚀 Features

- ✅ **32-bit Processor**: All data paths and instructions operate on 32-bit data.
- ✅ **5-Stage Pipeline**: Implements IF, ID, EX, MEM, and WB stages.
- ✅ **Hazard Detection & Forwarding**:
  - Implements **data forwarding** to resolve data hazards.
  - Detects and handles **control hazards** for branch instructions.
- ✅ **Separate Instruction and Data Memory**: Harvard architecture.
- ✅ **MIPS Instruction Support**:
  - Arithmetic: `add`, `sub`
  - Logical: `and`, `or`
  - Memory: `lw`, `sw`
  - Branch: `beq`

---

## 📍 Architecture Flow Diagram

![Architecture Diagram](https://github.com/RohanRudra/RISC-V-Pipelined/blob/master/Flow%20Diagram.png)





