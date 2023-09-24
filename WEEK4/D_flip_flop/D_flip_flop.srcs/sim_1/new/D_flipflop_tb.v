`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/21 14:17:52
// Design Name: 
// Module Name: D_flipflop_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module D_flipflop_tb();

reg clk, D;
wire Q;

D_flipflop kshongmodule(clk, D, Q);

initial begin
    clk <= 0;
    #30;
    D <= 0;
    #30;
    D <= 1;
    #30;
    D <= 0;
    #30;
    D <= 1;
    #30;
    D <= 0;
    #30;
    D <= 1;
    #30;
end

always begin
    #5 clk <= ~clk;
end

endmodule
