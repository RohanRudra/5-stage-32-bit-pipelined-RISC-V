module ALU_Control(
    input       fun7,          // I[30] only for R-type/SRA/SUB
    input [2:0] fun3,          // I[14:12]
    input [1:0] ALUOp,         // from main control unit
    output reg [3:0] control_out
);

    always @(*) begin
        casez ({ALUOp, fun7, fun3})
            // ------------------------
            // R-type (ALUOp = 10)
            // ------------------------
            6'b10_0_000: control_out = 4'b0010; // ADD
            6'b10_1_000: control_out = 4'b0110; // SUB
            6'b10_0_111: control_out = 4'b0000; // AND
            6'b10_0_110: control_out = 4'b0001; // OR
            6'b10_0_001: control_out = 4'b1000; // SLL
            6'b10_0_101: control_out = 4'b1001; // SRL
            6'b10_1_101: control_out = 4'b1010; // SRA

            // ------------------------
            // I-type (ADDI, ANDI, ORI, shift immediates)
            // ALUOp = 10 but funct7 ignored except for SRLI/SRAI
            // ------------------------
            6'b10_?_000: control_out = 4'b0010; // ADDI
            6'b10_?_111: control_out = 4'b0000; // ANDI
            6'b10_?_110: control_out = 4'b0001; // ORI
            6'b10_?_001: control_out = 4'b1000; // SLLI
            6'b10_0_101: control_out = 4'b1001; // SRLI
            6'b10_1_101: control_out = 4'b1010; // SRAI

            // ------------------------
            // Load / Store / JALR
            // ------------------------
            6'b00_?_???: control_out = 4'b0010; // ADD for address

            // ------------------------
            // Branch (BEQ etc.)
            // ------------------------
            6'b01_?_???: control_out = 4'b0110; // SUB

            // ------------------------
            // Default
            // ------------------------
            default: control_out = 4'b1111;
        endcase
    end

endmodule
