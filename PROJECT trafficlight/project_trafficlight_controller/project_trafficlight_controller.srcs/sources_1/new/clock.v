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
input [1:0] time_spd;               //2비트로 각각 1배 10배 100배 200배 배속 선언
input add_hour_btn_t;       //1시간 추가
output reg d_or_n;                  //출력 신호를 나타내었다. 낮 혹은 밤으로
output reg [7:0] hour, min, sec;        //시 분 초로 출력 신호를 나타내었다.

reg [12:0] c;       //시간을 추적하는 카운터를 나타낸다.

reg cts1, s1ts10, s10tm1, m1tm10, m10th1, h1th10, h10tday; //축약어로 나타내었다. 각각의 의미는 아래에 서술하였다.

wire cts1_t, s1ts10_t, s10tm1_t, m1tm10_t, m10th1_t, h1th10_t, h10tday_t;   //위 상태 트리거된 것들이다.


oneshot_universal #(.WIDTH(7)) u2(clk, rst, {cts1, s1ts10, s10tm1, m1tm10, m10th1, h1th10, h10tday}, {cts1_t, s1ts10_t, s10tm1_t, m1tm10_t, m10th1_t, h1th10_t, h10tday_t});

always @(negedge rst or posedge clk) begin // 시간 배속 나타낸다.
    if(~rst) begin;
        c = 0;          //리셋 상태에서는 카운터 및 배속을 초기화한다.
        cts1=0;             // counter to second one
    end
    else begin
        case(time_spd)   //DIP 스위치 2번과 3번에 할당하여 올릴 때마다 배속을 하게 만들어주었다.
            2'b00 : 
                if(c>=1000) begin           // 1000/1000이어서 기본적으로 1배 빠르다. 원래 시간 배속이다.
                    cts1 = 1;           //1000클럭 주기마다 cts1를 토글하고 c를 0을 초기화한다.
                    c=0;                //이것이 기본적인 시간 동작이다. 배율 높이지 않을 시 계속 이 과정으로 수행한다.
                end
                else begin
                    c=c+1;
                    cts1=0;
                end
            2'b01 : if(c>=100) begin        // 1000/100 하여 10배 빨라지도록 설정하였다.
                    cts1 = 1;            //100클럭 주기마다 cts1를 토글하고 c를 0을 초기화한다.
                    c=0;
                end
                else begin
                    c=c+1;
                    cts1=0;
                end
            2'b10 : if(c>=10) begin         // 1000/10 해서 100배 빨라지도록 설정하였다.
                    cts1 = 1;        //10클럭 주기마다 cts1를 토글하고 c를 0을 초기화한다.
                    c=0;    
                end
                else begin
                    c=c+1;
                    cts1=0;
                end
            2'b11 : if(c>=5) begin   //  1000/5 하여 200배 빨라지도록 설정해두었다.
                    cts1 = 1;        //5클럭 주기마다 cts1를 토글하고 c를 0을 초기화한다.
                    c=0;
                end
                else begin
                    c=c+1;
                    cts1=0;
                end
        endcase
    end
end


            // 시 분 초 각각 10의 자리와 1의 자리를 나누어 숫자의 증가하는 방식을 정의하였다.
always @(negedge rst or posedge clk) begin //sec[3:0] 증가 블록
    if(~rst) begin
        sec[3:0] = 0;
        s1ts10=0;            //second 1 to second 10
    end
    else begin
        if(cts1_t) begin            //시간 신호가 변한 경우
            if(sec[3:0]==9) begin           //초가 9에 도달한 경우
                sec[3:0]<=0;                //초를 0으로 초기화한다.
                s1ts10<=1;                   //s1ts10를 1로 설정하여 다음 상태로 이동한다.
            end
            else begin
                sec[3:0] <= sec[3:0] + 1;       //초가 9에 도달하지 않으면 초를 1 증가시킨다.
                s1ts10<=0;               //s1ts10는 0으로 계속 둔다.
            end
        end
    end
end

always @(negedge rst or posedge clk) begin //sec[7:4] 증가 블록
    if(~rst) begin
        sec[7:4] = 0;               //리셋 상태에서 모두 0으로 초기화
        s10tm1=0;                    //second 10 to minute 1
    end
    else begin
        if(s1ts10_t) begin           //이전 블록에서 트리거된 상태신호인 s1ts10_t가 증가되면 실행
            if(sec[7:4]==5) begin   // sec[7:4]가 5에 도달한 경우 (십의 자리 수가 5)
                sec[7:4]<=0;        // 0으로 초기화
                s10tm1<=1;           //s10tm1 상태신호를 1로 설정하여 다음 상태로 이동
            end
            else begin      //5에 도달하지 않은 경우 [7:4] 부분 초는 1 증가시키고
                sec[7:4] <= sec[7:4] + 1;           
                s10tm1<=0;                   // s10tm1는 0으로 둔다.
            end
        end
    end
