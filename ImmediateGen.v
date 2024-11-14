module ImmGen(Opcode, instruction, ImmOutput);
    input [31:0] instruction;
    input [6:0] Opcode;
    output reg [31:0] ImmOutput;
    //Here actually immediate should be 12 bit but we are extending it to 32 bits

    always @(*) begin
        case (Opcode)
            7'b0000011: ImmOutput <= {{20{instruction[31]}}, instruction[31:20]}; // lw                                   
            7'b0100011: ImmOutput <= {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; //sw 
            7'b1100011: ImmOutput <= {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; //SB-Type
            7'b0010011: ImmOutput <= {{20{instruction[31]}}, instruction[31:20]}; //addi / ori
        endcase
    end

endmodule