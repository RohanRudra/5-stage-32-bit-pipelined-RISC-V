module EqualCheck(reset,a1,a2,out);
    input reset;
    input [31:0] a1,a2;
    output out;

    assign out = (reset) ? 1'b0 : (a1 == a2);
endmodule