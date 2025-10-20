`include "ALUcontrol.v"
`include "ALUunit.v"
`include "ControlUnit.v"
`include "Data_Memory.v"
`include "Forward_Unit.v"
`include "ImmediateGen.v"
`include "Instruction_Memory.v"
`include "Mux_Adder.v"
`include "PipelineRegisters.v"
`include "Program_Counter.v"
`include "Registers.v"
`include "HazardDetectUnit.v"
`include "branch_decision.v"

module top(clk, reset);
    input clk, reset; 
    wire jalr_cond;
    wire [31:0] PCplus4_t, PC_in_t, PC_out_t, instr_t, IF_ID_PC, IF_ID_instr, IF_ID_PCP4, rd_data1, rd_data2, imm_out, target_PC;
    wire branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, take_branch, PCSrc, Jump;
    wire [1:0] ALUOp;

    wire ID_EX_RegW, ID_EX_MemtoReg, ID_EX_MemW, ID_EX_MemR, ID_EX_branch, ID_EX_Jump, ID_EX_ALUSrc, fun7_o, block_control, PC_Write, IF_ID_Write, ID_EX_Write;
    wire [1:0] ID_EX_ALUOp, MuxA_s, MuxB_s;
    wire [2:0] fun3_o;
    wire [3:0] control_out;
    wire [6:0] ID_EX_Opcode;
    wire [31:0] ID_EX_A, ID_EX_B, ID_EX_ImmData, ID_EX_PC, B_data, MuxA_out, MuxB_out, ALU_Result, ID_EX_PCP4;
    wire [4:0] ID_EX_RegRs1, ID_EX_RegRs2, ID_EX_RegRd;

    wire EX_MEM_RegW, EX_MEM_MemtoReg, EX_MEM_MemW, EX_MEM_MemR, EX_MEM_branch, EX_MEM_Jump;
    wire [31:0] EX_MEM_ALUResult, EX_MEM_MemWrData, EX_MEM_B, EX_MEM_PCP4, adder_result;
    wire [4:0] EX_MEM_RegRd;
    wire [31:0] Data_Mem_RdData;

    wire MEM_WB_RegW, MEM_WB_MemtoReg, MEM_WB_MemR;
    wire [31:0] MEM_WB_MemRdData, MEM_WB_RegWrData, MEM_WB_WrRdDATA, MEM_WB_PCP4;
    wire [4:0] MEM_WB_RegRd;

    //Stage 1
    Mux2x1 muxPC(.a1(PCplus4_t), .a2(target_PC), .out(PC_in_t), .s(PCSrc));
    Program_Counter PC(.clk(clk), .reset(reset), .PC_in(PC_in_t), .PC_out(PC_out_t), .PC_Write(PC_Write));
    PCplus4 PCplus4(.fromPC(PC_out_t), .NextPC(PCplus4_t));
    Instruction_Memory InstrMem(.clk(clk), .reset(reset), .pc(PC_out_t), .instr(instr_t));

    IF_ID IF_ID(.clk(clk), .reset(reset), .flush(PCSrc), .PC(PC_out_t), .PCP4(PCplus4_t), .instr(instr_t), .PC_out(IF_ID_PC), .instr_out(IF_ID_instr), .PCP4_out(IF_ID_PCP4), .IF_ID_Write(IF_ID_Write));

    //Stage 2
    RegisterBlock registers(.clk(clk), .reset(reset), .rs1(IF_ID_instr[19:15]), .rs2(IF_ID_instr[24:20]), .rd_data1(rd_data1), 
        .rd_data2(rd_data2), .regWr(MEM_WB_RegW), .ws(MEM_WB_RegRd), .wr_data(MEM_WB_WrRdDATA));

    ImmGen ImmGen(.Opcode(IF_ID_instr[6:0]), .instruction(IF_ID_instr), .ImmOutput(imm_out));

    //Adder adder(.a1(imm_out), .a2(IF_ID_PC), .out(target_PC));

    HazardDetectUnit HazardDU(.clk(clk), .rst(reset), .ID_EX_MemR(ID_EX_MemR), .ID_EX_RegRd(ID_EX_RegRd), .IF_ID_RegRs1(IF_ID_instr[19:15]), 
        .IF_ID_RegRs2(IF_ID_instr[24:20]), .block_control(block_control), .PC_Write(PC_Write), .IF_ID_Write(IF_ID_Write), .ID_EX_Write(ID_EX_Write));

    Control control(.instruction(IF_ID_instr[6:0]), .Branch(branch), .MemRead(MemRead), .MemtoReg(MemtoReg), .ALUOp(ALUOp), 
        .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .Jump(Jump), .block_control(block_control));

    wire funct7_bit;
    assign funct7_bit = (IF_ID_instr[6:0] == 7'b0110011) ? IF_ID_instr[30] : 1'b0;
    
    ID_EX ID_EX(.clk(clk), .reset(reset), .flush(PCSrc), .PC(IF_ID_PC), .PCP4(IF_ID_PCP4), .fun7(funct7_bit), .fun3(IF_ID_instr[14:12]), .RegW(RegWrite), .MemtoReg(MemtoReg), 
        .MemW(MemWrite), .MemR(MemRead), .Branch(branch), .Jump(Jump), .Opcode(IF_ID_instr[6:0]), .ALUOp(ALUOp), .ALUSrc(ALUSrc), .A(rd_data1), .B(rd_data2), .IF_ID_Imm(imm_out), 
        .IF_ID_RegRs1(IF_ID_instr[19:15]), .IF_ID_RegRs2(IF_ID_instr[24:20]), .IF_ID_RegRd(IF_ID_instr[11:7]), .PC_out(ID_EX_PC), .PCP4_out(ID_EX_PCP4), .fun7_o(fun7_o), 
        .fun3_o(fun3_o), .RegW_o(ID_EX_RegW), .MemtoReg_o(ID_EX_MemtoReg), .MemW_o(ID_EX_MemW), .MemR_o(ID_EX_MemR), .Branch_o(ID_EX_branch), .Jump_o(ID_EX_Jump), 
        .Opcode_o(ID_EX_Opcode), .ALUOp_o(ID_EX_ALUOp), .ALUSrc_o(ID_EX_ALUSrc), .A_o(ID_EX_A), .B_o(ID_EX_B), .ID_EX_Imm(ID_EX_ImmData), .ID_EX_RegRs1(ID_EX_RegRs1), 
        .ID_EX_RegRs2(ID_EX_RegRs2), .ID_EX_RegRd(ID_EX_RegRd), .ID_EX_Write(ID_EX_Write));

    //Stage 3    
    Mux3x1 MuxA(.a1(ID_EX_A), .a2(MEM_WB_WrRdDATA), .a3(EX_MEM_ALUResult), .out(MuxA_out), .s(MuxA_s));
    Mux2x1 MuxImmB(.a1(ID_EX_B), .a2(ID_EX_ImmData), .out(B_data), .s(ID_EX_ALUSrc));
    Mux3x1 MuxB(.a1(B_data), .a2(MEM_WB_WrRdDATA), .a3(EX_MEM_ALUResult), .out(MuxB_out), .s(MuxB_s));
    ALU_Control ALU_Control(.fun7(fun7_o), .fun3(fun3_o), .ALUOp(ID_EX_ALUOp), .control_out(control_out));
    ALU ALU(.a(MuxA_out), .b(MuxB_out), .ALU_Result(ALU_Result), .alu_control(control_out));
    BranchDecision BD(.rs1_sign(MuxA_out[31]), .rs2_sign(MuxB_out[31]), .ALU_Result(ALU_Result), .funct3(fun3_o), .take_branch(take_branch));
    //ANDgate ANDgate(.a1(ID_EX_branch), .a2(take_branch), .out(PCSrc));

    assign PCSrc = (ID_EX_branch & take_branch) | ID_EX_Jump;
    assign jalr_cond = (ID_EX_Opcode == 7'b1100111);
    assign target_PC = (ID_EX_Jump && jalr_cond) ? ALU_Result : 
                        (ID_EX_branch) ? adder_result : IF_ID_PCP4;

    Adder adder(.a1(ID_EX_ImmData), .a2(ID_EX_PC), .out(adder_result));

    Forward_Unit Forward_Unit(.stall(block_control), .ID_EX_RegRs1(ID_EX_RegRs1), .ID_EX_RegRs2(ID_EX_RegRs2), .EX_MEM_RegW(EX_MEM_RegW), .EX_MEM_MemR(EX_MEM_MemR),.EX_MEM_RegRd(EX_MEM_RegRd), 
        .MEM_WB_RegW(MEM_WB_RegW), .MEM_WB_MemR(MEM_WB_MemR), .MEM_WB_RegRd(MEM_WB_RegRd), .Mux_A(MuxA_s), .Mux_B(MuxB_s));

    EX_MEM EX_MEM(.clk(clk), .reset(reset), .PCP4(ID_EX_PCP4), .RegW(ID_EX_RegW), .MemtoReg(ID_EX_MemtoReg), .MemW(ID_EX_MemW), .MemR(ID_EX_MemR), 
        .Branch(ID_EX_branch), .Jump(ID_EX_Jump), .ALUResult(ALU_Result), .MemWrData(ID_EX_B), .ID_EX_RegRd(ID_EX_RegRd), .PCP4_o(EX_MEM_PCP4), .RegW_o(EX_MEM_RegW), 
        .MemtoReg_o(EX_MEM_MemtoReg), .MemW_o(EX_MEM_MemW), .MemR_o(EX_MEM_MemR), .Branch_o(EX_MEM_branch), .Jump_o(EX_MEM_Jump), .ALUResult_o(EX_MEM_ALUResult), 
        .MemWrData_o(EX_MEM_MemWrData), .EX_MEM_RegRd(EX_MEM_RegRd));

    //Stage 4
    DataMemory DataMemory(.clk(clk), .reset(reset), .MemWrite(EX_MEM_MemW), .MemRead(EX_MEM_MemR), .Mem_Addr(EX_MEM_ALUResult), 
        .wr_data(EX_MEM_MemWrData), .rd_data(Data_Mem_RdData));

    MEM_WB MEM_WB(.clk(clk), .reset(reset), .PCP4(EX_MEM_PCP4), .RegW(EX_MEM_RegW), .MemtoReg(EX_MEM_MemtoReg), .MemR(EX_MEM_MemR),.Jump(EX_MEM_Jump), .RdData(Data_Mem_RdData), 
        .RegWrData(EX_MEM_ALUResult), .EX_MEM_RegRd(EX_MEM_RegRd), .PCP4_o(MEM_WB_PCP4), .RegW_o(MEM_WB_RegW), .MemtoReg_o(MEM_WB_MemtoReg), .MemR_o(MEM_WB_MemR), .Jump_o(MEM_WB_Jump), 
        .RdData_o(MEM_WB_MemRdData), .RegWrData_o(MEM_WB_RegWrData), .MEM_WB_RegRd(MEM_WB_RegRd));

    //Stage 5
    Mux3x1 WrMux(.a1(MEM_WB_RegWrData), .a2(MEM_WB_MemRdData), .a3(MEM_WB_PCP4), .out(MEM_WB_WrRdDATA), .s({MEM_WB_Jump, MEM_WB_MemtoReg}));
    //Mux2x1 WrMux(.a1(MEM_WB_RegWrData),.a2(MEM_WB_MemRdData),.out(MEM_WB_WrRdDATA),.s(MEM_WB_MemtoReg));

endmodule