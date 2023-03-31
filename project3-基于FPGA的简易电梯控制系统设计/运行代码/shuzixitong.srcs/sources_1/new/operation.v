`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/06 22:02:03
// Design Name: 
// Module Name: operation
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

//状态控制模块
module operation(
input clk,
input set,
input reset,
input key0,
input key1,
input key2,
input key3,
output reg [3:0]led=0,//指示灯
output reg [1:0]state=0,//00待机状态 01上行状态 10下行状态
output reg [1:0]floor=1  //楼层 01一楼 10二楼 

	);
reg [27:0]cnt=0; 
reg [27:0]clk_count=0;
reg k0=0;
reg k1=0;
reg k2=0;
reg k3=0; 
reg [1:0] first=0; 
always@(posedge clk)
  begin
    if(!reset)//复位开关被拨下
       begin
           if(floor==2)//如果电梯在2楼，则运行五秒后回到一楼
             if(clk_count==249999999) //五秒计时
             begin            
                clk_count=0;                           
                floor=1;                    
                state=0;         
                led=4'b0000;
              end
             else begin clk_count=clk_count+1;state=2;led=4'b0000;end
       end
   else if(set)//复位开关未被拨下，且start有效
   begin
     if(led)//当led不为0，电梯处于运行状态时
       begin 
         if(clk_count==249999999) 
          begin            
                clk_count=0;                           
                
                if(floor==1)  begin floor=floor+1; end//计时五秒后从一楼切换到二楼
                else        begin floor=floor-1; end//计时五秒后从二楼切换到一楼       
               
                if((k3&k2)&&first==1) begin state=2;k3=0;k2=0;led[3]=0;first=0;end
//key3，key2接连被按下，在上升到二楼后保持led2亮起，切换到下行状态
                else if(k3&k0) begin state=2;k3=0;k0=0;led[3]=0;end
//key3，key0接连被按下，在上升到二楼后保持led0亮起，切换到下行状态
                else if((k2&k3)&&first==2) begin state=1;k2=0;k3=0;led[2]=0;first=0;end
//key2，key3接连被按下，在下降到一楼后保持led3亮起，切换到上行状态
                else if(k2&k1) begin state=1;k2=0;k1=0;led[2]=0;end
//key2，key1接连被按下，在下降到一楼后保持led1亮起，切换到上行状态
                else  begin state=0;led=4'b0000;k0=0;k1=0;k2=0;k3=0;end
//所有状态置零，回到待机状态
         
          end  
         else  clk_count=clk_count+1;
               if(key2|k2) begin k2=1;k0=0;led[2]=1;end
//在运行过程中保持指示灯正常亮起，并且在按键在电梯运行过程中被按下时进行记录
               if(key0|k0) begin k0=1;k2=0;led[0]=1;end
//在运行过程中保持指示灯正常亮起，并且在按键在电梯运行过程中被按下时进行记录
               if(key3|k3) begin k3=1;k1=0;led[3]=1;end
//在运行过程中保持指示灯正常亮起，并且在按键在电梯运行过程中被按下时进行记录
               if(key1|k1) begin k1=1;k3=0;led[1]=1;end
//在运行过程中保持指示灯正常亮起，并且在按键在电梯运行过程中被按下时进行记录
       end
        
         else if((key0)&&floor==2)  //在二楼，一楼按key0
                           begin
                           led[0]=1; 
                           state=2;  //下行                         
                           end
                                
         else if((key1)&&floor==1)  //在一楼，二楼按key1
                              begin
                                  led[1]=1;
                                  state=1;//上行
                              end
     
          else if((key2)&&floor==2)  //在二楼 电梯内按下 
                                 begin
                                   led[2]=1;
                                   state=2; //下行
                                   k2=1;
                                  first=2;//用于表明key2先于key3被按下
                                 end 
                                 
          else if((key3)&&floor==1)  //在一楼 电梯内按上  
                                   begin
                                    led[3]=1;
                                    state=1; //上行                                                                                               
                                    k3=1;
                                    first=1;//用于表明key3先于key2被按下
                                    
                                   end                                 
         
            end
         end

endmodule


