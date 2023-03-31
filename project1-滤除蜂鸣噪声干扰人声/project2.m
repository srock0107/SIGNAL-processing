%% signal system
clc;
clear;
[sig_t,Fs]=audioread('buzz.wav');%��ȡ��Ƶ��Ϣ
sig_f=fft(sig_t);                %���ٸ���Ҷ�任
T=1/Fs;                          %�������
L=length(sig_t);                 %�źų���
t=(0:L-1)*T;                     %ʱ���������
%��ʱ��ͼ
%figure(1);plot(t,sig_t);grid on
%title('δ������Ƶʱ��ͼ');xlabel('t');ylabel('y');

A=abs(sig_f/L);%Ƶ�����
f=Fs*(1:L)/L;   %Ƶ���������
%figure(2)
%plot(f,A);grid on;title('δ������ƵƵ��ͼ');xlabel('f/(Hz)');ylabel('y');
%% ��ͨ�˲�������
ff0=940;           %���޽���Ƶ��
ff_mid=5515;       %�е�Ƶ��[����δ������ƵƵ��ͼ�۲�ó�]
ff1=2*ff_mid-ff0;  %���޽���Ƶ��
sig_f(find(abs(sig_f/L)>0.000141))=0;
NUM1=find(f<ff0);
NUM2=find(f>ff1);
NUM3=(3393:1:36415)
NUM=[NUM1';NUM2'];
sig_f(NUM)=5*sig_f(NUM);
sig_f(NUM3)=0*sig_f(NUM3);
%% ��Ƶ�źŴ���
%sig_f(find(f<ff0 & abs(sig_f/L)>0.00005))=0;
%sig_f(find(12000>f>ff1 & abs(sig_f/L)>0.001))=0;

%sig_f(find(f>ff1))=0; %�����˲���ȥ������

A=abs(sig_f/L);%Ƶ�����
f=Fs*(1:L)/L;   %Ƶ���������
figure(1);
plot(f,A);grid on;
title('�������ƵƵ��ͼ');
xlabel('f/(Hz)');ylabel('y');

X=ifft(sig_f); %����Ҷ���任
figure(2);
plot(t,X);grid on
title('�������Ƶʱ��ͼ');
xlabel('f/(Hz)');ylabel('y');
h=10*real(X);  %ȡʵ�����Ŵ�����
sound(h,Fs);    %����

