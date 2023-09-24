`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/22 02:41:13
// Design Name: 
// Module Name: T_flipflop_no_oneshot_trigger_tb
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


module T_flipflop_no_oneshot_trigger_tb();

reg clk, T, rst;
wire Q;

T_flipflop_no_oneshottrigger kshongmodule(clk, rst, T, Q);

initial begin
    clk <= 0;
    rst <= 1;
    #10 rst <= 0;
    #10 rst <= 1;
    #80 T <= 0;
    #80 T <= 1;
    #90 T <= 0;
    #80 T <= 1;
    #70 T <= 0;
    #90 T <= 1;
end

always begin
    #5 clk <= ~clk;
end

endmodule
