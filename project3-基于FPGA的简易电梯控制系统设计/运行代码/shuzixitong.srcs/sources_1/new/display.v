`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/06 22:03:03
// Design Name: 
// Module Name: display
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


//������ʾ����ˮָʾ��ģ��
module display(
input [1:0]floor,//¥��
input [1:0]state,//״̬
input clk,
input clk_1s,
output reg [4:0] led_b=0,
output reg [7:0] seg,
output reg [5:0] dig
);
reg num=0;
	always@(posedge clk)
	begin
		if (num==1)
			num=0;
		else
			num=num+1;
	end
   //λѡ
	always@(num)
	begin	
		case(num)
		0:dig=6'b111110;
		1:dig=6'b111101;
		default: dig=0;
		endcase
	end
	
	always@(posedge clk_1s or posedge state or negedge state)
	begin
	if(state==0)
	led_b[4:0]=5'b00000;
    else if (state ==1)//���ݴ�������״̬
	begin
	     if (led_b[4:0]==5'b00000)
            led_b[4:0]=5'b10000;//����00000����һ����10000
   	 else
            led_b[4:0]=led_b[4:0]>>1; 
//������һλ��10000-01000-00100-00010-00001-00000
    end
    else if (state ==2)//���ݴ�������״̬
    begin
         if (led_b[4:0]==5'b00000)
            led_b[4:0]=5'b00001;//����00000����һ����00001
    	 else
             led_b[4:0]=led_b[4:0]<<1; 
//������һλ��00001-00010-00100-01000-10000-00000
    end
    else led_b[4:0]=5'b00000;
	end
	
	//ѡ������ȷ����ʾ����
	reg [3:0] disp_data;
	always@(num)
	begin	
		case(num)
		0:disp_data=floor;
		1:disp_data=state+3'b011;//3���� 4���� 5����
		default: disp_data=0;
		endcase
	end
	
	//��ʾ������
	always@(disp_data)
	begin
		case(disp_data)
		4'h1: seg=8'h06;//1¥
		4'h2: seg=8'h5b;//2¥
		4'h3: seg=8'h40;//����
		4'h4: seg=8'h01;//����
		4'h5: seg=8'h08;//����
		default: seg=0;
		endcase
	end

endmodule


