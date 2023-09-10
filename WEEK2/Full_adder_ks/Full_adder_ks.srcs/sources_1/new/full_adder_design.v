`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/07 11:18:46
// Design Name: 
// Module Name: full_adder_design
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


module full_adder_design(
    input wire a, b, cin,
    output wire s, cout
);
    full_adder famha(a,b,cin, s, cout);
    
endmodule
