`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/27 11:27:50
// Design Name: 
// Module Name: week5_SM2_tb
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


module week5_SM2_tb();

reg clk, rst, A, B, C;
wire [2:0] state;
wire y;

week5_SM2 kshongmodule(clk, rst, A, B, C, state, y);
initial begin
    clk =0; rst = 1; A = 0; B = 0; C = 0;
    #10 rst = 0;
    #10 rst = 1;
    #20 A = 1;
    #20 A = 0; B = 1;
    #20 A = 1; B = 0;
    #20 A = 0; B = 1;
    #20 C = 1; A = 0; B = 0;
    #20 rst = 0; C = 0;
    #10 rst = 1;
    #20 A = 1;
    #20 A = 0; B = 1;
    #20 C = 1; A = 0; B = 0;
end

always begin
    #5 clk = ~clk;
end

endmodule
