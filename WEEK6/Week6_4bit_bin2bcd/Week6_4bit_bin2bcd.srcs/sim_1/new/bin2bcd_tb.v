`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/04 04:27:33
// Design Name: 
// Module Name: bin2bcd_tb
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


module bin2bcd_tb();
reg clk, rst;
reg [3:0] bin;
wire [7:0] bcd;

bin2bcd u1(clk, rst, bin, bcd);

initial begin
    clk <= 0; rst <= 1;
    #10 rst <= 0;
    #10 rst <= 1;
    #20 bin <= 4'd0;
    #20 bin <= 4'd1;
    #20 bin <= 4'd2;
    #20 bin <= 4'd3;
    #20 bin <= 4'd4;
    #20 bin <= 4'd5;
    #20 bin <= 4'd6;
    #20 bin <= 4'd7;
    #20 bin <= 4'd8;
    #20 bin <= 4'd9;
    #20 bin <= 4'd10;
    #20 bin <= 4'd11;
    #20 bin <= 4'd12;
    #20 bin <= 4'd13;
    #20 bin <= 4'd14;
    #20 bin <= 4'd15;
end

always begin
    #5 clk <= ~clk;
end

endmodule
