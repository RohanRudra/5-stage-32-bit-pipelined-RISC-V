module DataMemory(clk, reset, MemWrite, MemRead, Mem_Addr, wr_data, rd_data);
    input clk,reset,MemRead,MemWrite;
    input [31:0] wr_data, Mem_Addr;
    output [31:0] rd_data; 

    reg [31:0] memory [63:0];

    initial begin
        $readmemh("C:/Users/Rohan/Desktop/verilog codes/RISC-V Pipelined Implementation/dataMem_init.mem", memory, 0, 63); // Specify range 0 to 63
        //memory[10] <= 32'd69;
        //memory[11] <= 32'd9;
    end

    always@(posedge clk)
    begin
        if(MemWrite) begin
            memory[Mem_Addr] <= wr_data;
        end
    end

    assign rd_data = (MemRead) ? memory[Mem_Addr] : 32'b00;

endmodule