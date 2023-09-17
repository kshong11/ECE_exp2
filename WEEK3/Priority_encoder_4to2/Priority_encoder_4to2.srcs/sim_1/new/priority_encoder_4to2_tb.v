`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/15 14:21:50
// Design Name: 
// Module Name: priority_encoder_4to2_tb
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


module priority_encoder_4to2_tb;
  reg [3:0] D;
  wire x, y, v;

  priority_encoder_4to2 kshongmodule (
    .D(D), .x(x), .y(y), .v(v)
  );

  initial begin

    // Test case 1: 0000
    D = 4'b0000;
    #10;
    // Test case 2: 1000
    D = 4'b1000;
    #10;
    // Test case 3: 1011
    D = 4'b1011;
    #10;
    // Test case 4: 0101
    D = 4'b0101;
    #10;
    // Test case 5: 0001
    D = 4'b0001;
    #10;
  end
endmodule
