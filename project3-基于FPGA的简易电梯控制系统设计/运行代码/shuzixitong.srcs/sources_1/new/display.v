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


//译码显示及流水指示灯模块
module display(
input [1:0]floor,//楼层
input [1:0]state,//状态
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
   //位选
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
    else if (state ==1)//电梯处于上行状态
	begin
	     if (led_b[4:0]==5'b00000)
            led_b[4:0]=5'b10000;//到了00000，下一个是10000
   	 else
            led_b[4:0]=led_b[4:0]>>1; 
//向右移一位。10000-01000-00100-00010-00001-00000
    end
    else if (state ==2)//电梯处于下行状态
    begin
         if (led_b[4:0]==5'b00000)
            led_b[4:0]=5'b00001;//到了00000，下一个是00001
    	 else
             led_b[4:0]=led_b[4:0]<<1; 
//向左移一位。00001-00010-00100-01000-10000-00000
    end
    else led_b[4:0]=5'b00000;
	end
	
	//选择器，确定显示数据
	reg [3:0] disp_data;
	always@(num)
	begin	
		case(num)
		0:disp_data=floor;
		1:disp_data=state+3'b011;//3待机 4上行 5下行
		default: disp_data=0;
		endcase
	end
	
	//显示译码器
	always@(disp_data)
	begin
		case(disp_data)
		4'h1: seg=8'h06;//1楼
		4'h2: seg=8'h5b;//2楼
		4'h3: seg=8'h40;//待机
		4'h4: seg=8'h01;//上行
		4'h5: seg=8'h08;//下行
		default: seg=0;
		endcase
	end

endmodule


