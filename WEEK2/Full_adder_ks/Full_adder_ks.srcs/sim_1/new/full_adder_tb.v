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
    //wire 10개 동시에 선언

    full_adder_design tfa(a,b,cin,s,cout);
    //모듈 외부에서 input에는 wire, reg 모두 사용할 수 있다
    //모듈 외부에서 output에는 wire만을 사용할 수 있다
    //모듈의 output에 연결한다는 것은 wire를 모듈에 assign하는 것과 같은 개념
    
    initial begin
        //initial문은 테스트벤치에서만 사용 가능
        a=1'b0; b=1'b0; cin=0;  //initial문에서 최초값이 없으면 오류남
        #20                     //20ns 지연
        a=1'b0; b=1'b1; cin=0;  //1'b0은 이진수(b) 1비트에 값은 0이라는 뜻
        #20                     //8'd32는 십진수(d) 8비트에 값은 32라는 뜻(==8'b00010000)
        a=1'b1; b=1'b0; cin=0;
        #20
        a=1'b1; b=1'b1; cin=0;
        #40
        a=1'b0; b=1'b0; cin=1;  //initial문에서 최초값이 없으면 오류남
        #20                     //20ns 지연
        a=1'b0; b=1'b1; cin=1;  //1'b0은 이진수(b) 1비트에 값은 0이라는 뜻
        #20                     //8'd32는 십진수(d) 8비트에 값은 32라는 뜻(==8'b00010000)
        a=1'b1; b=1'b0; cin=1;
        #20
        a=1'b1; b=1'b1; cin=1;
    end

endmodule
