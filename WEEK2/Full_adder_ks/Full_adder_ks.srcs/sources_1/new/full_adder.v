`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/07 11:11:42
// Design Name: 
// Module Name: full_adder
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


module full_adder(
    input wire a, b, cin,
    output wire s, cout
);
    wire c1, c2;
    wire s1;
    half_adder HA1(.a(a),.b(b),.s(s1),.c(c1));
    half_adder HA2(.a(s1),.b(cin),.s(s),.c(c2));
    
    assign cout = c1 | c2;


endmodule
