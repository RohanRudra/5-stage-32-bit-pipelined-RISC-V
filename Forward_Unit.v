module Forward_Unit(ID_EX_RegRs1, ID_EX_RegRs2, EX_MEM_RegW, EX_MEM_RegRd, MEM_WB_RegW, MEM_WB_RegRd, Mux_A, Mux_B);
    input EX_MEM_RegW, MEM_WB_RegW;
    input [4:0] ID_EX_RegRs1, ID_EX_RegRs2, EX_MEM_RegRd, MEM_WB_RegRd;
    output [1:0] Mux_A, Mux_B;

    //For Mux_A
    assign Mux_A = (EX_MEM_RegW && (EX_MEM_RegRd != 5'd0) && (EX_MEM_RegRd == ID_EX_RegRs1)) ? 2'b10 :
                   (MEM_WB_RegW && (MEM_WB_RegRd != 5'd0) && (MEM_WB_RegRd == ID_EX_RegRs1)
                   && !(EX_MEM_RegW && (EX_MEM_RegRd != 5'd0) && (EX_MEM_RegRd == ID_EX_RegRs1))) ? 2'b01 : 2'b00;

    //For Mux_B
    assign Mux_B = (EX_MEM_RegW && (EX_MEM_RegRd != 5'd0) && (EX_MEM_RegRd == ID_EX_RegRs2)) ? 2'b10 : 
                   (MEM_WB_RegW && (MEM_WB_RegRd != 5'd0) && (MEM_WB_RegRd == ID_EX_RegRs2)
                   && !(EX_MEM_RegW && (EX_MEM_RegRd != 5'd0) && (EX_MEM_RegRd == ID_EX_RegRs2))) ? 2'b01 : 2'b00;

endmodule