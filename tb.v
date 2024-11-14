`include "Top.v"

module tb;
    reg clk, reset;
    top top(.clk(clk), .reset(reset));

    initial begin
        clk = 0;
        reset = 1;

        #5 reset = 0;
        #500;
    end

    always begin
        #10 clk = ~clk;
    end
endmodule