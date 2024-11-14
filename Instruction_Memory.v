module Instruction_Memory(clk, reset, pc, instr);
    input clk,reset;
    input [31:0] pc; //this will tell the position of instruction in the memory
    output [31:0] instr;
    
    reg [31:0] I_memory [63:0];

    initial begin
        $readmemb("C:/Users/Rohan/Desktop/verilog codes/RISC-V Pipelined Implementation/instrMem_init.mem", I_memory, 0, 52); // Specify range 0 to 63
        //R-Type
        // I_memory[0] <= 32'b0000000_11001_10000_000_01101_0110011; //add x13, x16, x25
        // I_memory[4] <= 32'b0100000_00011_01000_000_00101_0110011; //sub x5, x8, x3
        // I_memory[8] <= 32'b0000000_00011_00010_111_00001_0110011; //and x1, x2, x3
        // I_memory[12] <= 32'b0000000_00101_00011_110_00100_0110011; //or x4, x3, x5

        //I-Type
        // I_memory[16] <= 32'b000000000011_10101_000_10110_0010011; //addi x22, x21, 3
        // I_memory[20] <= 32'b000000000001_01000_110_01001_0010011; //ori ,x9, x8, 1

        //L-Type //here funct3 is don't care (so putting 000)
        // I_memory[24] <= 32'b000000000101_00101_000_01000_0000011; //lw x8, 5(x5)   
        // I_memory[28] <= 32'b000000000100_00011_000_01001_0000011; //lw x9, 4(x3)

        //S-Type //here funct3 is don't care (so putting 010)
        // I_memory[32] <= 32'b0000000_10000_11010_010_01100_0100011; //sw x16, 12(x26)
        // I_memory[36] <= 32'b0000000_01110_00110_010_01010_0100011; //sw x14, 10(x6)

        //SB-Type
        // I_memory[40] <= 32'b0000000_01001_01001_000_01100_1100011; //beq x9, x9, 12 
        //branching - if both the reg content is equal then it will go to target address (I_memory[40 + 12])

        // I_memory[52] <= 32'b0000000_11001_10000_000_01101_0110011; //add x13, x16, x25
    end

    assign instr = I_memory[pc];

endmodule