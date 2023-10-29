`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/27 22:39:40
// Design Name: 
// Module Name: week5_2bit_upcounter_tb
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


module week5_2bit_upcounter_tb();

reg clk, rst, x;
wire [1:0] state;


week5_2bit_upcounter hksmodule(clk, rst, x, state);
initial begin
    clk =0; rst = 1; x=0; //4.1.1 00->01
    #10 rst = 0;
    #10 rst = 1;
    #20 x = 1;  
    #20 x = 0;
    #20 x = 1;  
    #20 x = 0;
    #20 x = 1;  
    #20 x = 0;
    #20 x = 1;  
    #20 x = 0;
    #20 x = 1;  
    #20 x = 0;
    #20 x = 1;  
    #20 x = 0;  
    #20 x = 1;  
    #20 x = 0;
    
end

always begin
    #5 clk = ~clk;
end

endmodule
