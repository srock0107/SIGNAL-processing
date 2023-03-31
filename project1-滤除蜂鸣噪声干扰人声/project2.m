%% signal system
clc;
clear;
[sig_t,Fs]=audioread('buzz.wav');%读取音频信息
sig_f=fft(sig_t);                %快速傅里叶变换
T=1/Fs;                          %采样间隔
L=length(sig_t);                 %信号长度
t=(0:L-1)*T;                     %时域横坐标轴
%做时域图
%figure(1);plot(t,sig_t);grid on
%title('未处理音频时域图');xlabel('t');ylabel('y');

A=abs(sig_f/L);%频域幅度
f=Fs*(1:L)/L;   %频域横坐标轴
%figure(2)
%plot(f,A);grid on;title('未处理音频频域图');xlabel('f/(Hz)');ylabel('y');
%% 带通滤波器参数
ff0=940;           %下限截至频率
ff_mid=5515;       %中点频率[根据未处理音频频域图观测得出]
ff1=2*ff_mid-ff0;  %上限截至频率
sig_f(find(abs(sig_f/L)>0.000141))=0;
NUM1=find(f<ff0);
NUM2=find(f>ff1);
NUM3=(3393:1:36415)
NUM=[NUM1';NUM2'];
sig_f(NUM)=5*sig_f(NUM);
sig_f(NUM3)=0*sig_f(NUM3);
%% 音频信号处理
%sig_f(find(f<ff0 & abs(sig_f/L)>0.00005))=0;
%sig_f(find(12000>f>ff1 & abs(sig_f/L)>0.001))=0;

%sig_f(find(f>ff1))=0; %进行滤波，去除蜂鸣

A=abs(sig_f/L);%频域幅度
f=Fs*(1:L)/L;   %频域横坐标轴
figure(1);
plot(f,A);grid on;
title('处理后音频频域图');
xlabel('f/(Hz)');ylabel('y');

X=ifft(sig_f); %傅里叶反变换
figure(2);
plot(t,X);grid on
title('处理后音频时域图');
xlabel('f/(Hz)');ylabel('y');
h=10*real(X);  %取实部并放大音量
sound(h,Fs);    %播放

