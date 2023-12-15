`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/27 10:10:54
// Design Name: 
// Module Name: clock
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


module clock(rst, clk, time_spd, add_hour_btn_t, hour, min, sec, d_or_n);

input rst, clk;
input [1:0] time_spd;               //2��Ʈ�� ���� 1�� 10�� 100�� 200�� ��� ����
input add_hour_btn_t;       //1�ð� �߰�
output reg d_or_n;                  //��� ��ȣ�� ��Ÿ������. �� Ȥ�� ������
output reg [7:0] hour, min, sec;        //�� �� �ʷ� ��� ��ȣ�� ��Ÿ������.

reg [12:0] c;       //�ð��� �����ϴ� ī���͸� ��Ÿ����.

reg cts1, s1ts10, s10tm1, m1tm10, m10th1, h1th10, h10tday; //����� ��Ÿ������. ������ �ǹ̴� �Ʒ��� �����Ͽ���.

wire cts1_t, s1ts10_t, s10tm1_t, m1tm10_t, m10th1_t, h1th10_t, h10tday_t;   //�� ���� Ʈ���ŵ� �͵��̴�.


oneshot_universal #(.WIDTH(7)) u2(clk, rst, {cts1, s1ts10, s10tm1, m1tm10, m10th1, h1th10, h10tday}, {cts1_t, s1ts10_t, s10tm1_t, m1tm10_t, m10th1_t, h1th10_t, h10tday_t});

always @(negedge rst or posedge clk) begin // �ð� ��� ��Ÿ����.
    if(~rst) begin;
        c = 0;          //���� ���¿����� ī���� �� ����� �ʱ�ȭ�Ѵ�.
        cts1=0;             // counter to second one
    end
    else begin
        case(time_spd)   //DIP ����ġ 2���� 3���� �Ҵ��Ͽ� �ø� ������ ����� �ϰ� ������־���.
            2'b00 : 
                if(c>=1000) begin           // 1000/1000�̾ �⺻������ 1�� ������. ���� �ð� ����̴�.
                    cts1 = 1;           //1000Ŭ�� �ֱ⸶�� cts1�� ����ϰ� c�� 0�� �ʱ�ȭ�Ѵ�.
                    c=0;                //�̰��� �⺻���� �ð� �����̴�. ���� ������ ���� �� ��� �� �������� �����Ѵ�.
                end
                else begin
                    c=c+1;
                    cts1=0;
                end
            2'b01 : if(c>=100) begin        // 1000/100 �Ͽ� 10�� ���������� �����Ͽ���.
                    cts1 = 1;            //100Ŭ�� �ֱ⸶�� cts1�� ����ϰ� c�� 0�� �ʱ�ȭ�Ѵ�.
                    c=0;
                end
                else begin
                    c=c+1;
                    cts1=0;
                end
            2'b10 : if(c>=10) begin         // 1000/10 �ؼ� 100�� ���������� �����Ͽ���.
                    cts1 = 1;        //10Ŭ�� �ֱ⸶�� cts1�� ����ϰ� c�� 0�� �ʱ�ȭ�Ѵ�.
                    c=0;    
                end
                else begin
                    c=c+1;
                    cts1=0;
                end
            2'b11 : if(c>=5) begin   //  1000/5 �Ͽ� 200�� ���������� �����صξ���.
                    cts1 = 1;        //5Ŭ�� �ֱ⸶�� cts1�� ����ϰ� c�� 0�� �ʱ�ȭ�Ѵ�.
                    c=0;
                end
                else begin
                    c=c+1;
                    cts1=0;
                end
        endcase
    end
end


            // �� �� �� ���� 10�� �ڸ��� 1�� �ڸ��� ������ ������ �����ϴ� ����� �����Ͽ���.
always @(negedge rst or posedge clk) begin //sec[3:0] ���� ���
    if(~rst) begin
        sec[3:0] = 0;
        s1ts10=0;            //second 1 to second 10
    end
    else begin
        if(cts1_t) begin            //�ð� ��ȣ�� ���� ���
            if(sec[3:0]==9) begin           //�ʰ� 9�� ������ ���
                sec[3:0]<=0;                //�ʸ� 0���� �ʱ�ȭ�Ѵ�.
                s1ts10<=1;                   //s1ts10�� 1�� �����Ͽ� ���� ���·� �̵��Ѵ�.
            end
            else begin
                sec[3:0] <= sec[3:0] + 1;       //�ʰ� 9�� �������� ������ �ʸ� 1 ������Ų��.
                s1ts10<=0;               //s1ts10�� 0���� ��� �д�.
            end
        end
    end
end

always @(negedge rst or posedge clk) begin //sec[7:4] ���� ���
    if(~rst) begin
        sec[7:4] = 0;               //���� ���¿��� ��� 0���� �ʱ�ȭ
        s10tm1=0;                    //second 10 to minute 1
    end
    else begin
        if(s1ts10_t) begin           //���� ��Ͽ��� Ʈ���ŵ� ���½�ȣ�� s1ts10_t�� �����Ǹ� ����
            if(sec[7:4]==5) begin   // sec[7:4]�� 5�� ������ ��� (���� �ڸ� ���� 5)
                sec[7:4]<=0;        // 0���� �ʱ�ȭ
                s10tm1<=1;           //s10tm1 ���½�ȣ�� 1�� �����Ͽ� ���� ���·� �̵�
            end
            else begin      //5�� �������� ���� ��� [7:4] �κ� �ʴ� 1 ������Ű��
                sec[7:4] <= sec[7:4] + 1;           
                s10tm1<=0;                   // s10tm1�� 0���� �д�.
            end
        end
    end
end

always @(negedge rst or posedge clk) begin //min[3:0] ���� ���
    if(~rst) begin
        min[3:0] = 0;
        m1tm10=0;                //minute 1 to minute 10
    end
    else begin
        if(s10tm1_t) begin           //���� ��Ͽ��� Ʈ���ŵ� ���½�ȣ  s10tm1_t�� �����Ǹ� �����Ѵ�.
            if(min[3:0]==9) begin           //�����ڸ� ���� 9�� ����
                min[3:0]<=0;            //�����ڸ� ���� 0���� �д�.
                m1tm10<=1;               //���� �ڸ� ���� 1�� �д�.
            end
            else begin
                min[3:0] <= min[3:0] + 1;       //�����ڸ� ���� 9�� ���޾��� ���
                m1tm10<=0;               //�����ڸ� ���� 0���� �д�.
            end
        end
    end
end

always @(negedge rst or posedge clk) begin //min[7:4] ���� ���
    if(~rst) begin          //���»��� 0���� �ʱ�ȭ ����
        min[7:4] = 0;
        m10th1=0;                //mimute 10 to hour 1
    end
    else begin
        if(m1tm10_t) begin           //���� ��Ͽ��� Ʈ���ŵ� ���½�ȣ m1tm10_t�� �����Ǹ� ����
            if(min[7:4]==5) begin       //�����ڸ� ���� 5�� ������ ���
                min[7:4]<=0;            // �����ڸ� ���� 0���� �д�.
                m10th1<=1;           //���� �ڸ� �ø� 1�� �д�. ���� ���·� �̵�
            end
            else begin              //�����ڸ� �� 5 �������� �ʾ��� ���
                min[7:4] <= min[7:4] + 1;        //�����ڸ� �� 1 ������Ų��.
                m10th1<=0;           //�����ڸ� �ô� 0���� �д�.
            end
        end
    end
end

always @(negedge rst or posedge clk) begin //hour[3:0] ���� ���
    if(~rst) begin              //���� ���������� ���� ���¸� �����Ͽ���.
        hour[3:0] = 0;
        h1th10=0;            //hout 1 to hour 10
        h10tday=0;             //hour 10 to day(�� Ȥ�� ��)
    end
    else begin          // ���� ��Ͽ��� Ʈ���ŵ� ������ m10th1_t Ȥ�� add_hour_btn_t�� �����ϸ� �����Ѵ�.
        if(m10th1_t | add_hour_btn_t) begin      
            if(hour[3:0]==9) begin      // �����ڸ� �ð� 9�� ������ ���
                hour[3:0]<=0;       //�����ڸ� �ø� 0���� �д�.
                h1th10 <= 1;             //�����ڸ� �ø� 1�� �д�.
            end
            else begin      //���� �ڸ� �ð� 9�� �������� ���� ���
                if(hour[3:0]==3 & hour[7:4]==2) begin   //���� 23���� ��쿡 �����ϴ� ���       
                    hour[3:0]<=0;           //�ô� 0���� �д�.
                    h10tday <= 1;              //(���½�ȣ h10tday�� 1�� ������ �������� �̵�)
                end                   
                else begin                //�ٷ� �� ���� �������� ���� ���
                    hour[3:0] <= hour[3:0] + 1;     //�����ڸ� �ø� 1 ������Ų��.
                    h10tday <= 0;
                    h1th10 <= 0;
                end
            end
        end
    end
end

always @(negedge rst or posedge clk) begin    //hour[7:4] ���� ���
    if(~rst) begin
        hour[7:4] = 0;          //���������� ���� �����̴�.
    end
    else begin              //���� ��Ͽ��� Ʈ���ŵ� ���½�ȣ h10tday_t�� �����Ǿ��� ��
        if(h10tday_t) hour[7:4]<=0;    //�����ڸ� �ø� 0���� �ʱ�ȭ
        else begin                  //�ƴ� ���
            if(h1th10_t) hour[7:4] <= hour[7:4] + 1; //���� �ڸ� �ø� 1 ����
        end
    end
end

always @(negedge rst or posedge clk) begin
    if(~rst) begin
        d_or_n = 1; //0:�� , 1:��  
    end
    else begin              // ���� �ð�(��)�� 8 �̻� 23 �̸��� ��� 
        if(hour[7:4]*10 + hour[3:0] >= 8 & hour[7:4]*10 + hour[3:0] < 23) begin
            d_or_n <= 0;            //0���� �д�. (��)
        end                 //�� ������ �ƴ� ���
        else d_or_n <= 1;               //1�� �д�. (��)
    end
end

endmodule
