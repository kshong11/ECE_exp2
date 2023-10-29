`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/27 22:54:03
// Design Name: 
// Module Name: week5_3bit_updown_counter
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


module week5_3bit_updown_counter(clk, rst, x, state);
input clk, rst, x;
reg x_reg, x_trig, u_d_reg;
output reg [2:0] state;

always @(negedge rst or posedge clk) begin
    if(!rst) begin
        {x_reg,x_trig} <= 2'b00;
    end
    else begin
        x_reg <= x;
        x_trig <= x & ~x_reg;
    end
end
always @(negedge rst or posedge clk) begin
    if(!rst) begin
        state <= 2'b00;
        u_d_reg <= 1;
    end
    else begin
        case(state)
            3'b000: begin
                if (u_d_reg == 1 & x_trig == 1) state <= 3'b001;
                else if (u_d_reg == 0 & x_trig == 1) begin
                    state <=  3'b001;
                    u_d_reg <= 1;
                end
                else state <= 3'b000;
            end
            3'b001: begin
                if (u_d_reg == 1 & x_trig == 1) state <= 3'b010;
                else if (u_d_reg == 0 & x_trig == 1) state <= 3'b000;
                else state <= 3'b001;
            end
            3'b010: begin
                if (u_d_reg == 1 & x_trig == 1) state <= 3'b011;
                else if (u_d_reg == 0 & x_trig == 1) state <= 3'b001;
                else state <= 3'b010;
            end
            3'b011: begin
                if (u_d_reg == 1 & x_trig == 1) state <= 3'b100;
                else if (u_d_reg == 0 & x_trig == 1) state <= 3'b010;
                else state <= 3'b011;
            end
            3'b100: begin
                if (u_d_reg == 1 & x_trig == 1) state <= 3'b101;
                else if (u_d_reg == 0 & x_trig == 1) state <= 3'b011;
                else state <= 3'b100;
            end
            3'b101: begin
                if (u_d_reg == 1 & x_trig == 1) state <= 3'b110;
                else if (u_d_reg == 0 & x_trig == 1) state <= 3'b100;
                else state <= 3'b101;
            end
            3'b110: begin
                if (u_d_reg == 1 & x_trig == 1) state <= 3'b111;
                else if (u_d_reg == 0 & x_trig == 1) state <= 3'b101;
                else state <= 3'b110;
            end
            3'b111: begin
                if (u_d_reg == 1 & x_trig == 1) begin
                    state <= 3'b110;
                    u_d_reg <= 0;
                end
                else state <= 3'b111;
            end
        endcase
    end
end


endmodule
