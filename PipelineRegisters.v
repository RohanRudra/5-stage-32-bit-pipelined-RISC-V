module IF_ID(clk, reset, PC, instr, PC_out, instr_out);
    input clk,reset;
    input [31:0] PC,instr;
    output reg [31:0] PC_out, instr_out;

    always@(posedge clk or posedge reset) begin
        if(reset) begin
            PC_out <= 32'd0;
            instr_out <= 32'd0;
        end
        else begin
            PC_out <= PC;
            instr_out <= instr;
        end
    end
endmodule


module ID_EX(clk, reset, fun7, fun3, RegW, MemtoReg, MemW, MemR, Branch, ALUOp, ALUSrc, A, B, IF_ID_Imm, IF_ID_RegRs1, IF_ID_RegRs2, IF_ID_RegRd, 
    fun7_o, fun3_o,RegW_o, MemtoReg_o, MemW_o, MemR_o, Branch_o, ALUOp_o, ALUSrc_o, A_o, B_o, ID_EX_Imm, ID_EX_RegRs1, ID_EX_RegRs2, ID_EX_RegRd);
    
    input clk, reset, fun7, RegW, MemtoReg, MemW, MemR, Branch, ALUSrc;
    input [2:0] fun3;
    input [1:0] ALUOp;
    input [31:0] A,B, IF_ID_Imm;
    input [4:0] IF_ID_RegRs1, IF_ID_RegRs2, IF_ID_RegRd;
    output reg RegW_o, MemtoReg_o, MemW_o, MemR_o, Branch_o, ALUSrc_o, fun7_o;
    output reg [2:0] fun3_o;
    output reg [1:0] ALUOp_o;
    output reg [31:0] A_o,B_o, ID_EX_Imm;
    output reg [4:0] ID_EX_RegRs1, ID_EX_RegRs2, ID_EX_RegRd;

    always@(posedge clk or posedge reset) begin
        if(reset) begin
            {RegW_o, MemtoReg_o, MemW_o, MemR_o, Branch_o, ALUSrc_o, ALUOp_o, fun7_o, fun3_o, A_o, B_o, ID_EX_Imm, ID_EX_RegRs1, ID_EX_RegRs2, ID_EX_RegRd} 
                <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'd0, 1'b0, 3'd0, 32'd0, 32'd0, 32'd0, 5'd0, 5'd0, 5'd0};
        end
        else begin
            {RegW_o, MemtoReg_o, MemW_o, MemR_o, Branch_o, ALUSrc_o, ALUOp_o, fun7_o, fun3_o, A_o, B_o, ID_EX_Imm, ID_EX_RegRs1, ID_EX_RegRs2, ID_EX_RegRd} 
                <= {RegW, MemtoReg, MemW, MemR, Branch, ALUSrc, ALUOp, fun7, fun3, A, B, IF_ID_Imm, IF_ID_RegRs1, IF_ID_RegRs2, IF_ID_RegRd};
        end
    end

endmodule


module EX_MEM(clk, reset, RegW, MemtoReg, MemW, MemR, Branch, ALUResult, MemWrData, ID_EX_RegRd, RegW_o, MemtoReg_o, MemW_o, MemR_o, Branch_o, ALUResult_o, MemWrData_o, EX_MEM_RegRd);
    input clk, reset, RegW, MemtoReg, MemW, MemR, Branch;
    input [31:0] ALUResult, MemWrData;
    input [4:0] ID_EX_RegRd;
    output reg RegW_o, MemtoReg_o, MemW_o, MemR_o, Branch_o;
    output reg [31:0] ALUResult_o, MemWrData_o;
    output reg [4:0] EX_MEM_RegRd;

    always@(posedge clk or posedge reset) begin
        if(reset) begin
            {RegW_o, MemtoReg_o, MemW_o, MemR_o, Branch_o, ALUResult_o, MemWrData_o, EX_MEM_RegRd} 
                <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 32'd0, 32'd0, 5'd0};
        end
        else begin
            {RegW_o, MemtoReg_o, MemW_o, MemR_o, Branch_o, ALUResult_o, MemWrData_o, EX_MEM_RegRd} 
                <= {RegW, MemtoReg, MemW, MemR, Branch, ALUResult, MemWrData, ID_EX_RegRd};            
        end
    end

endmodule


module MEM_WB(clk, reset, RegW, MemtoReg, RdData, RegWrData, EX_MEM_RegRd, RegW_o, MemtoReg_o, RdData_o, RegWrData_o, MEM_WB_RegRd);
    input clk, reset, RegW, MemtoReg;
    input [31:0] RdData, RegWrData;
    input [4:0] EX_MEM_RegRd;
    output reg RegW_o, MemtoReg_o;
    output reg [31:0] RdData_o, RegWrData_o;
    output reg [4:0] MEM_WB_RegRd;

    always@(posedge clk or posedge reset) begin
        if(reset) begin
            {RegW_o, MemtoReg_o, RdData_o, RegWrData_o, MEM_WB_RegRd} <= {1'b0, 1'b0, 32'd0, 32'd0, 5'd0};
        end
        else begin
            {RegW_o, MemtoReg_o, RdData_o, RegWrData_o, MEM_WB_RegRd} <= {RegW, MemtoReg, RdData, RegWrData, EX_MEM_RegRd};
        end
    end 
endmodule