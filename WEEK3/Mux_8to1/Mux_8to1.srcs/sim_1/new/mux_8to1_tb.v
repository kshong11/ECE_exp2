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


module mux_8to1_tb();
  reg [3:0] I0, I1, I2, I3, I4, I5, I6, I7;
  reg S0, S1, S2;
  wire [3:0] Y;

  mux_8to1 kshongmodule(I0, I1, I2, I3, I4, I5, I6, I7, S0, S1, S2, Y);

  initial begin
    I0 = 4'b0000; 
    I1 = 4'b0001; 
    I2 = 4'b0010; 
    I3 = 4'b0011;
    I4 = 4'b0100; 
    I5 = 4'b0101; 
    I6 = 4'b0110;
    I7 = 4'b0111; 

    S0 = 0; S1 = 0; S2 = 0; 
    #10 S0 = 1; S1 = 0; S2 = 0;
    #10 S0 = 0; S1 = 1; S2 = 0;
    #10 S0 = 1; S1 = 1; S2 = 0; 
    #10 S0 = 0; S1 = 0; S2 = 1; 
    #10 S0 = 1; S1 = 0; S2 = 1; 
    #10 S0 = 0; S1 = 1; S2 = 1; 
    #10 S0 = 1; S1 = 1; S2 = 1; 
  end

endmodule
