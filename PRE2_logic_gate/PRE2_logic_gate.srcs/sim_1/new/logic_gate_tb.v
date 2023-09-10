`timescale 10ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/07 01:06:27
// Design Name: 
// Module Name: logic_gate_tb
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


module logic_gate_tb();
    reg a, b;
    wire v,w,x,y,z;
    logic_gate mymodule(
        .a(a), .b(b),
        .v(v),.w(w),.x(x),.y(y),.z(z)
    );

    initial begin
        a=1'b0; b=1'b0; 
        #20             
        a=1'b0; b=1'b1; 
        #20             
        a=1'b1; b=1'b0; 
        #20
        a=1'b1; b=1'b1; 
    end

endmodule


