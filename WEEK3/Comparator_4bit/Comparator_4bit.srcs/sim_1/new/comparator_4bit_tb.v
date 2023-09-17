`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/13 09:17:43
// Design Name: 
// Module Name: comparator_4bit_tb
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


module comparator_4bit_tb();
reg [3:0] a, b;
wire x, y, z;
comparator_4bit mymodulehks (
    .a(a), .b(b),
    .x(x), .y(y), .z(z)
);
initial begin
    a = 4'b0011;
    b = 4'b1000;
    #10
    a = 4'b0111;
    b = 4'b0001;
    #10
    a = 4'b1001;
    b = 4'b1001;
    #10
    a = 4'b1011;
    b = 4'b1111;
end
endmodule
