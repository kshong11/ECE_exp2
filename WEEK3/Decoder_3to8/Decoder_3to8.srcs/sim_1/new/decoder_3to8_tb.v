`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/13 10:04:30
// Design Name: 
// Module Name: decoder_3to8_tb
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

module decoder_3to8_tb();
  reg x, y, z;
  wire [7:0] D;
  decoder_3to8 kshongmodule (
    .x(x), .y(y), .z(z), .D(D)
  );
  initial begin
        x = 1'b0; y = 1'b0; z = 1'b0;
        #10;
        x = 1'b0; y = 1'b0; z = 1'b1;
        #10;
        x = 1'b0; y = 1'b1; z = 1'b0;
        #10;
        x = 1'b0; y = 1'b1; z = 1'b1;
        #10;
        x = 1'b1; y = 1'b0; z = 1'b0;
        #10;
        x = 1'b1; y = 1'b0; z = 1'b1;
        #10;
        x = 1'b1; y = 1'b1; z = 1'b0;
        #10;
        x = 1'b1; y = 1'b1; z = 1'b1;
        #10;
    end
endmodule
