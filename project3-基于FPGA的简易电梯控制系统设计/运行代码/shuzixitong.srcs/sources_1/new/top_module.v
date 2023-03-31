`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/06 21:59:26
// Design Name: 
// Module Name: top_module
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
module top_module(
  input clk,
  input start,    
  input reset, 
  input key0,key1,key2,key3,
  output  row,
  output  [3:0]led,
  output [5:0]dig,
  output [7:0]seg,
  output beep,
  output [4:0]led_b
    );
    assign row=1'b0;
    wire clk_1k;
    wire clk_1s;
    wire  clk_20ms;

  fenpin u1(.clk(clk),
         .clk_1k(clk_1k),
         .clk1sout(clk_1s),
         .clk_20ms(clk_20ms));
         
         wire k0;
         wire k1;
         wire k2;
         wire k3;
  key_debounce u2(
         .clk(clk_20ms),
         .key_in(key0),
         .key_out(k0));
  key_debounce u3(
         .clk(clk_20ms),
         .key_in(key1),
         .key_out(k1));
  key_debounce u4(
         .clk(clk_20ms),
         .key_in(key2),
         .key_out(k2));
  key_debounce u5(
         .clk(clk_20ms),
         .key_in(key3),
         .key_out(k3));    
        wire [1:0]state;
        wire [1:0]floor;      
  operation u6(
                      .clk(clk),
                      .set(start),
                      .reset(reset),
                      .key0(k0),
                      .key1(k1),
                      .key2(k2),
                      .key3(k3),
                      .led(led),
                      .state(state),
                      .floor(floor)
                       ); 
   display u7(
                          .floor(floor),
                          .state(state),
                          .clk(clk_1k),
                          .seg(seg),
                          .clk_1s(clk_1s),
                          .led_b(led_b),
                          .dig(dig)
                                       ); 
    beep u8(
                    .clk(clk),
                    .state(state),
                    .floor(floor),
                    .beep(beep)
                    );                                          
endmodule
