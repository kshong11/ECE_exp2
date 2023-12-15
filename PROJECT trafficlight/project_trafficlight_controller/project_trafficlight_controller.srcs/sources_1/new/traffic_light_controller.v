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
input add_hour_btn, emgc_btn;       //1시간 더하는 기능과 emergency 긴급상황 나오는 것을 가정하였다.
input [1:0] time_spd;               //2번 3번스위치에 할당하였다.

output reg [3:0] N_tl, W_tl, S_tl, E_tl; // 4개의 방향(N W S E) 및 L,G,Y,R(각각의 traffic light)
output reg [7:0] Walk; // 동 서 남 북 각각 빨강 초록 이렇게 8가지 할당

output LCD_E, LCD_RS, LCD_RW;
output wire [7:0] LCD_DATA;             //출력값으로 LCD 텍스트가 나오게 넣어주었다.

wire d_or_n;                    // 낮일 경우와 밤일 경우를 선택한다.
wire add_hour_btn_t, emgc_btn_t;    // 위에서 작성한 것에 원샷 기능 추가하였다.
wire [7:0] hour, min, sec;    // 시 분 초를 각각 할당한다.
wire LCD_E;

reg [3:0] state_t;       // 각각의 상태를 표현한다. A부터 H 그리고 emergency A까지 LCD에서 state를 사용하였으므로 구분해주었다. state_traffic
reg [2:0] prev_state_t;     //이전 상태를 나타낸다. 이것은 Emergency_A(emergency)가 없으므로 3비트로 표현 가능하다. //previous_state_traffic이다.
reg emgc;        // emergency 긴급상황인 경우를 표현한다. 
reg choose_d_or_n;  // 주간 혹은 야간 중 어떻게 유지하고 나타낼지를 결정한다ㅏ.


