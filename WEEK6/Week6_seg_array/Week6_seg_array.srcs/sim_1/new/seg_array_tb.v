`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/04 04:54:43
// Design Name: 
// Module Name: seg_array_tb
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


module seg_array_tb();

reg clk, rst;
reg btn;
wire [7:0] seg_data;
wire [7:0] seg_sel;

seg_array u1(clk, rst, btn, seg_data, seg_sel);
initial begin
    clk <= 0; rst <= 1; btn <=0;
    #10 rst <= 0;
    #10 rst <= 1;
    #40 btn <= 1;
    #40 btn <= 0;
    #40 btn <= 1;
    #40 btn <= 0;
    #40 btn <= 1;
    #40 btn <= 0;
    #40 btn <= 1;
    #40 btn <= 0;
    #40 btn <= 1;
    #40 btn <= 0;
    #40 btn <= 1;
    #40 btn <= 0;
    #40 btn <= 1;
    #40 btn <= 0;
    #40 btn <= 1;
    #40 btn <= 0;
    #40 btn <= 1;
    #40 btn <= 0;
    #40 btn <= 1;
    #40 btn <= 0;
    #40 btn <= 1;
    #40 btn <= 0;
    #40 btn <= 1;
    #40 btn <= 0;
    #40 btn <= 1;
    #40 btn <= 0;
    #40 btn <= 1;
    #40 btn <= 0;
    #40 btn <= 1;
    #40 btn <= 0;
    #40 btn <= 1;
    #40 btn <= 0;
    #40 btn <= 1;
    #40 btn <= 0;
    #40 btn <= 1;
    #40 btn <= 0;
    #40 btn <= 1;
    #40 btn <= 0;
    #40 btn <= 1;
    #40 btn <= 0;



end

always begin
    #5 clk <= ~clk;
end

endmodule