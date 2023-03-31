`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/06 22:00:13
// Design Name: 
// Module Name: fenpin
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
module fenpin(
    input clk,clr,
    output reg clk_1k=0,
    output reg   clk1sout=0,
    output reg  clk_20ms=0,
    integer    clk1s_cnt=0
    );
      reg[24:0] cnt=0;
      always @ (posedge clk)
              begin
                  if (cnt==25000)
                  begin
                      clk_1k=~clk_1k;//分频得到1kHz信号
                      cnt=0;
                  end
                  else 
                      cnt=cnt+1;
             end
    //1s

reg [31:0] temp = 0;
always@(posedge clk)
    begin
      if(temp == 999999)
      begin
            temp = 0;
            clk_20ms = ~clk_20ms;
      end
      else 
             temp = temp+1;
      end
 
 always@(posedge clk)
 begin    
    if(clr)    
    begin   
           clk1s_cnt<=0;    clk1sout<=0;  
    end 
    else  if(clk1s_cnt==24999999) //分频得到1Hz信号
    	begin
     		clk1s_cnt<=0;    clk1sout<=~clk1sout;
     	end
     	else    clk1s_cnt<=clk1s_cnt+1;
 end
endmodule


