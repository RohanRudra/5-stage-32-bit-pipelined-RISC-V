module Mux2x1(a1,a2,out,s);
    input s;
    input [31:0] a1,a2;
    output [31:0] out;

    assign out = (s == 1'b0) ? a1 : a2;
endmodule

module Mux3x1(a1,a2,a3,out,s);
    input [1:0] s;
    input [31:0] a1,a2,a3;
    output [31:0] out;

    assign out = (s == 2'b00) ? a1 : 
                (s == 2'b01) ? a2 : a3;
endmodule

module Adder(a1,a2,out);
    input [31:0] a1,a2;
    output [31:0] out;

    assign out = a1 + a2;
endmodule

module ANDgate(a1,a2,out);
    input a1,a2;
    output out;

    assign out = a1 & a2;
endmodule