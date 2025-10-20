// module ImmGen(Opcode, instruction, ImmOutput);
//     input [31:0] instruction;
//     input [6:0] Opcode;
//     output reg [31:0] ImmOutput;
//     //Here actually immediate should be 12 bit but we are extending it to 32 bits

//     always @(*) begin
//         case (Opcode)
//             7'b0000011, 7'b0010011, : ImmOutput <= {{20{instruction[31]}}, instruction[31:20]}; // lw                                   
//             7'b0100011: ImmOutput <= {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; //sw 
//             7'b1100011: ImmOutput <= {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; //SB-Type
//            : ImmOutput <= {{20{instruction[31]}}, instruction[31:20]}; //addi / ori
//             7'b1100011: ImmOutput <= {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
//             7'b1101111: ImmOutput <= {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};  //J-Type

//         endcase
//     end

// endmodule


module ImmGen(
    input [31:0] instruction,
    input [6:0] Opcode,
    output reg [31:0] ImmOutput
);
    always @(*) begin
        case (Opcode)
            // I-type: lw, addi, ori, jalr
            7'b0000011, // lw
            7'b0010011, // addi / ori / andi / etc
            7'b1100111: // jalr
                ImmOutput <= {{20{instruction[31]}}, instruction[31:20]};

            // S-type: sw, sb, sh
            7'b0100011:
                ImmOutput <= {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

            // SB-type: BEQ, BNE, BLT, BGE, BLTU, BGEU
            7'b1100011:
                ImmOutput <= {{19{instruction[31]}}, instruction[31], instruction[7],
                              instruction[30:25], instruction[11:8], 1'b0};

            // U-type: LUI, AUIPC
            7'b0110111, // LUI
            7'b0010111: // AUIPC
                ImmOutput <= {instruction[31:12], 12'b0};

            // J-type: JAL
            7'b1101111:
                ImmOutput <= {{11{instruction[31]}}, instruction[31], instruction[19:12],
                              instruction[20], instruction[30:21], 1'b0};

            default:
                ImmOutput <= 32'b0;
        endcase
    end
endmodule
