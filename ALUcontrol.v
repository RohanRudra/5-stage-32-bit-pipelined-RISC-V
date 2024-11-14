module ALU_Control(fun7, fun3, ALUOp, control_out);
    input fun7; //I[30]
    input [2:0] fun3;  //I[14:12]
    input [1:0] ALUOp;
    output reg [3:0] control_out; //This o/p goes to ALU unit to select the specified operation

    always @(*) begin
        casez ({ALUOp, fun7, fun3})
            6'b01_0_000: control_out <= 4'b0110;
            6'b10_0_000: control_out <= 4'b0010;
            6'b10_1_000: control_out <= 4'b0110;
            6'b10_0_111: control_out <= 4'b0000;
            6'b10_0_110: control_out <= 4'b0001;
            6'b00_0_???: control_out <= 4'b0010; //for lw and sw (fun3 is dont care)
        endcase
    end

endmodule