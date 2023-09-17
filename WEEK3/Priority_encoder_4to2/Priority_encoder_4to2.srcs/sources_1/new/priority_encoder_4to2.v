`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/15 14:09:28
// Design Name: 
// Module Name: priority_encoder_4to2
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


module priority_encoder_4to2(D, x, y, v);

input [3:0] D;

output x, y, v;

wire x, y, v;

assign x = D[2]|D[3];
assign y = D[1]&(~D[2])|D[3];
assign v = D[3]|D[2]|D[1]|D[0];

endmodule