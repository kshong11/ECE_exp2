`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/04 23:12:16
// Design Name: 
// Module Name: oneshot
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


module oneshot(clk, rst, btn, btn_trig);

input clk, rst, btn;
reg btn_reg;
output reg btn_trig;

always @(negedge rst or posedge clk) begin
    if(!rst) begin
        btn_reg <= 0;
        btn_trig <= 0;
    end
    else begin
        btn_reg <= btn;
        btn_trig <= btn & ~btn_reg;
    end
end

endmodule
