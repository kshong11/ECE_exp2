`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/22 02:24:09
// Design Name: 
// Module Name: JK_flip_flop_tb
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


module JK_flip_flop_tb();

reg clk, J, K;
wire Q;

JK_flip_flop kshongmodule(clk, J, K, Q);

initial begin
    clk <= 0;
    #60 {J,K} <= 2'b00;
    #60 {J,K} <= 2'b01;
    #60 {J,K} <= 2'b00;
    #60 {J,K} <= 2'b10;
    #60 {J,K} <= 2'b00;
    #60 {J,K} <= 2'b11;
    #60 {J,K} <= 2'b00;
end

always begin
    #5 clk <= ~clk;
end

endmodule

