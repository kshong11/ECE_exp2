`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/07 11:15:47
// Design Name: 
// Module Name: full_adder_tb
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


module full_adder_tb();
    reg a, b, cin;
    wire s, cout;

    full_adder_design tfa(a,b,cin,s,cout);
  
    initial begin

        a=1'b0; b=1'b0; cin=0;  //initial문에서 최초값이 없으면 오류
        #20                     //20ns 지연
        a=1'b0; b=1'b1; cin=0;  
        #20                     
        a=1'b1; b=1'b0; cin=0;
        #20
        a=1'b1; b=1'b1; cin=0;
        #40
        a=1'b0; b=1'b0; cin=1;  //initial문에서 최초값이 없으면 오류
        #20                     //20ns 지연
        a=1'b0; b=1'b1; cin=1;  
        #20                     
        a=1'b1; b=1'b0; cin=1;
        #20
        a=1'b1; b=1'b1; cin=1;
    end

endmodule
