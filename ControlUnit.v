module Control(instruction, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, block_control);
    input [6:0] instruction;
    input block_control;
    output wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, Jump;
    output wire [1:0] ALUOp;

    assign {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUOp} =
        block_control ? 8'b000000_00 : // stall condition
        (instruction == 7'b0110011) ? 9'b0010000_10 : // R-format (ADD, SUB, AND, OR, SLL, SRL, SRA)
        (instruction == 7'b0000011) ? 9'b1111000_00 : // lw
        (instruction == 7'b0100011) ? 9'b1000100_00 : // sw
        (instruction == 7'b1100011) ? 9'b0000010_01 : // SB-format (BEQ etc.)
        (instruction == 7'b0010011) ? 9'b1010000_10 : // I-format (ADDI, ORI, ANDI, SLLI, SRLI, SRAI)
        (instruction == 7'b1101111) ? 9'b0010001_11 : // JAL
        (instruction == 7'b1100111) ? 9'b1010001_00 : // JALR
        8'b000000_00; // Default - Do nothing

endmodule
