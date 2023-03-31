clc;clear;
%% matlab 完成Sa信号的采样和恢复以及误差计算
%% 取样（3s取样）
clc;clear;
% 取样
figure(1);
wm = 1000; %信号的最大频率
ws = 6 * wm; %信号的采样频率（根据奈奎斯特频率）%原来是2* wm
wc = 0.5 * ws;%滤波器的截止频率
Ts = 2*pi/ws;%采样间隔
N = 10000;%时域采样点数
n = -N:N;
N1=length(n)
Dt = 0.005;
t = -300:Dt:300;
nTs = n * Ts;%采样数据的采样时间
fs = sin(nTs/pi);%完成采样
subplot(411);
pop=nTs/pi
stem(nTs/pi,fs,'LineWidth',1);
xlabel("nTs");
ylabel("f(nTs)");
title("sa(t)的3s采样信号");
%频谱
%subplot(412);
%y1=fft(fs)
%plot(fftshift(abs(y1)))
subplot(412);
y1=fftshift(abs(fft(fs,N1))); %用fft得出离散傅里叶变换
ff=-ws/2:ws/N1:(ws/2-ws/N1);%频域横坐标，注意奈奎斯特采样定理，最大原信号最大频率不超过采样频率的一半
plot(ff,y1/max(max(abs(y1))))
xlabel("f/Hz")
ylabel("幅度")
% 还原
Dt = 0.005;
t = -30:Dt:30;
fa = Ts*wc/pi * fs * sinc((wc/pi)*(ones(length(nTs),1)*t-nTs'*ones(1,length(t))));

subplot(413);
plot(t,fa,'LineWidth',1);
xlabel("t");
ylabel("f(t)");
title("由3s取样信号重构sa(t)");

% 展示误差
error = fa-sinc(t/pi);
subplot(414);
plot(t,error,'LineWidth',1);
xlabel("t");
ylabel("error(t)");
title("重构信号与原信号的误差error(t)");


%% 取样（过取样）
clc;clear;
% 取样
figure(2);
wm = 1; %信号的最大频率
ws = 1/3 * wm; %信号的采样频率（根据奈奎斯特频率）%原来是4* wm
wc = 0.5 * ws;%滤波器的截止频率
Ts = 2*pi/ws;%采样间隔
N = 10;%时域采样点数
n = -N:N;
N1=length(n);
nTs = n * Ts;%采样数据的采样时间
fs = sinc(nTs/pi);%完成采样
subplot(411);
stem(nTs/pi,fs,'LineWidth',1);
xlabel("nTs");
ylabel("f(nTs)");
title("sa(t)的6s样信号");
%频谱
subplot(412);
y1=fftshift(abs(fft(fs,N1))); %用fft得出离散傅里叶变换
ff=-ws/2:ws/N1:(ws/2-ws/N1);%频域横坐标，注意奈奎斯特采样定理，最大原信号最大频率不超过采样频率的一半
plot(ff,y1/max(max(abs(y1))))
xlabel("f/Hz")
ylabel("幅度")

% 还原
Dt = 0.005;
t = -30:Dt:30;
fa = fs*Ts*wc/pi * sinc((wc/pi)*(ones(length(nTs),1)*t-nTs'*ones(1,length(t))));
subplot(413);
plot(t,fa,'LineWidth',1);
xlabel("t");
ylabel("f(t)");
title("由6s样信号重构sa(t)");
% 展示误差
error = fa-sinc(t/pi);
subplot(414);
plot(t,error,'LineWidth',1);
xlabel("t");
ylabel("error(t)");
title("重构信号与原信号的误差error(t)");

%% 取样（欠取样）

% 取样
figure(3);
wm = 1; %信号的最大频率
ws = 4 * wm; %信号的采样频率（根据奈奎斯特频率）1.5 * wm
wc = 0.5 * ws;%滤波器的截止频率
Ts = 2*pi/ws;%采样间隔
N = 10;%时域采样点数 7
n = -N:N;
nTs = n * Ts;%采样数据的采样时间
fs = sinc(nTs/pi);%完成采样
subplot(411);
stem(nTs/pi,fs,'LineStyle','-.','MarkerEdgeColor','red');
pip=nTs/pi
xlabel("nTs");
ylabel("f(nTs)");
title("sa(t)的欠取样信号");
%频谱
subplot(412);
y1=fftshift(abs(fft(fs,N1))); %用fft得出离散傅里叶变换
ff=-ws/2:ws/N1:(ws/2-ws/N1);%频域横坐标，注意奈奎斯特采样定理，最大原信号最大频率不超过采样频率的一半
plot(ff,y1/max(max(abs(y1))))
xlabel("f/Hz")
ylabel("幅度")
% 还原
Dt = 0.005;
t = -30:Dt:30;
fa = fs*Ts*wc/pi * sinc((wc/pi)*(ones(length(nTs),1)*t-nTs'*ones(1,length(t))));
subplot(413);
plot(t,fa,'LineWidth',1);
xlabel("t");
ylabel("f(t)");
title("由欠取样信号重构sa(t)");
% 展示误差
error = fa-sinc(t/pi);
subplot(414);
plot(t,error,'LineWidth',1);
xlabel("t");
ylabel("error(t)");
title("重构信号与原信号的误差error(t)");
%%
clc;clear;
%figure(4);
t=-20:0.001:20;y=sinc(t);plot(y);
%figure(5);y1=fft(y);plot(abs(y1));
