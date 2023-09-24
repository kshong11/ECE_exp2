`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/22 20:13:12
// Design Name: 
// Module Name: T_flipflop_oneshot_trigger_tb
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


module T_flipflop_oneshot_trigger_tb();

reg clk, T, rst;
wire Q;

T_flipflop_oneshot_trigger kshongmodule(clk, rst, T, Q);

initial begin
    clk <= 0;
    rst <= 1;
    T <= 0;
    #10 rst <= 0;
    #10 rst <= 1;
    #60 T <= 0;
    #60 T <= 1;
    #60 T <= 0;
    #60 T <= 1;
    #60 T <= 0;
    #60 T <= 1;
end

always begin
    #5 clk <= ~clk;
end


endmodule