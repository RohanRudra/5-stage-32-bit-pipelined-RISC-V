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
`include "EqualCheck.v"

module top(clk, reset);
    input clk, reset; 
    wire [31:0] PCplus4_t, PC_in_t, PC_out_t, instr_t, IF_ID_PC, IF_ID_instr, rd_data1, rd_data2, imm_out, target_PC;
    wire branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, EqualFlag, PCSrc;
    wire [1:0] ALUOp;

    wire ID_EX_RegW, ID_EX_MemtoReg, ID_EX_MemW, ID_EX_MemR, ID_EX_branch, ID_EX_ALUSrc, fun7_o, zero;
    wire [1:0] ID_EX_ALUOp, MuxA_s, MuxB_s;
    wire [2:0] fun3_o;
    wire [3:0] control_out;
    wire [31:0] ID_EX_A, ID_EX_B, ID_EX_ImmData, B_data, MuxA_out, MuxB_out, ALU_Result;
    wire [4:0] ID_EX_RegRs1, ID_EX_RegRs2, ID_EX_RegRd;

    wire EX_MEM_RegW, EX_MEM_MemtoReg, EX_MEM_MemW, EX_MEM_MemR, EX_MEM_branch;
    wire [31:0] EX_MEM_ALUResult, EX_MEM_MemWrData, EX_MEM_B;
    wire [4:0] EX_MEM_RegRd;
    wire [31:0] Data_Mem_RdData;

    wire MEM_WB_RegW, MEM_WB_MemtoReg;
    wire [31:0] MEM_WB_MemRdData, MEM_WB_RegWrData, MEM_WB_WrRdDATA;
    wire [4:0] MEM_WB_RegRd;

    //Stage 1
    Mux2x1 muxPC(.a1(PCplus4_t), .a2(target_PC), .out(PC_in_t), .s(PCSrc));
    Program_Counter PC(.clk(clk), .reset(reset), .PC_in(PC_in_t), .PC_out(PC_out_t));
    PCplus4 PCplus4(.fromPC(PC_out_t), .NextPC(PCplus4_t));
    Instruction_Memory InstrMem(.clk(clk), .reset(reset), .pc(PC_out_t), .instr(instr_t));

    IF_ID IF_ID(.clk(clk), .reset(reset), .PC(PC_out_t), .instr(instr_t), .PC_out(IF_ID_PC), .instr_out(IF_ID_instr));

    //Stage 2
    RegisterBlock registers(.clk(clk), .reset(reset), .rs1(IF_ID_instr[19:15]), .rs2(IF_ID_instr[24:20]), .rd_data1(rd_data1), .rd_data2(rd_data2), .regWr(MEM_WB_RegW), .ws(MEM_WB_RegRd), .wr_data(MEM_WB_WrRdDATA));

    EqualCheck EqualCheckBlock(.reset(reset), .a1(rd_data1), .a2(rd_data2), .out(EqualFlag));
    ANDgate ANDgate(.a1(branch), .a2(EqualFlag), .out(PCSrc));
    
    ImmGen ImmGen(.Opcode(IF_ID_instr[6:0]), .instruction(IF_ID_instr), .ImmOutput(imm_out));
    Adder adder(.a1(imm_out), .a2(IF_ID_PC), .out(target_PC));
    Control control(.instruction(IF_ID_instr[6:0]), .Branch(branch), .MemRead(MemRead), .MemtoReg(MemtoReg), .ALUOp(ALUOp), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite));
    
    ID_EX ID_EX(.clk(clk), .reset(reset), .fun7(IF_ID_instr[30]), .fun3(IF_ID_instr[14:12]), .RegW(RegWrite), .MemtoReg(MemtoReg), .MemW(MemWrite), .MemR(MemRead), .Branch(branch), .ALUOp(ALUOp), .ALUSrc(ALUSrc), .A(rd_data1), .B(rd_data2), .IF_ID_Imm(imm_out), .IF_ID_RegRs1(IF_ID_instr[19:15]), .IF_ID_RegRs2(IF_ID_instr[24:20]), .IF_ID_RegRd(IF_ID_instr[11:7]),
        .fun7_o(fun7_o), .fun3_o(fun3_o), .RegW_o(ID_EX_RegW), .MemtoReg_o(ID_EX_MemtoReg), .MemW_o(ID_EX_MemW), .MemR_o(ID_EX_MemR), .Branch_o(ID_EX_branch), .ALUOp_o(ID_EX_ALUOp), .ALUSrc_o(ID_EX_ALUSrc), .A_o(ID_EX_A), .B_o(ID_EX_B), .ID_EX_Imm(ID_EX_ImmData), .ID_EX_RegRs1(ID_EX_RegRs1), .ID_EX_RegRs2(ID_EX_RegRs2), .ID_EX_RegRd(ID_EX_RegRd));

    //Stage 3    
    Mux3x1 MuxA(.a1(ID_EX_A), .a2(MEM_WB_WrRdDATA), .a3(EX_MEM_ALUResult), .out(MuxA_out), .s(MuxA_s));
    Mux2x1 MuxImmB(.a1(ID_EX_B), .a2(ID_EX_ImmData), .out(B_data), .s(ID_EX_ALUSrc));
    Mux3x1 MuxB(.a1(B_data), .a2(MEM_WB_WrRdDATA), .a3(EX_MEM_ALUResult), .out(MuxB_out), .s(MuxB_s));
    ALU_Control ALU_Control(.fun7(fun7_o), .fun3(fun3_o), .ALUOp(ID_EX_ALUOp), .control_out(control_out));
    ALU ALU(.a(MuxA_out), .b(MuxB_out), .ALU_Result(ALU_Result), .alu_control(control_out), .zero(zero));

    Forward_Unit Forward_Unit(.ID_EX_RegRs1(ID_EX_RegRs1), .ID_EX_RegRs2(ID_EX_RegRs2), .EX_MEM_RegW(EX_MEM_RegW), .EX_MEM_RegRd(EX_MEM_RegRd), .MEM_WB_RegW(MEM_WB_RegW), .MEM_WB_RegRd(MEM_WB_RegRd), .Mux_A(MuxA_s), .Mux_B(MuxB_s));

    EX_MEM EX_MEM(.clk(clk), .reset(reset), .RegW(ID_EX_RegW), .MemtoReg(ID_EX_MemtoReg), .MemW(ID_EX_MemW), .MemR(ID_EX_MemR), .Branch(ID_EX_branch), .ALUResult(ALU_Result), .MemWrData(MuxB_out), .ID_EX_RegRd(ID_EX_RegRd), .B(ID_EX_B), 
        .RegW_o(EX_MEM_RegW), .MemtoReg_o(EX_MEM_MemtoReg), .MemW_o(EX_MEM_MemW), .MemR_o(EX_MEM_MemR), .Branch_o(EX_MEM_branch), .ALUResult_o(EX_MEM_ALUResult), .MemWrData_o(EX_MEM_MemWrData), .EX_MEM_RegRd(EX_MEM_RegRd), .B_Out(EX_MEM_B));

    //Stage 4
    DataMemory DataMemory(.clk(clk), .reset(reset), .MemWrite(EX_MEM_MemW), .MemRead(EX_MEM_MemR), .Mem_Addr(EX_MEM_ALUResult), .wr_data(EX_MEM_B), .rd_data(Data_Mem_RdData));

    MEM_WB MEM_WB(.clk(clk), .reset(reset), .RegW(EX_MEM_RegW), .MemtoReg(EX_MEM_MemtoReg), .RdData(Data_Mem_RdData), .RegWrData(EX_MEM_ALUResult), .EX_MEM_RegRd(EX_MEM_RegRd), .RegW_o(MEM_WB_RegW), .MemtoReg_o(MEM_WB_MemtoReg), .RdData_o(MEM_WB_MemRdData), .RegWrData_o(MEM_WB_RegWrData), .MEM_WB_RegRd(MEM_WB_RegRd));

    //Stage 5
    Mux2x1 WrMux(.a1(MEM_WB_RegWrData),.a2(MEM_WB_MemRdData),.out(MEM_WB_WrRdDATA),.s(MEM_WB_MemtoReg));

endmodule