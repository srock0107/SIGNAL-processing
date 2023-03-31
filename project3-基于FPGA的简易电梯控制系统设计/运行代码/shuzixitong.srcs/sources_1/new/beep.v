`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/06 22:03:53
// Design Name: 
// Module Name: beep
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


//蜂鸣器模块
module beep(
    input clk,
    input [1:0]state,
    input [1:0]floor,
    output reg beep
    );
    
    reg beep_n;//控制蜂鸣声时长
    reg [24:0]beep_cnt=0;
    reg [24:0] clk_400ms_cnt=0;
    reg [24:0] clk_400ms_cnt2=0;
    
      always @ (posedge clk)
           begin 
             if(floor==1)
              begin
                clk_400ms_cnt2=0;
                if (clk_400ms_cnt==24999999)
                  begin
                   beep_n=0;
                   clk_400ms_cnt=24999999;
                   end
                else if(clk_400ms_cnt!==24999999&&clk_400ms_cnt!==0)
//在计数区间内，约为0.5秒的时间里发出蜂鸣声
                  begin
                    clk_400ms_cnt<=clk_400ms_cnt+1;
                    beep_n=1;
                  end  
                else if(clk_400ms_cnt==0)
                   begin
                    clk_400ms_cnt<=clk_400ms_cnt+1;
                    beep_n=0;
                   end
                end 
              else
                begin
                  clk_400ms_cnt=0;
                 if (clk_400ms_cnt2==24999999)
                   begin
                      beep_n=0;
                      clk_400ms_cnt2=24999999;
                    end
                  else if(clk_400ms_cnt2!==24999999&&clk_400ms_cnt2!==0)
//在计数区间内，约为0.5秒的时间里发出蜂鸣声
                     begin
                     clk_400ms_cnt2<=clk_400ms_cnt2+1;
                     beep_n=1;
                     end  
                  else if(clk_400ms_cnt2==0)
                     begin
                     clk_400ms_cnt2<=clk_400ms_cnt2+1;
                     beep_n=0;
                     end
                   end 
         if(beep_n)
             begin
               if(beep_cnt==49000)//向蜂鸣器输入一个约580Hz的脉冲，音调为"do"
                 begin
                  beep=~beep; 
                  beep_cnt=0;
                 end
                else
                  begin beep_cnt=beep_cnt+1;end 
              end    
           else
            begin
              beep=0;
              beep_cnt=0;          
             end          
         end     
endmodule


