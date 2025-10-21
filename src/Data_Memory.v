module DataMemory(clk, reset, MemWrite, MemRead, Mem_Addr, wr_data, rd_data);
    input clk,reset,MemRead,MemWrite;
    input [31:0] wr_data, Mem_Addr;
    output [31:0] rd_data; 

    //reg [31:0] memory [63:0];
    //wire [31:0] base = Mem_Addr << 2;
    

    //RISC V has byte-addressable memory
    reg [7:0] memory [255:0];

    integer i;

    // Random initialization of memory
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            memory[i] = $random;   // random 8-bit value
        end
    end

    always@(posedge clk)
    begin
        if(MemWrite) begin
            memory[Mem_Addr+3] <= wr_data[31:24];
            memory[Mem_Addr+2] <= wr_data[23:16];
            memory[Mem_Addr+1] <= wr_data[15:8];
            memory[Mem_Addr+0] <= wr_data[7:0];
        end
    end

    assign rd_data = (MemRead) ? {memory[Mem_Addr+3],
                                  memory[Mem_Addr+2],
                                  memory[Mem_Addr+1],
                                  memory[Mem_Addr+0]}  : 32'b00;

    

endmodule