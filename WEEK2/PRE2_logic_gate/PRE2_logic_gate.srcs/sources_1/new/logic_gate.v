`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/07 00:37:06
// Design Name: 
// Module Name: logic_gate
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


module logic_gate(a, b, v, w, x, y, z);

input a, b;

output v, w, x, y, z;

wire v, w, x, y, z;

//and gate
    assign v   = a & b;
    //or gate
    assign w    = a | b;
    //xor gate
    assign x   = a ^ b;
    //nor gate
    assign y   = ~(a | b);
    //nand gate
    assign z  = ~(a & b);

endmodule
