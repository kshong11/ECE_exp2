`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/18 16:08:38
// Design Name: 
// Module Name: DAC_tb
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


module DAC_tb();
reg clk, rst;
reg [9:0] btn;
reg add_sel;
wire dac_csn, dac_ldacn, dac_wrn, dac_a_b;
wire [7:0] dac_d;
wire [7:0] led_out;

DAC U1(clk, rst, btn, add_sel, dac_csn, dac_ldacn, dac_wrn, dac_a_b, dac_d, led_out);
initial begin
    clk<=0;
    rst<=0;
    btn <= 0;
    add_sel<=1;
    #0.1 rst<=0;
    #0.1 rst<=1;

    #1e+6; btn <= 9'b100000000;
    #1e+6; btn <= 9'b001000000;
    #1e+6; btn <= 9'b000100000;
    #1e+6; btn <= 9'b000001000;
    #1e+6; btn <= 9'b000000100;
    #1e+6; btn <= 9'b000000001;
    end 

always begin
    #0.5 clk<=~clk;
    end
    
endmodule
