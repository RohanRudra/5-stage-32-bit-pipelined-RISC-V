module HazardDetectUnit(clk, rst, ID_EX_MemR, ID_EX_RegRd, IF_ID_RegRs1, IF_ID_RegRs2, block_control, PC_Write, IF_ID_Write, ID_EX_Write);
    input clk, rst, ID_EX_MemR;
    input [4:0] ID_EX_RegRd, IF_ID_RegRs1, IF_ID_RegRs2;
    output reg block_control, PC_Write, IF_ID_Write, ID_EX_Write;

    reg stall; // internal state flag

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stall <= 0;
            {block_control, PC_Write, IF_ID_Write, ID_EX_Write} <= 4'b0111;
        end else if (!stall && ID_EX_MemR && ((ID_EX_RegRd == IF_ID_RegRs1) || (ID_EX_RegRd == IF_ID_RegRs2))) begin
            stall <= 1;
            {block_control, PC_Write, IF_ID_Write, ID_EX_Write} <= 4'b1000;
        end else begin
            stall <= 0;
            {block_control, PC_Write, IF_ID_Write, ID_EX_Write} <= 4'b0111;
        end
    end

endmodule