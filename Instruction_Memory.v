module Instruction_Memory(clk, reset, pc, instr);
    input clk,reset;
    input [31:0] pc; //this will tell the position of instruction in the memory
    output [31:0] instr;
    
    reg [31:0] I_memory [63:0];

    initial begin
        $readmemh("C:/Users/Rohan/Desktop/verilog codes/RISC-V Pipelined Implementation/instrMem_init.mem", I_memory, 0, 25); // Specify range 0 to 63
    end

    assign instr = I_memory[pc[31:2]];

endmodule


// int twice(int num){
//     return 2*num;
// }

// int main() {
//     int result = twice(7);   // provide num = 7  // should print 14
// }