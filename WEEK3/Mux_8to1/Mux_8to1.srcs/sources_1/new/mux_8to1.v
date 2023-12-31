`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/13 14:41:42
// Design Name: 
// Module Name: mux_8to1
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


module mux_8to1(I0, I1, I2, I3, I4, I5, I6, I7, S0, S1, S2, Y);

input [3:0] I0, I1, I2, I3, I4, I5, I6, I7;
input S0, S1, S2;
output [3:0] Y;
wire [3:0] W1, W2;


mux_4to1 kshongmux4to1_1(I0, I1, I2, I3, S0, S1, W1);
mux_4to1 kshongmux4to1_2(I4, I5, I6, I7, S0, S1, W2);
mux_2to1 kshongmux2to1(W1, W2, S2, Y);

endmodule
