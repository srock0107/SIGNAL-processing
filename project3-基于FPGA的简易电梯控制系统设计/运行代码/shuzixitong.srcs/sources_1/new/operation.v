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

//״̬����ģ��
module operation(
input clk,
input set,
input reset,
input key0,
input key1,
input key2,
input key3,
output reg [3:0]led=0,//ָʾ��
output reg [1:0]state=0,//00����״̬ 01����״̬ 10����״̬
output reg [1:0]floor=1  //¥�� 01һ¥ 10��¥ 

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
    if(!reset)//��λ���ر�����
       begin
           if(floor==2)//���������2¥�������������ص�һ¥
             if(clk_count==249999999) //�����ʱ
             begin            
                clk_count=0;                           
                floor=1;                    
                state=0;         
                led=4'b0000;
              end
             else begin clk_count=clk_count+1;state=2;led=4'b0000;end
       end
   else if(set)//��λ����δ�����£���start��Ч
   begin
     if(led)//��led��Ϊ0�����ݴ�������״̬ʱ
       begin 
         if(clk_count==249999999) 
          begin            
                clk_count=0;                           
                
                if(floor==1)  begin floor=floor+1; end//��ʱ������һ¥�л�����¥
                else        begin floor=floor-1; end//��ʱ�����Ӷ�¥�л���һ¥       
               
                if((k3&k2)&&first==1) begin state=2;k3=0;k2=0;led[3]=0;first=0;end
//key3��key2���������£�����������¥�󱣳�led2�����л�������״̬
                else if(k3&k0) begin state=2;k3=0;k0=0;led[3]=0;end
//key3��key0���������£�����������¥�󱣳�led0�����л�������״̬
                else if((k2&k3)&&first==2) begin state=1;k2=0;k3=0;led[2]=0;first=0;end
//key2��key3���������£����½���һ¥�󱣳�led3�����л�������״̬
                else if(k2&k1) begin state=1;k2=0;k1=0;led[2]=0;end
//key2��key1���������£����½���һ¥�󱣳�led1�����л�������״̬
                else  begin state=0;led=4'b0000;k0=0;k1=0;k2=0;k3=0;end
//����״̬���㣬�ص�����״̬
         
          end  
         else  clk_count=clk_count+1;
               if(key2|k2) begin k2=1;k0=0;led[2]=1;end
//�����й����б���ָʾ���������𣬲����ڰ����ڵ������й����б�����ʱ���м�¼
               if(key0|k0) begin k0=1;k2=0;led[0]=1;end
//�����й����б���ָʾ���������𣬲����ڰ����ڵ������й����б�����ʱ���м�¼
               if(key3|k3) begin k3=1;k1=0;led[3]=1;end
//�����й����б���ָʾ���������𣬲����ڰ����ڵ������й����б�����ʱ���м�¼
               if(key1|k1) begin k1=1;k3=0;led[1]=1;end
//�����й����б���ָʾ���������𣬲����ڰ����ڵ������й����б�����ʱ���м�¼
       end
        
         else if((key0)&&floor==2)  //�ڶ�¥��һ¥��key0
                           begin
                           led[0]=1; 
                           state=2;  //����                         
                           end
                                
         else if((key1)&&floor==1)  //��һ¥����¥��key1
                              begin
                                  led[1]=1;
                                  state=1;//����
                              end
     
          else if((key2)&&floor==2)  //�ڶ�¥ �����ڰ��� 
                                 begin
                                   led[2]=1;
                                   state=2; //����
                                   k2=1;
                                  first=2;//���ڱ���key2����key3������
                                 end 
                                 
          else if((key3)&&floor==1)  //��һ¥ �����ڰ���  
                                   begin
                                    led[3]=1;
                                    state=1; //����                                                                                               
                                    k3=1;
                                    first=1;//���ڱ���key3����key2������
                                    
                                   end                                 
         
            end
         end

endmodule


