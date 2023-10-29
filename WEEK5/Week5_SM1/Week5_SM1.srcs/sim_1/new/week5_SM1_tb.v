`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/27 10:31:02
// Design Name: 
// Module Name: week5_SM1_tb
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


module week5_SM1_tb();

reg clk, rst, x;
wire [1:0] state;
wire y;

week5_SM1 kshongmodule(clk, rst, x, y, state);
initial begin
    clk =0; rst = 1; x=1; //4.1.1 00->01
    #10 rst = 0;
    #10 rst = 1;
    #10 x = 0;  //4.1.2 01->00
    #10 x = 1;  //4.1.1 00->01
    #10 x = 1; //4.1.3 01->11
    #10 x = 0; //4.1.6 11->00
    #10 x = 1;  // 00->01
    #10 x = 1; // 01->11
    #10 x = 1; // 11->10
    #10 x = 1; // 4.1.5 10->10
    #10 x = 0; // 4.1.4 10->00
    
end

always begin
    #5 clk = ~clk;
end

endmodule