parameter A = 4'b0000,
          B = 4'b0001,
          C = 4'b0010,
          D = 4'b0011,
          E = 4'b0100,                 // 각각의 상태들 표시한 것
          F = 4'b0101,
          G = 4'b0110,
          H = 4'b0111,
          Emergency_A = 4'b1000, //emergency일 때 상태 A를 표시한다.
          
          // L,G,Y,R,  NR,NG,WR,WG,SR,SG,ER,EG
            //북 서  남  동  보행신호 북 서 남 동                             // 차량 신호등은 북 서 남 동 반시계방향이고 보행 신호도 북 서 남 동 순서이다.
          //{N_tl,W_tl,S_tl,E_tl,Walk} <= ex. 24'b0000_0000_0000_0000_00_00_00_00;  4비트로 구성된 것은 차량신호등이고 2비트로 구성된 것은 보행신호이다. 
          
                      
          
          // A_Color A_Color_Fade  A_Color_Orange A_Color_Orange_Fade 축약어
          //A 상태 불빛
          A_C = 24'b0100_0001_0100_0001_10_01_10_01,      //초 빨 초 빨, 빨 초 빨 초 
          A_C_F = 24'b0100_0001_0100_0001_10_00_10_00,    //초 빨 초 빨, 빨 무 빨 무 (초록색이 깜빡이기 때문에 보행 신호 초록색 부분이 꺼진 것이다.
          A_C_O = 24'b0010_0010_0010_0010_10_01_10_01,    //주 주 주 주, 빨 초 빨 초
          A_C_O_F = 24'b0010_0010_0010_0010_10_00_10_00,  //주 주 주 주, 빨 무 빨 무  //원래 신호일 떄 보행신호 깜빡이는 것 2개와 주황색 신호일 때 깜빡이는 것 2개 총 4개 표현
          // B 상태
          B_C = 24'b1100_0001_0001_0001_10_10_10_01,      //초왼 빨 빨 빨, 빨 빨 빨 초           
          B_C_F = 24'b1100_0001_0001_0001_10_10_10_00,    //초왼 빨 빨 빨,  빨 빨 빨 무
          B_C_O = 24'b0010_0010_0010_0010_10_10_10_01,    //주 주 주 주, 빨 빨 빨 초                
          B_C_O_F = 24'b0010_0010_0010_0010_10_10_10_00,  //주 주 주 주, 빨 빨 빨 무
          //C상태
          C_C = 24'b0001_0001_1100_0001_10_01_10_10,      //빨 빨 초왼 빨, 빨 초 빨 빨
          C_C_F = 24'b0001_0001_1100_0001_10_00_10_10,    //빨 빨 초왼 빨, 빨 무 빨 빨
          C_C_O = 24'b0010_0010_0010_0010_10_01_10_10,    //주 주 주 주, 빨 초 빨 빨
          C_C_O_F = 24'b0010_0010_0010_0010_10_00_10_10,  //주 주 주 주, 빨 무 빨 빨
         // D 상태
          D_C = 24'b1000_0001_1000_0001_10_10_10_10,      //왼 빨 왼 빨, 빨 빨 빨 빨
          D_C_O = 24'b0010_0010_0010_0010_10_10_10_10,    //주 주 주 주, 빨 빨 빨 빨 //이 경우에는 보행신호가 다 빨간색이므로 깜빡이는 것을 위 상태들처럼 구현할 필요 없다.
        // E 상태
          E_C = 24'b0001_0100_0001_0100_01_10_01_10,      //빨 초 빨 초, 초 빨 초 빨
          E_C_F = 24'b0001_0100_0001_0100_00_10_00_10,    //빨 초 빨 초, 무 빨 무 빨
          E_C_O = 24'b0010_0010_0010_0010_01_10_01_10,    //주 주 주 주, 초 빨 초 빨
          E_C_O_F = 24'b0010_0010_0010_0010_00_10_00_10,  //주 주 주 주, 무 빨 무 빨
         //F 상태
          F_C = 24'b0001_1100_0001_0001_01_10_10_10,      //빨 초왼 빨 빨, 초 빨 빨 빨
          F_C_F = 24'b0001_1100_0001_0001_00_10_10_10,    //빨 초왼 빨 빨, 무 빨 빨 빨
          F_C_O = 24'b0010_0010_0010_0010_01_10_10_10,    //주 주 주 주, 초 빨 빨 빨
          F_C_O_F = 24'b0010_0010_0010_0010_00_10_10_10,  //주 주 주 주, 무 빨 빨 빨
         //G 상태
          G_C = 24'b0001_0001_0001_1100_10_10_01_10,      //빨 빨 빨 초왼, 빨 빨 초 빨
          G_C_F = 24'b0001_0001_0001_1100_10_10_00_10,    //빨 빨 빨 초왼, 빨 빨 무 빨
          G_C_O = 24'b0010_0010_0010_0010_10_10_01_10,    //주 주 주 주, 빨 빨 초 빨
          G_C_O_F = 24'b0010_0010_0010_0010_10_10_00_10,  //주 주 주 주, 빨 빨 무 빨
        // H 상태
          H_C = 24'b0001_1000_0001_1000_10_10_10_10,      // 빨 왼 빨 왼 보행신호 다 빨강
          H_C_O = 24'b0010_0010_0010_0010_10_10_10_10,    //주 주 주 주 보행신호 다 빨강
          // 4개의 방향 할당
          north = 2'b00,
          west = 2'b01,
          south = 2'b10,
          east = 2'b11;

integer t_cnt;

integer emgc_cnt;           //integer로 카운터를 할당하였다..

