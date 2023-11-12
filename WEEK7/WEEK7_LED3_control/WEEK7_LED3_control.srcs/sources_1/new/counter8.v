`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/08 02:48:43
// Design Name: 
// Module Name: counter8
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


module counter8(clk, rst, cnt);
input clk, rst;
output reg [7:0] cnt;

always @(posedge clk or posedge rst) begin
if(rst)
cnt <= 8'b00000000;
else cnt <= cnt + 1;
end
endmodule