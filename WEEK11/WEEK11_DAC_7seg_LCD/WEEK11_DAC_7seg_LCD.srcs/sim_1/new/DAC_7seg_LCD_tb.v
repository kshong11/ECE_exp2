`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/18 16:48:09
// Design Name: 
// Module Name: DAC_7seg_LCD_tb
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


module DAC_7seg_LCD_tb();

reg clk, rst;
reg[5:0] btn;
reg add_sel;
wire dac_csn, dac_ldacn, dac_wrn, dac_a_b;
wire[7:0] dac_d;
wire[7:0] led_out;
wire[7:0] seg_sel;
wire[7:0] seg_data;
wire LCD_E, LCD_RS, LCD_RW;
wire[7:0] LCD_DATA;

DAC_7seg_LCD tb(clk, rst, btn, add_sel, dac_csn, dac_ldacn, dac_wrn, dac_a_b, dac_d, led_out, seg_data, seg_sel,LCD_E, LCD_RS, LCD_RW, LCD_DATA);

initial begin
    rst <= 0; clk <= 0; btn <= 5'b00000; add_sel <= 0; #10
    rst <= 1; #100
    btn <= 6'b000001; #50 btn <= 6'b000000; #50
    btn <= 6'b000001; #50 btn <= 6'b000000; #50
    btn <= 6'b000001; #50 btn <= 6'b000000; #50
    btn <= 6'b000001; #50 btn <= 6'b000000; #50
    btn <= 6'b000001; #50 btn <= 6'b000000; #50
    btn <= 6'b000001; #50 btn <= 6'b000000; #50
    btn <= 6'b000001; #50 btn <= 6'b000000; #50
    btn <= 6'b000001; #50 btn <= 6'b000000; #50
    btn <= 6'b000001; #50 btn <= 6'b000000; #50
    btn <= 6'b000001; #50 btn <= 6'b000000; #50
    btn <= 6'b000001; #50 btn <= 6'b000000; #50
    btn <= 6'b000001; #50 btn <= 6'b000000;
    add_sel <= 1; 
end

always
    #0.05 clk <= ~clk;
endmodule
