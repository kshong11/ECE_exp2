`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/27 10:29:03
// Design Name: 
// Module Name: week5_SM1
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


module week5_SM1(clk, rst, x, y, state);

input clk, rst, x;
output reg [1:0] state;
output reg y;


always @(negedge rst or posedge clk) begin
    if(!rst) state <= 2'b00;
    else begin
        case(state)
            2'b00: state <= x ? 2'b01 : 2'b00;
            2'b01: state <= x ? 2'b11 : 2'b00;
            2'b10: state <= x ? 2'b10 : 2'b00;
            2'b11: state <= x ? 2'b10 : 2'b00;
        endcase
    end
end
always @(negedge rst or posedge clk) begin
    if(!rst) y <= 0;
    else begin
        case(state)
            2'b00: y <= 1'b0;
            2'b01: y <= x ? 1'b0 : 1'b1;
            2'b10: y <= x ? 1'b0 : 1'b1;
            2'b11: y <= x ? 1'b0 : 1'b1;
        endcase
    end
end
endmodule







