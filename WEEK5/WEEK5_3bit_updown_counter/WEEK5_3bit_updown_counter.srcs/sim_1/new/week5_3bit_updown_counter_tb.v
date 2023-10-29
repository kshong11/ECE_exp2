`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/27 23:00:17
// Design Name: 
// Module Name: week5_3bit_updown_counter_tb
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


module week5_3bit_updown_counter_tb();
reg clk, rst, x;
wire [2:0] state;

week5_3bit_updown_counter hksmodule(clk, rst, x, state);
initial begin
    clk =0; rst = 1; x=0; 
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
