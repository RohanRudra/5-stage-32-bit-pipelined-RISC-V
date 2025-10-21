module IF_ID(clk, reset, flush, PC, PCP4, instr, PC_out, instr_out, PCP4_out, IF_ID_Write);
    input clk, reset, flush, IF_ID_Write;
    input [31:0] PC,PCP4,instr;
    output reg [31:0] PC_out, instr_out, PCP4_out;

    always@(posedge clk or posedge reset) begin
        if (IF_ID_Write) begin
            if(reset || flush) begin
                PC_out <= 32'd0;
                instr_out <= 32'd0;
                PCP4_out <= 32'd0;
            end
            else begin
                PC_out <= PC;
                instr_out <= instr;
                PCP4_out <= PCP4;
            end
        end
    end
endmodule


module ID_EX(clk, reset, flush, PC, PCP4, fun7, fun3, RegW, MemtoReg, MemW, MemR, Branch, Jump, Opcode, ALUOp, ALUSrc, A, B, IF_ID_Imm, IF_ID_RegRs1, IF_ID_RegRs2, IF_ID_RegRd, 
    PC_out, PCP4_out, fun7_o, fun3_o, RegW_o, MemtoReg_o, MemW_o, MemR_o, Branch_o, Jump_o, Opcode_o, ALUOp_o, ALUSrc_o, A_o, B_o, ID_EX_Imm, ID_EX_RegRs1, ID_EX_RegRs2, ID_EX_RegRd, ID_EX_Write);
    
    input clk, reset, flush, fun7, RegW, MemtoReg, MemW, MemR, Branch, Jump, ALUSrc, ID_EX_Write;
    input [2:0] fun3;
    input [1:0] ALUOp;
    input [6:0] Opcode;
    input [31:0] A,B, IF_ID_Imm, PC, PCP4;
    input [4:0] IF_ID_RegRs1, IF_ID_RegRs2, IF_ID_RegRd;
    output reg RegW_o, MemtoReg_o, MemW_o, MemR_o, Branch_o, Jump_o, ALUSrc_o, fun7_o;
    output reg [2:0] fun3_o;
    output reg [1:0] ALUOp_o;
    output reg [6:0] Opcode_o;
    output reg [31:0] A_o,B_o, ID_EX_Imm, PC_out, PCP4_out;
    output reg [4:0] ID_EX_RegRs1, ID_EX_RegRs2, ID_EX_RegRd;

    always@(posedge clk or posedge reset) begin
        if (ID_EX_Write) begin
            if(reset || flush) begin
                {RegW_o, MemtoReg_o, MemW_o, MemR_o, Branch_o, Jump_o, ALUSrc_o, ALUOp_o, Opcode_o, fun7_o, fun3_o, A_o, B_o, ID_EX_Imm, PC_out, PCP4_out, ID_EX_RegRs1, ID_EX_RegRs2, ID_EX_RegRd} 
                    <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'd0, 7'd0, 1'b0, 3'd0, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0, 5'd0, 5'd0, 5'd0};
            end
            else begin
                {RegW_o, MemtoReg_o, MemW_o, MemR_o, Branch_o, Jump_o, ALUSrc_o, ALUOp_o, Opcode_o, fun7_o, fun3_o, A_o, B_o, ID_EX_Imm, PC_out, PCP4_out, ID_EX_RegRs1, ID_EX_RegRs2, ID_EX_RegRd} 
                    <= {RegW, MemtoReg, MemW, MemR, Branch, Jump, ALUSrc, ALUOp, Opcode, fun7, fun3, A, B, IF_ID_Imm, PC, PCP4, IF_ID_RegRs1, IF_ID_RegRs2, IF_ID_RegRd};
            end
        end
    end

endmodule


module EX_MEM(clk, reset, PCP4, RegW, MemtoReg, MemW, MemR, Branch, Jump, ALUResult, MemWrData, ID_EX_RegRd, PCP4_o, RegW_o, MemtoReg_o, MemW_o, MemR_o, Branch_o, Jump_o, ALUResult_o, MemWrData_o, EX_MEM_RegRd);
    input clk, reset, RegW, MemtoReg, MemW, MemR, Branch, Jump;
    input [31:0] ALUResult, MemWrData, PCP4;
    input [4:0] ID_EX_RegRd;
    output reg RegW_o, MemtoReg_o, MemW_o, MemR_o, Branch_o, Jump_o;
    output reg [31:0] ALUResult_o, MemWrData_o, PCP4_o;
    output reg [4:0] EX_MEM_RegRd;

    always@(posedge clk or posedge reset) begin
        if(reset) begin
            {PCP4_o, RegW_o, MemtoReg_o, MemW_o, MemR_o, Branch_o, Jump_o, ALUResult_o, MemWrData_o, EX_MEM_RegRd} 
                <= {32'd0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 32'd0, 32'd0, 5'd0};
        end
        else begin
            {PCP4_o, RegW_o, MemtoReg_o, MemW_o, MemR_o, Branch_o, Jump_o, ALUResult_o, MemWrData_o, EX_MEM_RegRd} 
                <= {PCP4, RegW, MemtoReg, MemW, MemR, Branch, Jump, ALUResult, MemWrData, ID_EX_RegRd};            
        end
    end

endmodule


module MEM_WB(clk, reset, PCP4, RegW, MemtoReg, MemR, Jump, RdData, RegWrData, EX_MEM_RegRd, PCP4_o, RegW_o, MemtoReg_o, MemR_o, Jump_o, RdData_o, RegWrData_o, MEM_WB_RegRd);
    input clk, reset, RegW, MemtoReg, Jump, MemR;
    input [31:0] RdData, RegWrData, PCP4;
    input [4:0] EX_MEM_RegRd;
    output reg RegW_o, MemtoReg_o, Jump_o, MemR_o;
    output reg [31:0] RdData_o, RegWrData_o, PCP4_o;
    output reg [4:0] MEM_WB_RegRd;

    always@(posedge clk or posedge reset) begin
        if(reset) begin
            {PCP4_o, RegW_o, MemtoReg_o, Jump_o, MemR_o, RdData_o, RegWrData_o, MEM_WB_RegRd} <= {32'd0, 1'b0, 1'b0, 1'b0, 1'b0, 32'd0, 32'd0, 5'd0};
        end
        else begin
            {PCP4_o, RegW_o, MemtoReg_o, Jump_o, MemR_o, RdData_o, RegWrData_o, MEM_WB_RegRd} <= {PCP4, RegW, MemtoReg, Jump, MemR, RdData, RegWrData, EX_MEM_RegRd};
        end
    end 
endmodule