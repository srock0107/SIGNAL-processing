`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/06 22:00:46
// Design Name: 
// Module Name: key_debounce
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


//°´¼üÏû¶¶Ä£¿é
module key_debounce(
    input key_in,
    input clk,
    output key_out
    );
    
    reg [4:0] cnt;
    reg k1,k2;
    always@(negedge clk or negedge key_in)
    if(!key_in)
    cnt<=0;
    else if(cnt!=31) cnt<=cnt+1;
    always@(negedge clk)begin
    if(cnt!=31)k1<=0;else k1<=1;k2<=k1;
    end
    assign key_out=~k1&k2;
endmodule