end

always @(negedge rst or posedge clk) begin //min[3:0] 증가 블록
    if(~rst) begin
        min[3:0] = 0;
        m1tm10=0;                //minute 1 to minute 10
    end
    else begin
        if(s10tm1_t) begin           //이전 블록에서 트리거된 상태신호  s10tm1_t가 증가되면 실행한다.
            if(min[3:0]==9) begin           //일의자리 분이 9에 도달
                min[3:0]<=0;            //일의자리 분으 0으로 둔다.
                m1tm10<=1;               //십의 자리 분을 1로 둔다.
            end
            else begin
                min[3:0] <= min[3:0] + 1;       //일의자리 분이 9에 도달안한 경우
                m1tm10<=0;               //십의자리 분을 0으로 둔다.
            end
        end
    end
end

always @(negedge rst or posedge clk) begin //min[7:4] 증가 블록
    if(~rst) begin          //리셋상태 0으로 초기화 설정
        min[7:4] = 0;
        m10th1=0;                //mimute 10 to hour 1
    end
    else begin
        if(m1tm10_t) begin           //이전 블록에서 트리거된 상태신호 m1tm10_t가 증가되면 실행
            if(min[7:4]==5) begin       //십의자리 분이 5에 도달한 경우
                min[7:4]<=0;            // 십의자리 분을 0으로 둔다.
                m10th1<=1;           //일의 자리 시를 1로 둔다. 다음 상태로 이동
            end
            else begin              //십의자리 분 5 도달하지 않았을 경우
                min[7:4] <= min[7:4] + 1;        //십의자리 분 1 증가시킨다.
                m10th1<=0;           //일의자리 시는 0으로 둔다.
            end
        end
    end
end

always @(negedge rst or posedge clk) begin //hour[3:0] 증가 블록
    if(~rst) begin              //위와 마찬가지로 리셋 상태를 설정하였다.
        hour[3:0] = 0;
        h1th10=0;            //hout 1 to hour 10
        h10tday=0;             //hour 10 to day(낮 혹은 밤)
    end
    else begin          // 이전 블록에서 트리거된 상태인 m10th1_t 혹은 add_hour_btn_t가 증가하면 실행한다.
        if(m10th1_t | add_hour_btn_t) begin      
            if(hour[3:0]==9) begin      // 일의자리 시가 9에 도달한 경우
                hour[3:0]<=0;       //일의자리 시를 0으로 둔다.
                h1th10 <= 1;             //십의자리 시를 1로 둔다.
            end
            else begin      //일의 자리 시가 9에 도달하지 않은 경우
                if(hour[3:0]==3 & hour[7:4]==2) begin   //만약 23시일 경우에 증가하는 경우       
                    hour[3:0]<=0;           //시는 0으로 둔다.
                    h10tday <= 1;              //(상태신호 h10tday를 1로 설정후 다음상태 이동)
                end                   
                else begin                //바로 위 조건 만족하지 않은 경우
                    hour[3:0] <= hour[3:0] + 1;     //일의자리 시를 1 증가시킨다.
                    h10tday <= 0;
                    h1th10 <= 0;
                end
            end
        end
    end
end

always @(negedge rst or posedge clk) begin    //hour[7:4] 증가 블록
    if(~rst) begin
        hour[7:4] = 0;          //마찬가지로 리셋 상태이다.
    end
    else begin              //이전 블록에서 트리거된 상태신호 h10tday_t가 증가되었을 때
        if(h10tday_t) hour[7:4]<=0;    //십의자리 시를 0으로 초기화
        else begin                  //아닌 경우
            if(h1th10_t) hour[7:4] <= hour[7:4] + 1; //십의 자리 시를 1 증가
        end
    end
end

always @(negedge rst or posedge clk) begin
    if(~rst) begin
        d_or_n = 1; //0:낮 , 1:밤  
    end
    else begin              // 현재 시간(시)이 8 이상 23 미만일 경우 
        if(hour[7:4]*10 + hour[3:0] >= 8 & hour[7:4]*10 + hour[3:0] < 23) begin
            d_or_n <= 0;            //0으로 둔다. (낮)
        end                 //위 조건이 아닐 경우
        else d_or_n <= 1;               //1로 둔다. (밤)
    end
end

endmodule
