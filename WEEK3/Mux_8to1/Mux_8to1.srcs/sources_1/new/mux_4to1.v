`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 13:18:00
// Design Name: 
// Module Name: mux_4to1
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


module mux_4to1(I0, I1, I2, I3, S0, S1, Y);

output reg [3:0] Y;
input [3:0] I0, I1, I2, I3;
input S0, S1;

always @ (*) begin
case ({S0, S1})
    2'b00 : Y = I0;
    2'b01 : Y = I1;
    2'b10 : Y = I2;
    2'b11 : Y = I3;
endcase

end

endmodule
