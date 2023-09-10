`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/06 02:06:31
// Design Name: 
// Module Name: half_adder
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


module half_adder (
    input A,
    input B,
    output reg S,
    output reg C
);
    always @(*) begin    // Sum(S) 계산 Case 문
        case ({A, B})
            2'b00: S = 1'b0; // A=0, B=0
            2'b01: S = 1'b1; // A=0, B=1
            2'b10: S = 1'b1; // A=1, B=0
            2'b11: S = 1'b0; // A=1, B=1
        endcase
    end
    always @(*) begin    // Carry(C) 계산 Case 문
        case ({A, B})
            2'b00, 2'b01, 2'b10: C = 1'b0; // A=0 또는 B=0
            2'b11: C = 1'b1; // A=1, B=1
        endcase
    end
endmodule