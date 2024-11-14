module Control(instruction, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
    input [6:0] instruction;
    output wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    output wire [1:0] ALUOp;

    assign {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} =
        (instruction == 7'b0110011) ? 8'b001000_10 : // R-format
        (instruction == 7'b0000011) ? 8'b111100_00 : // lw
        (instruction == 7'b0100011) ? 8'b100010_00 : // sw
        (instruction == 7'b1100011) ? 8'b000001_01 : // beq
        (instruction == 7'b0010011) ? 8'b101000_10 : // addi & ori
        8'b000000_00; // Default - Do nothing

endmodule