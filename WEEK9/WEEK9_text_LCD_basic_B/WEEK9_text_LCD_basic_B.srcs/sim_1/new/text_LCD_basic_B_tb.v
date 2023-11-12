`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/12 14:16:52
// Design Name: 
// Module Name: text_LCD_basic_B_tb
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


module text_LCD_basic_B_tb();

  reg rst, clk;

  wire LCD_E, LCD_RS, LCD_RW;
  wire [7:0] LCD_DATA;
  wire [7:0] LED_out;

  text_LCD_basic_B t2(rst, clk, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out);

  initial begin
    clk <= 0;
    rst <= 1;
    #2; rst <= 0;
    #2; rst <= 1;
  end

  always #0.5 clk = ~clk;

endmodule