oneshot_universal #(.WIDTH(2)) u1(clk, rst, {add_hour_btn, emgc_btn}, {add_hour_btn_t, emgc_btn_t});
clock kshongmodule1(rst, clk, time_spd, add_hour_btn_t, hour, min, sec, d_or_n);
LCD kshongmodule2(rst, clk, hour, min, sec, d_or_n, state_t, LCD_E, LCD_RS, LCD_RW, LCD_DATA);  // 각각의 서브모듈을 작성하였다.

 
//     각각의 state일 경우를 표현하였다.
always @(posedge clk or negedge rst)
begin
    if(!rst) begin        //리셋이 활성화되면 아래의 값으로 초기화한다.
        state_t = B;        //상태를 B로 설정한다.
        t_cnt = 0;          //카운터를 초기화한다.
        prev_state_t = H;      //이전 상태를 H로 설정한다.
        choose_d_or_n = 1;      //주간 야간 상태를 나타내는 변수를 초기화한다. (1은 야간을 나타내게 된다.)
        emgc = 0;              //emergency 상태를 초기화한다.
    end
    else begin
        if(emgc_btn_t) emgc = !emgc;     //emergency 버튼 눌렀을 경우 이것을 불러온다.
        else begin                       //emergency 아닐 경우 아래 상태들을 나타낸다.
        if(choose_d_or_n) begin // 야간일 경우
            case(state_t)
                B : begin
                    if(t_cnt >= 10000) begin      //B 상태에서의 조건 : t_cnt가 10000 이상일 때
                        if(emgc) begin            //emergency 상태가 동작할 경우  
                            state_t = Emergency_A;        //상태를 Emergency_A로 변경한다.
                            t_cnt = 0;            //카운터를 초기화한다.
                            prev_state_t = B;     //이전 상태를 B로 설정한다. (emergency가 끝나면 직전의 상태로 돌아오게 한다.
                            choose_d_or_n = d_or_n;   //주간 혹은 야간 모드 유지한다.
                            emgc_cnt = 0;       //비상 카운터터를 초기호ㅓㅏ한다.
                        end
                               
                        else begin          //긴급상황이 아닐 경우
                            state_t = A;       
                            t_cnt = 0;            //카운터 초기화
                            prev_state_t = B;       //이전 상태를 B로 설정 (당연한 소리이다.)
                            choose_d_or_n = d_or_n;       //주간 야간 모드를 유지한다.
                        end 
                    end   
                    else begin//긴급상황
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin  //수동조작 버튼을 누른 후 1초 후에 emergency가 일어나도록 설정하였다.
                                state_t = Emergency_A;    //이 경우 EMERGENCY 상황에서 state A로 진행된다. 아래애서 긴급상황 A의 상태를 정의하였다.
                                t_cnt = 0;          //카운터 초기화
                                emgc_cnt = 0;         //비상 카운터 초기화
                                choose_d_or_n = d_or_n;   //주간 야간 모드 유지한다.
                                prev_state_t = B;       //이전 상태를 B로 설정한다.
                            end
                            else begin
                                t_cnt = t_cnt + 1;      //카운터 1씩 증가한다.
                                emgc_cnt = emgc_cnt + 1;        //비상카운터 역시 1씩 증가한다.
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;          //긴급상황이이 아닌 경우 카운터가 증가한다.
                        end
                    end
                end
                //나머지 상태들에 대해서도 위와 같은 방식으로 모두 서술한다.
                A : begin
                    if(t_cnt >= 10000) begin
                        if(emgc) begin
                            state_t = Emergency_A;
                            t_cnt = 0;
                            prev_state_t = A;
                            choose_d_or_n = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin              //A가 2번 나오므로 각각의 경우를 나누어서 작성한다.
                            if(prev_state_t == B) begin     //이전 상태가 B이면 A 다음 나올 상태는 C여야 한다.
                                state_t = C;
                                t_cnt = 0;
                                prev_state_t = A;
                                choose_d_or_n = d_or_n;
                            end
                            else begin                      //이전 상태가 B가 아니라면 A 다음은 E가 나와야 한다.
                                state_t = E;
                                t_cnt = 0;
                                prev_state_t = A;
                                choose_d_or_n = d_or_n;
                            end
                        end 
                    end   
                    else begin          //긴급상황 위와 동일하게 둔다. prev_state만 다르게 두면 된다. 상황에 맞게 설정하는 것이다.
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
                
                Emergency_A : begin             //긴급상황 발생시이다. 위에서 각각의 상황을 모두 정의하였다.
                    if(t_cnt >= 15000) begin     //전체시간 15초 긴급상황 시간은 15초이기 때문이다.
                        state_t = prev_state_t;
                        choose_d_or_n = d_or_n;
                        t_cnt = 0;
                        emgc = 0;
                    end   
                    else t_cnt = t_cnt + 1;
                end
            endcase
        end    
        
        //주간일 경우이다.            위의 야간일 경우와 작동방식은 같지만 state 유지 시간이 야간과 달리 10초가 아닌 5초이므로 cnt 기준점을 5000으로 두었다. 
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

