//module BranchDecision (
//    input rs1_sign,
//    input rs2_sign,
//    input [31:0] ALU_Result,
//    input [2:0] funct3,      // to identify branch type
//    output reg take_branch
//);

//    always @(*) begin
       
//        case (funct3)
//            3'b000: take_branch = (ALU_Result == 0);   // BEQ
//            3'b001: take_branch = (ALU_Result != 0);   // BNE
//            3'b100: take_branch = (ALU_Result[31] == 1); // BLT (signed < 0)
//            3'b101: take_branch = (ALU_Result[31] == 0 && ALU_Result != 0); // BGE
//            3'b110: take_branch = (rs1_sign == 0 && rs2_sign == 1) || 
//                                    (ALU_Result[31] == 1); // BLTU (unsigned)
//            3'b111: take_branch = (rs1_sign == 1 && rs2_sign == 0) || 
//                                    (ALU_Result[31] == 0 && ALU_Result != 0); // BGEU
//            default: take_branch = 0;
//        endcase
//    end
//endmodule


module BranchDecision (
    input rs1_sign,
    input rs2_sign,
    input [31:0] ALU_Result,
    input [2:0] funct3,      // to identify branch type
    output take_branch
);

    assign take_branch = (funct3 == 3'b000) ? (ALU_Result === 0) :                     // BEQ
                         (funct3 == 3'b001) ? (ALU_Result !== 0) :                     // BNE
                         (funct3 == 3'b100) ? (ALU_Result[31] === 1) :                 // BLT (signed < 0)
                         (funct3 == 3'b101) ? (ALU_Result[31] === 0 && ALU_Result !== 0): // BGE
                         (funct3 == 3'b110) ? ((rs1_sign == 0 && rs2_sign == 1) || (ALU_Result[31] === 1)) :              // BLTU
                         (funct3 == 3'b111) ? ((rs1_sign == 1 && rs2_sign == 0) || (ALU_Result[31] === 0 && ALU_Result !== 0)) : // BGEU
                         1'b0;                                                        // default

endmodule

