`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/18 16:07:12
// Design Name: 
// Module Name: DAC
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


module DAC(clk, rst, btn, add_sel, dac_csn, dac_ldacn, dac_wrn, dac_a_b, dac_d, led_out);
input clk, rst;
input[8:0] btn;
input add_sel;
output reg dac_csn, dac_ldacn, dac_wrn, dac_a_b;
output reg [7:0] dac_d;
output reg [7:0] led_out;

reg [7:0] dac_d_temp;
reg [7:0] cnt;
wire [8:0] btn_t;

reg [1:0] state;

parameter DELAY   = 2'b00,
          SET_WRN = 2'b01,
          UP_DATA = 2'b10;
          
oneshot_universal #(.WIDTH(9)) O1(clk, rst, {btn[8:0]}, {btn_t[8:0]});



always @(posedge clk or negedge rst) begin
    if(!rst) begin
        state <= DELAY;
    end
    else begin
        case(state)
            DELAY   : if(cnt == 200) state <= SET_WRN;
            SET_WRN : if(cnt == 50) state <= UP_DATA;
            UP_DATA : if(cnt == 30) state <= DELAY;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst)
        cnt <= 8'b0000_0000;
    else begin
        case(state)
            DELAY :
            if(cnt >= 200) cnt <= 0;
            else cnt <= cnt + 1;
        SET_WRN :
            if(cnt >= 50) cnt <= 0;
            else cnt <= cnt + 1;
        UP_DATA :
            if(cnt >= 30) cnt <= 0;
            else cnt <= cnt + 1;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        dac_wrn <= 1;
    end
    else begin
        case(state)
          DELAY   :
           dac_wrn <= 1;
           SET_WRN :
           dac_wrn <= 0;
           UP_DATA :
          dac_d <= dac_d_temp;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        dac_d_temp <= 8'b0000_0000;
        led_out <= 8'b0101_0101;
    end
    else begin
        if(btn_t == 9'b100000000) dac_d_temp <= dac_d_temp - 8'b0000_0001;
        else if(btn_t == 9'b010000000) dac_d_temp <= dac_d_temp;
        else if(btn_t == 9'b001000000) dac_d_temp <= dac_d_temp + 8'b0000_0001;
        else if(btn_t == 9'b000100000) dac_d_temp <= dac_d_temp - 8'b0000_0010;
        else if(btn_t == 9'b000010000) dac_d_temp <= dac_d_temp;
        else if(btn_t == 9'b000001000) dac_d_temp <= dac_d_temp + 8'b0000_0010;
        else if(btn_t == 9'b000000100) dac_d_temp <= dac_d_temp - 8'b0000_1000;
        else if(btn_t == 9'b000000010) dac_d_temp <= dac_d_temp;
        else if(btn_t == 9'b000000001) dac_d_temp <= dac_d_temp + 8'b0000_1000;
        led_out <= dac_d_temp;
    end
end

always @(posedge clk) begin
    dac_csn <= 0;
    dac_ldacn <= 0;
    dac_a_b <= add_sel;
end
endmodule