always @(posedge clk or negedge rst)        //신호등 빛의 표현 및 각각의 상태에서 신호등 표현을 나타내었다.
begin
    if(!rst) {N_tl,W_tl,S_tl,E_tl,Walk} <= 24'b0000_0000_0000_0000_00_00_00_00;         //리셋 동작 시 모든 불이 꺼지게 설정하였다.
    else begin
        if(choose_d_or_n) begin // 야간   //일단 야간은 스테이트 유지시간은 실제시간 기준으로 10초로 설정을 바로 아래에서 설정하였다.
            case(state_t)
                B : begin                                   //총 cnt가 10000동안 실행되며 5000 동안은 점멸동작 없고 나머지 절반의 시간동안 점멸동작을 넣어주었다.
                                                            //자세한 과정은 서브모듈인 clock에서 동작한다.
                    if(emgc) {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C_O;   //emergency 상황 발생 시 B와 Emergency_A 사이에 주황색 신호를 넣었다. 1초 후에 긴급상황이 발생하도록 위에서 설정하였다.
                    else begin
                        if(t_cnt < 5000) {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C;   //야간 스테이트 유지시간 일단 보행신호 깜빡이기 전까지 5초로 지정 나머지 스테이트일 경우에도 같은 방식
                        else if(t_cnt >= 5000 & t_cnt < 5500) {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C_F;
                        else if(t_cnt >= 5500 & t_cnt < 6000) {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C;
                        else if(t_cnt >= 6000 & t_cnt < 6500) {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C_F;
                        else if(t_cnt >= 6500 & t_cnt < 7000) {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C;
                        else if(t_cnt >= 7000 & t_cnt < 7500) {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C_F;
                        else if(t_cnt >= 7500 & t_cnt < 8000) {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C;
                        else if(t_cnt >= 8000 & t_cnt < 8500) {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C_F;      //0.5초 단위로 깜빡이는 것이다.
                        else if(t_cnt >= 8500 & t_cnt < 9000) {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C;    //지금까지 보행신호 깜빡거리는거 표시 단위는 카운터 500 주기로 두었다.(0.5초)
                        else if(t_cnt >= 9000 & t_cnt < 9500) {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C_O_F;  //주황색 신호 나옴
                        else {N_tl,W_tl,S_tl,E_tl,Walk} <= B_C_O; //이 것을 마지막으로 야간 신호 스테이트 유지시간 10초로 설정된 것이다.
                    end
                end
                //위 state B와 마찬가지로 나머지 상태들도 같은 방식으로 두었다.
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
                
                H : begin      //H의 경우에는 보행신호가 깜빡이는 것이 없으므로 위 상태들처럼 깜빡이는 것을 구현할 필요가 없다. 따라서 코드가 짧다.
                    if(emgc) {N_tl,W_tl,S_tl,E_tl,Walk} <= H_C_O;
                    else begin
                        if(t_cnt < 8500) {N_tl,W_tl,S_tl,E_tl,Walk} <= H_C;
                        else {N_tl,W_tl,S_tl,E_tl,Walk} <= H_C_O;
                        end
                    end
                
                Emergency_A : begin    //야간의 경우 emergency이다. (긴급차량의 경우)
                    if(t_cnt < 7500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;   //전체 시간이 15초동안 진행되기 때문에 우선 보행신호 깜빡이기 전 까지를 7.5초로 두었다.
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
                    else if(t_cnt >= 13500 & t_cnt < 14000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;   //여기까지 보행신호 0.5초 단위로 깜빡이게 두었다. cnt를 500 단위로 둔 것이다.
                    else if(t_cnt >= 14000 & t_cnt < 14500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_O;
                    else {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_O_F;
                end
            endcase
        end
        
        else begin    //주간일 경우이다.
            case(state_t)
                A : begin                               //전체 카운터를 5000으로 잡고 2500동안 점멸동작 안하고 나머지 절반의 시간동안 보행신호가 점멸동작을 수행한다.
                    if(emgc) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_O;
                    else begin                                                                  //주간 스테이트 유지시간은 실제시간 기준으로 5초이므로 
                        if(t_cnt < 2500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;                         //안 깜빡이는 시간 2.5초 깜빡이는 시간 2.5초 이렇게 주었다.
                        else if(t_cnt >= 2500 & t_cnt < 3000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;
                        else if(t_cnt >= 3000 & t_cnt < 3500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C;
                        else if(t_cnt >= 3500 & t_cnt < 4000) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_F;
                        else if(t_cnt >= 4000 & t_cnt < 4500) {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_O;
                        else {N_tl,W_tl,S_tl,E_tl,Walk} <= A_C_O_F;
                    end
                end
                                                    //나머지도 같은 방식으로 모두 하면 된다.
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

