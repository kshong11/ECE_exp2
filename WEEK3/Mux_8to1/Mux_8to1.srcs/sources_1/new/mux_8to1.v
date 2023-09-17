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


module mux_8to1(
output reg [3:0] Out,
input [2:0] Sel,
input [3:0] In1,
input [3:0] In2,
input [3:0] In3,
input [3:0] In4,
input [3:0] In5,
input [3:0] In6,
input [3:0] In7,
input [3:0] In8
);

always @ (In1 or In2 or In3 or In4 or In5 or In6 or In7 or In8 or Sel)
begin
case (Sel)
3'b000 : Out = In1;
3'b001 : Out = In2;
3'b010 : Out = In3;
3'b011 : Out = In4;
3'b100 : Out = In5;
3'b101 : Out = In6;
3'b110 : Out = In7;
3'b111 : Out = In8;
default : Out = 4'bx; 
endcase
end

endmodule
