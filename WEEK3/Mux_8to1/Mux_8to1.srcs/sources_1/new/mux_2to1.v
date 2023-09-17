`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 13:20:33
// Design Name: 
// Module Name: mux_2to1
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


module mux_2to1(I0, I1, S, Y);
inout [3:0] I0, I1;
input S;
output [3:0] Y;
reg [3:0] Y;

always @(*) begin
case (S)
1'b0 : Y = I0;
1'b1 : Y = I1;
endcase
end
endmodule