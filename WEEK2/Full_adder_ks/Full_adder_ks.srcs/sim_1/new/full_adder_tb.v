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
    //wire 10�� ���ÿ� ����

    full_adder_design tfa(a,b,cin,s,cout);
    //��� �ܺο��� input���� wire, reg ��� ����� �� �ִ�
    //��� �ܺο��� output���� wire���� ����� �� �ִ�
    //����� output�� �����Ѵٴ� ���� wire�� ��⿡ assign�ϴ� �Ͱ� ���� ����
    
    initial begin
        //initial���� �׽�Ʈ��ġ������ ��� ����
        a=1'b0; b=1'b0; cin=0;  //initial������ ���ʰ��� ������ ������
        #20                     //20ns ����
        a=1'b0; b=1'b1; cin=0;  //1'b0�� ������(b) 1��Ʈ�� ���� 0�̶�� ��
        #20                     //8'd32�� ������(d) 8��Ʈ�� ���� 32��� ��(==8'b00010000)
        a=1'b1; b=1'b0; cin=0;
        #20
        a=1'b1; b=1'b1; cin=0;
        #40
        a=1'b0; b=1'b0; cin=1;  //initial������ ���ʰ��� ������ ������
        #20                     //20ns ����
        a=1'b0; b=1'b1; cin=1;  //1'b0�� ������(b) 1��Ʈ�� ���� 0�̶�� ��
        #20                     //8'd32�� ������(d) 8��Ʈ�� ���� 32��� ��(==8'b00010000)
        a=1'b1; b=1'b0; cin=1;
        #20
        a=1'b1; b=1'b1; cin=1;
    end

endmodule
