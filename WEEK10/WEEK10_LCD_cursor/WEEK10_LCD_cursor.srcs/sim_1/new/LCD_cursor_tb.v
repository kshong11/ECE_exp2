`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/13 21:31:35
// Design Name: 
// Module Name: LCD_cursor_tb
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


module LCD_cursor_tb();
reg rst, clk;
wire LCD_E;
wire LCD_RS, LCD_RW;
wire [7:0] LCD_DATA;
wire [7:0] LED_out;
reg [9:0] number_btn;
reg [1:0] control_btn;

LCD_cursor kshongmodule(rst ,clk, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out, number_btn, control_btn);
initial begin
    clk<=0;
    rst<=0;
    number_btn<=0;
    control_btn<=0;
    #0.1 rst<=0;
    #0.1 rst<=1;

#1e+6; number_btn<=10'b0010_0000_00; //3
#1e+6; number_btn<=10'b0000_0000_00; 
#1e+6; number_btn<=10'b0000_0010_00; //7
#1e+6; number_btn<=10'b0000_0000_00;
#1e+6; control_btn <=2'b10;          //left
#1e+6; control_btn <=2'b00;          
#1e+6; control_btn <=2'b01;          //right
#1e+6; control_btn <=2'b00;


end
always begin
#0.5 clk <= ~clk;
end
endmodule
