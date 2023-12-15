`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/05 19:52:33
// Design Name: 
// Module Name: traffic_light_controller
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


module traffic_light_controller(rst, clk, time_spd, add_hour_btn, emgc_btn, LCD_E, LCD_RS, LCD_RW, LCD_DATA, N_tl, W_tl, S_tl, E_tl, Walk);

input rst, clk;
input add_hour_btn, emgc_btn;       //1�ð� ���ϴ� ��ɰ� emergency ��޻�Ȳ ������ ���� �����Ͽ���.
input [1:0] time_spd;               //2�� 3������ġ�� �Ҵ��Ͽ���.

output reg [3:0] N_tl, W_tl, S_tl, E_tl; // 4���� ����(N W S E) �� L,G,Y,R(������ traffic light)
output reg [7:0] Walk; // �� �� �� �� ���� ���� �ʷ� �̷��� 8���� �Ҵ�

output LCD_E, LCD_RS, LCD_RW;
output wire [7:0] LCD_DATA;             //��°����� LCD �ؽ�Ʈ�� ������ �־��־���.

wire d_or_n;                    // ���� ���� ���� ��츦 �����Ѵ�.
wire add_hour_btn_t, emgc_btn_t;    // ������ �ۼ��� �Ϳ� ���� ��� �߰��Ͽ���.
wire [7:0] hour, min, sec;    // �� �� �ʸ� ���� �Ҵ��Ѵ�.
wire LCD_E;

reg [3:0] state_t;       // ������ ���¸� ǥ���Ѵ�. A���� H �׸��� emergency A���� LCD���� state�� ����Ͽ����Ƿ� �������־���. state_traffic
reg [2:0] prev_state_t;     //���� ���¸� ��Ÿ����. �̰��� Emergency_A(emergency)�� �����Ƿ� 3��Ʈ�� ǥ�� �����ϴ�. //previous_state_traffic�̴�.
reg emgc;        // emergency ��޻�Ȳ�� ��츦 ǥ���Ѵ�. 
reg choose_d_or_n;  // �ְ� Ȥ�� �߰� �� ��� �����ϰ� ��Ÿ������ �����Ѵ٤�.


parameter A = 4'b0000,
          B = 4'b0001,
          C = 4'b0010,
          D = 4'b0011,
          E = 4'b0100,                 // ������ ���µ� ǥ���� ��
          F = 4'b0101,
          G = 4'b0110,
          H = 4'b0111,
          Emergency_A = 4'b1000, //emergency�� �� ���� A�� ǥ���Ѵ�.
          
          // L,G,Y,R,  NR,NG,WR,WG,SR,SG,ER,EG
            //�� ��  ��  ��  �����ȣ �� �� �� ��                             // ���� ��ȣ���� �� �� �� �� �ݽð�����̰� ���� ��ȣ�� �� �� �� �� �����̴�.
          //{N_tl,W_tl,S_tl,E_tl,Walk} <= ex. 24'b0000_0000_0000_0000_00_00_00_00;  4��Ʈ�� ������ ���� ������ȣ���̰� 2��Ʈ�� ������ ���� �����ȣ�̴�. 
          
                      
          
          // A_Color A_Color_Fade  A_Color_Orange A_Color_Orange_Fade ����
          //A ���� �Һ�
          A_C = 24'b0100_0001_0100_0001_10_01_10_01,      //�� �� �� ��, �� �� �� �� 
          A_C_F = 24'b0100_0001_0100_0001_10_00_10_00,    //�� �� �� ��, �� �� �� �� (�ʷϻ��� �����̱� ������ ���� ��ȣ �ʷϻ� �κ��� ���� ���̴�.
          A_C_O = 24'b0010_0010_0010_0010_10_01_10_01,    //�� �� �� ��, �� �� �� ��
          A_C_O_F = 24'b0010_0010_0010_0010_10_00_10_00,  //�� �� �� ��, �� �� �� ��  //���� ��ȣ�� �� �����ȣ �����̴� �� 2���� ��Ȳ�� ��ȣ�� �� �����̴� �� 2�� �� 4�� ǥ��
          // B ����
          B_C = 24'b1100_0001_0001_0001_10_10_10_01,      //�ʿ� �� �� ��, �� �� �� ��           
          B_C_F = 24'b1100_0001_0001_0001_10_10_10_00,    //�ʿ� �� �� ��,  �� �� �� ��
          B_C_O = 24'b0010_0010_0010_0010_10_10_10_01,    //�� �� �� ��, �� �� �� ��                
          B_C_O_F = 24'b0010_0010_0010_0010_10_10_10_00,  //�� �� �� ��, �� �� �� ��
          //C����
          C_C = 24'b0001_0001_1100_0001_10_01_10_10,      //�� �� �ʿ� ��, �� �� �� ��
          C_C_F = 24'b0001_0001_1100_0001_10_00_10_10,    //�� �� �ʿ� ��, �� �� �� ��
          C_C_O = 24'b0010_0010_0010_0010_10_01_10_10,    //�� �� �� ��, �� �� �� ��
          C_C_O_F = 24'b0010_0010_0010_0010_10_00_10_10,  //�� �� �� ��, �� �� �� ��
         // D ����
          D_C = 24'b1000_0001_1000_0001_10_10_10_10,      //�� �� �� ��, �� �� �� ��
          D_C_O = 24'b0010_0010_0010_0010_10_10_10_10,    //�� �� �� ��, �� �� �� �� //�� ��쿡�� �����ȣ�� �� �������̹Ƿ� �����̴� ���� �� ���µ�ó�� ������ �ʿ� ����.
        // E ����
          E_C = 24'b0001_0100_0001_0100_01_10_01_10,      //�� �� �� ��, �� �� �� ��
          E_C_F = 24'b0001_0100_0001_0100_00_10_00_10,    //�� �� �� ��, �� �� �� ��
          E_C_O = 24'b0010_0010_0010_0010_01_10_01_10,    //�� �� �� ��, �� �� �� ��
          E_C_O_F = 24'b0010_0010_0010_0010_00_10_00_10,  //�� �� �� ��, �� �� �� ��
         //F ����
          F_C = 24'b0001_1100_0001_0001_01_10_10_10,      //�� �ʿ� �� ��, �� �� �� ��
          F_C_F = 24'b0001_1100_0001_0001_00_10_10_10,    //�� �ʿ� �� ��, �� �� �� ��
          F_C_O = 24'b0010_0010_0010_0010_01_10_10_10,    //�� �� �� ��, �� �� �� ��
          F_C_O_F = 24'b0010_0010_0010_0010_00_10_10_10,  //�� �� �� ��, �� �� �� ��
         //G ����
          G_C = 24'b0001_0001_0001_1100_10_10_01_10,      //�� �� �� �ʿ�, �� �� �� ��
          G_C_F = 24'b0001_0001_0001_1100_10_10_00_10,    //�� �� �� �ʿ�, �� �� �� ��
          G_C_O = 24'b0010_0010_0010_0010_10_10_01_10,    //�� �� �� ��, �� �� �� ��
          G_C_O_F = 24'b0010_0010_0010_0010_10_10_00_10,  //�� �� �� ��, �� �� �� ��
        // H ����
          H_C = 24'b0001_1000_0001_1000_10_10_10_10,      // �� �� �� �� �����ȣ �� ����
          H_C_O = 24'b0010_0010_0010_0010_10_10_10_10,    //�� �� �� �� �����ȣ �� ����
          // 4���� ���� �Ҵ�
          north = 2'b00,
          west = 2'b01,
          south = 2'b10,
          east = 2'b11;

integer t_cnt;

integer emgc_cnt;           //integer�� ī���͸� �Ҵ��Ͽ���..

oneshot_universal #(.WIDTH(2)) u1(clk, rst, {add_hour_btn, emgc_btn}, {add_hour_btn_t, emgc_btn_t});
clock kshongmodule1(rst, clk, time_spd, add_hour_btn_t, hour, min, sec, d_or_n);
LCD kshongmodule2(rst, clk, hour, min, sec, d_or_n, state_t, LCD_E, LCD_RS, LCD_RW, LCD_DATA);  // ������ �������� �ۼ��Ͽ���.

 
//     ������ state�� ��츦 ǥ���Ͽ���.
always @(posedge clk or negedge rst)
begin
    if(!rst) begin        //������ Ȱ��ȭ�Ǹ� �Ʒ��� ������ �ʱ�ȭ�Ѵ�.
        state_t = B;        //���¸� B�� �����Ѵ�.
        t_cnt = 0;          //ī���͸� �ʱ�ȭ�Ѵ�.
        prev_state_t = H;      //���� ���¸� H�� �����Ѵ�.
        choose_d_or_n = 1;      //�ְ� �߰� ���¸� ��Ÿ���� ������ �ʱ�ȭ�Ѵ�. (1�� �߰��� ��Ÿ���� �ȴ�.)
        emgc = 0;              //emergency ���¸� �ʱ�ȭ�Ѵ�.
    end
    else begin
        if(emgc_btn_t) emgc = !emgc;     //emergency ��ư ������ ��� �̰��� �ҷ��´�.
        else begin                       //emergency �ƴ� ��� �Ʒ� ���µ��� ��Ÿ����.
        if(choose_d_or_n) begin // �߰��� ���
            case(state_t)
                B : begin
                    if(t_cnt >= 10000) begin      //B ���¿����� ���� : t_cnt�� 10000 �̻��� ��
                        if(emgc) begin            //emergency ���°� ������ ���  
                            state_t = Emergency_A;        //���¸� Emergency_A�� �����Ѵ�.
                            t_cnt = 0;            //ī���͸� �ʱ�ȭ�Ѵ�.
                            prev_state_t = B;     //���� ���¸� B�� �����Ѵ�. (emergency�� ������ ������ ���·� ���ƿ��� �Ѵ�.
                            choose_d_or_n = d_or_n;   //�ְ� Ȥ�� �߰� ��� �����Ѵ�.
                            emgc_cnt = 0;       //��� ī�����͸� �ʱ�ȣ�ä��Ѵ�.
                        end
                               
                        else begin          //��޻�Ȳ�� �ƴ� ���
                            state_t = A;       
                            t_cnt = 0;            //ī���� �ʱ�ȭ
                            prev_state_t = B;       //���� ���¸� B�� ���� (�翬�� �Ҹ��̴�.)
                            choose_d_or_n = d_or_n;       //�ְ� �߰� ��带 �����Ѵ�.
                        end 
                    end   
                    else begin//��޻�Ȳ
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin  //�������� ��ư�� ���� �� 1�� �Ŀ� emergency�� �Ͼ���� �����Ͽ���.
                                state_t = Emergency_A;    //�� ��� EMERGENCY ��Ȳ���� state A�� ����ȴ�. �Ʒ��ּ� ��޻�Ȳ A�� ���¸� �����Ͽ���.
                                t_cnt = 0;          //ī���� �ʱ�ȭ
                                emgc_cnt = 0;         //��� ī���� �ʱ�ȭ
                                choose_d_or_n = d_or_n;   //�ְ� �߰� ��� �����Ѵ�.
                                prev_state_t = B;       //���� ���¸� B�� �����Ѵ�.
                            end
                            else begin
                                t_cnt = t_cnt + 1;      //ī���� 1�� �����Ѵ�.
                                emgc_cnt = emgc_cnt + 1;        //���ī���� ���� 1�� �����Ѵ�.
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;          //��޻�Ȳ���� �ƴ� ��� ī���Ͱ� �����Ѵ�.
                        end
                    end
                end
                //������ ���µ鿡 ���ؼ��� ���� ���� ������� ��� �����Ѵ�.
                A : begin
                    if(t_cnt >= 10000) begin
                        if(emgc) begin
                            state_t = Emergency_A;
                            t_cnt = 0;
                            prev_state_t = A;
                            choose_d_or_n = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin              //A�� 2�� �����Ƿ� ������ ��츦 ����� �ۼ��Ѵ�.
                            if(prev_state_t == B) begin     //���� ���°� B�̸� A ���� ���� ���´� C���� �Ѵ�.
                                state_t = C;
                                t_cnt = 0;
                                prev_state_t = A;
                                choose_d_or_n = d_or_n;
                            end
                            else begin                      //���� ���°� B�� �ƴ϶�� A ������ E�� ���;� �Ѵ�.
                                state_t = E;
                                t_cnt = 0;
                                prev_state_t = A;
                                choose_d_or_n = d_or_n;
                            end
                        end 
                    end   
                    else begin          //��޻�Ȳ ���� �����ϰ� �д�. prev_state�� �ٸ��� �θ� �ȴ�. ��Ȳ�� �°� �����ϴ� ���̴�.
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                state_t = Emergency_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                choose_d_or_n = d_or_n;
                                prev_state_t = A;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                C : begin
                    if(t_cnt >= 10000) begin
                        if(emgc) begin
                            state_t = Emergency_A;
                            t_cnt = 0;
                            prev_state_t = C;
                            choose_d_or_n = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            state_t = A;
                            t_cnt = 0;
                            prev_state_t = C;
                            choose_d_or_n = d_or_n;
                        end 
                    end   
                    else begin
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                state_t = Emergency_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                choose_d_or_n = d_or_n;
                                prev_state_t = C;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                E : begin
                    if(t_cnt >= 10000) begin
                        if(emgc) begin
                            state_t = Emergency_A;
                            t_cnt = 0;
                            prev_state_t = E;
                            choose_d_or_n = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin                      
                            state_t = H;
                            t_cnt = 0;
                            prev_state_t = E;
                            choose_d_or_n = d_or_n;
                        end 
                    end   
                    else begin
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                state_t = Emergency_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                choose_d_or_n = d_or_n;
                                prev_state_t = E;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                H : begin
                    if(t_cnt >= 10000) begin
                        if(emgc) begin
                            state_t = Emergency_A;
                            t_cnt = 0;
                            prev_state_t = H;
                            choose_d_or_n = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            state_t = B;
                            t_cnt = 0;
                            prev_state_t = H;
                            choose_d_or_n = d_or_n;
                        end 
                    end   
                    else begin
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                state_t = Emergency_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                choose_d_or_n = d_or_n;
                                prev_state_t = H;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                Emergency_A : begin             //��޻�Ȳ �߻����̴�. ������ ������ ��Ȳ�� ��� �����Ͽ���.
                    if(t_cnt >= 15000) begin     //��ü�ð� 15�� ��޻�Ȳ �ð��� 15���̱� �����̴�.
                        state_t = prev_state_t;
                        choose_d_or_n = d_or_n;
                        t_cnt = 0;
                        emgc = 0;
                    end   
                    else t_cnt = t_cnt + 1;
                end
            endcase
        end    
        
        //�ְ��� ����̴�.            ���� �߰��� ���� �۵������ ������ state ���� �ð��� �߰��� �޸� 10�ʰ� �ƴ� 5���̹Ƿ� cnt �������� 5000���� �ξ���. 
        else begin
            case(state_t)
                A : begin
                    if(t_cnt >= 5000) begin
                        if(emgc) begin
                            state_t = Emergency_A;
                            t_cnt = 0;
                            prev_state_t = A;
                            choose_d_or_n = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            state_t = D;
                            t_cnt = 0;
                            prev_state_t = A;
                            choose_d_or_n = d_or_n;
                        end 
                    end   
                    else begin
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                state_t = Emergency_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                choose_d_or_n = d_or_n;
                                prev_state_t = A;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                D : begin
                    if(t_cnt >= 5000) begin
                        if(emgc) begin
                            state_t = Emergency_A;
                            t_cnt = 0;
                            prev_state_t = D;
                            choose_d_or_n = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            state_t = F;
                            t_cnt = 0;
                            prev_state_t = D;
                            choose_d_or_n = d_or_n;
                        end 
                    end   
                    else begin
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin 
                                state_t = Emergency_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                choose_d_or_n = d_or_n;
                                prev_state_t = D;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                
                F : begin
                    if(t_cnt >= 5000) begin
                        if(emgc) begin
                            state_t = Emergency_A;
                            t_cnt = 0;
                            prev_state_t = F;
                            choose_d_or_n = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            state_t = E;
                            t_cnt = 0;
                            prev_state_t = F;
                            choose_d_or_n = d_or_n;
                        end 
                    end   
                    else begin
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                state_t = Emergency_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                choose_d_or_n = d_or_n;
                                prev_state_t = F;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                E : begin
                    if(t_cnt >= 5000) begin
                        if(emgc) begin
                            state_t = Emergency_A;
                            t_cnt = 0;
                            prev_state_t = E;
                            choose_d_or_n = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                               if(prev_state_t == F) begin
                                    state_t = G;
                                    t_cnt = 0;
                                    prev_state_t = E;
                                    choose_d_or_n = d_or_n;
                                end
                                else begin
                                    state_t = A;
                                    t_cnt = 0;
                                    prev_state_t = E;
                                    choose_d_or_n = d_or_n;
                                end
                        end 
                    end   
                    else begin
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                state_t = Emergency_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                choose_d_or_n = d_or_n;
                                prev_state_t = E;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                G : begin
                    if(t_cnt >= 5000) begin
                        if(emgc) begin
                            state_t = Emergency_A;
                            t_cnt = 0;
                            prev_state_t = G;
                            choose_d_or_n = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            state_t = E;
                            t_cnt = 0;
                            prev_state_t = G;
                            choose_d_or_n = d_or_n;
                        end 
                    end   
                    else begin
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                state_t = Emergency_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                choose_d_or_n = d_or_n;
                                prev_state_t = G;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                Emergency_A : begin
                    if(t_cnt >= 15000) begin
                        state_t = prev_state_t;
                        choose_d_or_n = d_or_n;
                        t_cnt = 0;
                        emgc = 0;
                    end   
                    else t_cnt = t_cnt + 1;
                end
            endcase
        end
        end
    end
end

always @(posedge clk or negedge rst)        //��ȣ�� ���� ǥ�� �� ������ ���¿��� ��ȣ�� ǥ���� ��Ÿ������.
begin
    if(!rst) {N_tl,W_tl,S_tl,E_tl,Walk} <= 24'b0000_0000_0000_0000_00_00_00_00;         //���� ���� �� ��� ���� ������ �����Ͽ���.
    else begin
        if(choose_d_or_n) begin // �߰�   //�ϴ� �߰��� ������Ʈ �����ð��� �����ð� �������� 10�ʷ� ������ �ٷ� �Ʒ����� �����Ͽ���.
            case(state_t)
                B : begin                                   //�� cnt�� 10000���� ����Ǹ� 5000 ������ ���굿�� ���� ������ ������ �ð����� ���굿���� �־��־���.
                                                            //�ڼ��� ������ �������� clock���� �����Ѵ�.
                    if(emgc) {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C_O;   //emergency ��Ȳ �߻� �� B�� Emergency_A ���̿� ��Ȳ�� ��ȣ�� �־���. 1�� �Ŀ� ��޻�Ȳ�� �߻��ϵ��� ������ �����Ͽ���.
                    else begin
                        if(t_cnt < 5000) {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C;   //�߰� ������Ʈ �����ð� �ϴ� �����ȣ �����̱� ������ 5�ʷ� ���� ������ ������Ʈ�� ��쿡�� ���� ���
                        else if(t_cnt >= 5000 & t_cnt < 5500) {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C_F;
                        else if(t_cnt >= 5500 & t_cnt < 6000) {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C;
                        else if(t_cnt >= 6000 & t_cnt < 6500) {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C_F;
                        else if(t_cnt >= 6500 & t_cnt < 7000) {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C;
                        else if(t_cnt >= 7000 & t_cnt < 7500) {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C_F;
                        else if(t_cnt >= 7500 & t_cnt < 8000) {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C;
                        else if(t_cnt >= 8000 & t_cnt < 8500) {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C_F;      //0.5�� ������ �����̴� ���̴�.
                        else if(t_cnt >= 8500 & t_cnt < 9000) {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C;    //���ݱ��� �����ȣ �����Ÿ��°� ǥ�� ������ ī���� 500 �ֱ�� �ξ���.(0.5��)
                        else if(t_cnt >= 9000 & t_cnt < 9500) {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C_O_F;  //��Ȳ�� ��ȣ ����
                        else {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C_O; //�� ���� ���������� �߰� ��ȣ ������Ʈ �����ð� 10�ʷ� ������ ���̴�.
                    end
                end
                //�� state B�� ���������� ������ ���µ鵵 ���� ������� �ξ���.
                A : begin
                    if(emgc) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_O;
                    else begin
                        if(t_cnt < 5000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;
                        else if(t_cnt >= 5000 & t_cnt < 5500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;
                        else if(t_cnt >= 5500 & t_cnt < 6000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;
                        else if(t_cnt >= 6000 & t_cnt < 6500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;
                        else if(t_cnt >= 6500 & t_cnt < 7000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;
                        else if(t_cnt >= 7000 & t_cnt < 7500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;
                        else if(t_cnt >= 7500 & t_cnt < 8000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;
                        else if(t_cnt >= 8000 & t_cnt < 8500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;
                        else if(t_cnt >= 8500 & t_cnt < 9000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;
                        else if(t_cnt >= 9000 & t_cnt < 9500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_O_F;
                        else {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_O;
                    end
                end
                
                C : begin
                    if(emgc) {N_tl,W_tl,S_tl,E_tl,Walk} <= C_C_O;
                    else begin
                        if(t_cnt < 5000) {N_tl,W_tl,S_tl,E_tl,Walk} <= C_C;
                        else if(t_cnt >= 5000 & t_cnt < 5500) {N_tl,W_tl,S_tl,E_tl,Walk} <= C_C_F;
                        else if(t_cnt >= 5500 & t_cnt < 6000) {N_tl,W_tl,S_tl,E_tl,Walk} <= C_C;
                        else if(t_cnt >= 6000 & t_cnt < 6500) {N_tl,W_tl,S_tl,E_tl,Walk} <= C_C_F;
                        else if(t_cnt >= 6500 & t_cnt < 7000) {N_tl,W_tl,S_tl,E_tl,Walk} <= C_C;
                        else if(t_cnt >= 7000 & t_cnt < 7500) {N_tl,W_tl,S_tl,E_tl,Walk} <= C_C_F;
                        else if(t_cnt >= 7500 & t_cnt < 8000) {N_tl,W_tl,S_tl,E_tl,Walk} <= C_C;
                        else if(t_cnt >= 8000 & t_cnt < 8500) {N_tl,W_tl,S_tl,E_tl,Walk} <= C_C_F;
                        else if(t_cnt >= 8500 & t_cnt < 9000) {N_tl,W_tl,S_tl,E_tl,Walk} <= C_C;
                        else if(t_cnt >= 9000 & t_cnt < 9500) {N_tl,W_tl,S_tl,E_tl,Walk} <= C_C_O_F;
                        else {N_tl,W_tl,S_tl,E_tl,Walk} <= C_C_O;
                    end
                end
                
                E : begin
                if(emgc) {N_tl,W_tl,S_tl,E_tl,Walk} <= E_C_O;
                    else begin
                        if(t_cnt < 5000) {N_tl,W_tl,S_tl,E_tl,Walk} <= E_C;
                        else if(t_cnt >= 5000 & t_cnt < 5500) {N_tl,W_tl,S_tl,E_tl,Walk} <= E_C_F;
                        else if(t_cnt >= 5500 & t_cnt < 6000) {N_tl,W_tl,S_tl,E_tl,Walk} <= E_C;
                        else if(t_cnt >= 6000 & t_cnt < 6500) {N_tl,W_tl,S_tl,E_tl,Walk} <= E_C_F;
                        else if(t_cnt >= 6500 & t_cnt < 7000) {N_tl,W_tl,S_tl,E_tl,Walk} <= E_C;
                        else if(t_cnt >= 7000 & t_cnt < 7500) {N_tl,W_tl,S_tl,E_tl,Walk} <= E_C_F;
                        else if(t_cnt >= 7500 & t_cnt < 8000) {N_tl,W_tl,S_tl,E_tl,Walk} <= E_C;
                        else if(t_cnt >= 8000 & t_cnt < 8500) {N_tl,W_tl,S_tl,E_tl,Walk} <= E_C_F;
                        else if(t_cnt >= 8500 & t_cnt < 9000) {N_tl,W_tl,S_tl,E_tl,Walk} <= E_C;
                        else if(t_cnt >= 9000 & t_cnt < 9500) {N_tl,W_tl,S_tl,E_tl,Walk} <= E_C_O_F;
                        else {N_tl,W_tl,S_tl,E_tl,Walk} <= E_C_O;
                    end
                end
                
                H : begin      //H�� ��쿡�� �����ȣ�� �����̴� ���� �����Ƿ� �� ���µ�ó�� �����̴� ���� ������ �ʿ䰡 ����. ���� �ڵ尡 ª��.
                    if(emgc) {N_tl,W_tl,S_tl,E_tl,Walk} <= H_C_O;
                    else begin
                        if(t_cnt < 8500) {N_tl,W_tl,S_tl,E_tl,Walk} <= H_C;
                        else {N_tl,W_tl,S_tl,E_tl,Walk} <= H_C_O;
                        end
                    end
                
                Emergency_A : begin    //�߰��� ��� emergency�̴�. (��������� ���)
                    if(t_cnt < 7500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;   //��ü �ð��� 15�ʵ��� ����Ǳ� ������ �켱 �����ȣ �����̱� �� ������ 7.5�ʷ� �ξ���.
                    else if(t_cnt >= 7500 & t_cnt < 8000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;
                    else if(t_cnt >= 8000 & t_cnt < 8500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;
                    else if(t_cnt >= 8500 & t_cnt < 9000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;
                    else if(t_cnt >= 9000 & t_cnt < 9500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;
                    else if(t_cnt >= 9500 & t_cnt < 10000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;
                    else if(t_cnt >= 10000 & t_cnt < 10500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;
                    else if(t_cnt >= 10500 & t_cnt < 11000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;                
                    else if(t_cnt >= 11000 & t_cnt < 11500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;
                    else if(t_cnt >= 11500 & t_cnt < 12000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;
                    else if(t_cnt >= 12000 & t_cnt < 12500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;
                    else if(t_cnt >= 12500 & t_cnt < 13000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;
                    else if(t_cnt >= 13000 & t_cnt < 13500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;                    
                    else if(t_cnt >= 13500 & t_cnt < 14000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;   //������� �����ȣ 0.5�� ������ �����̰� �ξ���. cnt�� 500 ������ �� ���̴�.
                    else if(t_cnt >= 14000 & t_cnt < 14500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_O;
                    else {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_O_F;
                end
            endcase
        end
        
        else begin    //�ְ��� ����̴�.
            case(state_t)
                A : begin                               //��ü ī���͸� 5000���� ��� 2500���� ���굿�� ���ϰ� ������ ������ �ð����� �����ȣ�� ���굿���� �����Ѵ�.
                    if(emgc) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_O;
                    else begin                                                                  //�ְ� ������Ʈ �����ð��� �����ð� �������� 5���̹Ƿ� 
                        if(t_cnt < 2500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;                         //�� �����̴� �ð� 2.5�� �����̴� �ð� 2.5�� �̷��� �־���.
                        else if(t_cnt >= 2500 & t_cnt < 3000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;
                        else if(t_cnt >= 3000 & t_cnt < 3500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;
                        else if(t_cnt >= 3500 & t_cnt < 4000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;
                        else if(t_cnt >= 4000 & t_cnt < 4500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_O;
                        else {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_O_F;
                    end
                end
                                                    //�������� ���� ������� ��� �ϸ� �ȴ�.
                D : begin
                    if(emgc) {N_tl,W_tl,S_tl,E_tl,Walk} <= D_C_O;
                    else begin
                        if(t_cnt < 3500) {N_tl,W_tl,S_tl,E_tl,Walk} <= D_C;
                        else {N_tl,W_tl,S_tl,E_tl,Walk} <= D_C_O;
                    end
                end
                
                F : begin
                    if(emgc) {N_tl,W_tl,S_tl,E_tl,Walk} <= F_C_O;
                    else begin
                        if(t_cnt < 2500) {N_tl,W_tl,S_tl,E_tl,Walk} <= F_C;
                        else if(t_cnt >= 2500 & t_cnt < 3000) {N_tl,W_tl,S_tl,E_tl,Walk} <= F_C_F;
                        else if(t_cnt >= 3000 & t_cnt < 3500) {N_tl,W_tl,S_tl,E_tl,Walk} <= F_C;
                        else if(t_cnt >= 3500 & t_cnt < 4000) {N_tl,W_tl,S_tl,E_tl,Walk} <= F_C_F;
                        else if(t_cnt >= 4000 & t_cnt < 4500) {N_tl,W_tl,S_tl,E_tl,Walk} <= F_C_O;
                        else {N_tl,W_tl,S_tl,E_tl,Walk} <= F_C_O_F;
                    end
                end
                
                E : begin
                    if(emgc) {N_tl,W_tl,S_tl,E_tl,Walk} <= E_C_O;
                    else begin
                        if(t_cnt < 2500) {N_tl,W_tl,S_tl,E_tl,Walk} <= E_C;
                        else if(t_cnt >= 2500 & t_cnt < 3000) {N_tl,W_tl,S_tl,E_tl,Walk} <= E_C_F;
                        else if(t_cnt >= 3000 & t_cnt < 3500) {N_tl,W_tl,S_tl,E_tl,Walk} <= E_C;
                        else if(t_cnt >= 3500 & t_cnt < 4000) {N_tl,W_tl,S_tl,E_tl,Walk} <= E_C_F;
                        else if(t_cnt >= 4000 & t_cnt < 4500) {N_tl,W_tl,S_tl,E_tl,Walk} <= E_C_O;
                        else {N_tl,W_tl,S_tl,E_tl,Walk} <= E_C_O_F;
                    end
                end
                
                G : begin
                    if(emgc) {N_tl,W_tl,S_tl,E_tl,Walk} <= G_C_O;
                    else begin
                        if(t_cnt < 2500) {N_tl,W_tl,S_tl,E_tl,Walk} <= G_C;
                        else if(t_cnt >= 2500 & t_cnt < 3000) {N_tl,W_tl,S_tl,E_tl,Walk} <= G_C_F;
                        else if(t_cnt >= 3000 & t_cnt < 3500) {N_tl,W_tl,S_tl,E_tl,Walk} <= G_C;
                        else if(t_cnt >= 3500 & t_cnt < 4000) {N_tl,W_tl,S_tl,E_tl,Walk} <= G_C_F;
                        else if(t_cnt >= 4000 & t_cnt < 4500) {N_tl,W_tl,S_tl,E_tl,Walk} <= G_C_O;
                        else {N_tl,W_tl,S_tl,E_tl,Walk} <= G_C_O_F;
                    end
                end
                
                Emergency_A : begin
                    if(t_cnt < 7500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;
                    else if(t_cnt >= 7500 & t_cnt < 8000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;
                    else if(t_cnt >= 8000 & t_cnt < 8500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;
                    else if(t_cnt >= 8500 & t_cnt < 9000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;
                    else if(t_cnt >= 9000 & t_cnt < 9500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;
                    else if(t_cnt >= 9500 & t_cnt < 10000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;
                    else if(t_cnt >= 10000 & t_cnt < 10500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;
                    else if(t_cnt >= 10500 & t_cnt < 11000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;                
                    else if(t_cnt >= 11000 & t_cnt < 11500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;
                    else if(t_cnt >= 11500 & t_cnt < 12000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;
                    else if(t_cnt >= 12000 & t_cnt < 12500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;
                    else if(t_cnt >= 12500 & t_cnt < 13000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;
                    else if(t_cnt >= 13000 & t_cnt < 13500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;                    
                    else if(t_cnt >= 13500 & t_cnt < 14000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;
                    else if(t_cnt >= 14000 & t_cnt < 14500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_O;
                    else {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_O_F;
                end
            endcase
        end
    end
end


endmodule

