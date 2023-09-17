`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/14 13:45:19
// Design Name: 
// Module Name: mux_8to1_tb
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


module mux_8to1_tb;
reg [2:0] Sel;
reg [3:0] In1;
reg [3:0] In2;
reg [3:0] In3;
reg [3:0] In4;
reg [3:0] In5;
reg [3:0] In6;
reg [3:0] In7;
reg [3:0] In8;

wire [3:0] Out;

mux_8to1 kshongmodule (
.Out(Out), .Sel(Sel), .In1(In1), .In2(In2), .In3(In3),
.In4(In4), .In5(In5), .In6(In6), .In7(In7), .In8(In8)
);

reg [3:0] count;

initial begin
Sel = 0;
In1 = 0;
In2 = 0;
In3 = 0;
In4 = 0;
In5 = 0;
In6 = 0;
In7 = 0;
In8 = 0;

#10;

Sel = 3'd0;
In1 = 4'd0;
In2 = 4'd1;
In3 = 4'd2;
In4 = 4'd3;
In5 = 4'd4;
In6 = 4'd5;
In7 = 4'd6;
In8 = 4'd7;

for (count = 0; count < 8; count = count + 1'b1) begin
Sel = count;
#20;
end
end
endmodule
