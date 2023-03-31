
%%
% 特定采样率声⾳信号录制
% recorder = audiorecorder;
% Fs = 44100; %设置特定的采样率44100Hz
% nBits = 16; %采样位数16
% NumChannels = 2;
% recorder = audiorecorder(Fs,nBits,NumChannels); % 调⽤电脑⻨克⻛，开始声⾳录制
% disp('strat speaking:');
% recordblocking(recorder,1); % 录制1s的声⾳信号
% disp('stop speaking');
% 
% %特定采样率声⾳信号播放
% myrecording = getaudiodata(recorder); %getaudiodata--读取声⾳信号信息
% filename = 'handel.wav';
% audiowrite(filename,myrecording,44100)%特定频率的采集mav信号

%%
%分析采集音频
clc;clear
[y,fs]=audioread('handel.wav');%从名为 filename 的文件中读取数据，并返回样本数据 y 以及该数据的采样率 Fs
%sound(y,fs);
y0=y(:,1);%左声道
%sound(y0,fs);
N=length(y0);   %信号序列长度
n=0:N-1;
t=(0:N-1)/fs;   %时间
yfft=fft(y0,N); %对信号做n点fft变换
f=(0:floor(N/2)-1)*fs/N;
figure(1);
subplot(3,1,1);
plot(t,y0);title('原始声音信号的时域波形图');xlabel('时间/s');ylabel('振幅');
subplot(3,1,2);
plot(abs(yfft));title('原始声音信号的幅值图');ylabel('幅值');
subplot(3,1,3);
plot(f,abs(yfft(1:floor(N/2))));title('原始声音信号的频谱图');xlabel('频率/Hz');ylabel('幅值');

%% 
%在10kHz添加噪音信号
fz=10000;              %噪音频率
xz=0.1*sin(2*pi*fz*t);%噪声序列，以sin为例
y1=y0+xz';
%sound(y1,fs);
yfft1=fft(y1,N); %对信号做n点fft变换
f=(0:floor(N/2)-1)*fs/N;
figure(2);
subplot(3,1,1);
plot(t,y1);title('加噪声音信号的时域波形图');xlabel('时间/s');ylabel('振幅');
subplot(3,1,2);
plot(abs(yfft1));title('加噪声音信号的幅值图');ylabel('幅值');
subplot(3,1,3);
plot(f,abs(yfft1(1:floor(N/2))));title('加噪声音信号的频谱图');xlabel('频率/Hz');ylabel('幅值');

%%

b=[1 -exp(i*2*pi*fz/fs)];
a=[0 1];
[h,f] = freqz(b,a,N/2);
figure(3)
subplot(3,1,1)
plot(f(1:N/2)*fs/2/pi,20*log10(abs(h(1:N/2))));
xlabel('频率/Hz');ylabel('幅值/dB');
title('FIR滤波器的频谱图')

subplot(3,1,2)
yfft2=yfft1(1:N/2).*h;
plot(f,abs(yfft2(1:N/2)));
title('滤波后的频谱')
xlabel('频率/Hz');ylabel('幅值')

subplot(3,1,3)
y3=ifft(yfft2,fs);
sound(real(y3),fs)
%audiowrite('signal_after_ filter_10khz.wav',real(y3),fs)
plot(n,real(y3))
title('滤波后的波形');xlabel('时间/s');ylabel('振幅');


%画出FIR滤波器的零极点图
% %
% 自适应滤波
% 多在几个频率加噪声
% 添加其他频率点的啸叫,分别在1khz,8khz，20khz，30khz添加
fz1=[1000 8000 14000 20000];              %噪音频率
xz1=0.1*(sin(2*pi*fz1(1)*t)+sin(2*pi*fz1(2)*t)+sin(2*pi*fz1(3)*t)+sin(2*pi*fz1(4)*t));%噪声序列，以sin为例
xz2=xz1';
y4=y0+xz1';
sound(y4,fs);
%audiowrite('signal_after_several_Hz.wav',real(y4),fs)
yfft4=fft(y4,N); %对信号做n点fft变换
f=(0:floor(N/2)-1)*fs/N;
figure(5);
subplot(3,1,1);
plot(t,y4);title('加多频噪声音信号的时域波形图');xlabel('时间/s');ylabel('振幅');
subplot(3,1,2);
plot(abs(yfft4));title('加多频噪声音信号的幅值图');ylabel('幅值');
subplot(3,1,3);
plot(f,abs(yfft4(1:floor(N/2))));title('加多频噪声音信号的频谱图');xlabel('频率/Hz');ylabel('幅值');

%%
%拓展
%分帧：语音信号是瞬时变化的，语音信号在宏观上是不平稳的，在微观上是平稳的，具有短时平稳性（10---30ms内可以认为语音信号近似不变），这个就可以把语音信号分为一些短段来进行处理，每一个短段称为一帧。
%帧移：帧移后的每一帧信号都有上一帧的成分，防止两帧之间的不连续。语音信号虽然短时可以认为平稳，但是由于人说话并不是间断的，每帧之间都是相关的，加上帧移可以更好地与实际的语音相接近。
%因此，设置帧长度为20ms(882个点)，相邻帧重叠为10ms(441个点),反映到频谱上也是相同的点数
%检测方法：求功率谱，R=10lg(Pmax/Pav)，Pmax为最大幅值，Pav为每帧的平均功率，R为判定系数
%若在一段连续的时间内，R大于某个门限值，则认为最大点对应的频率点为啸叫频点





l=882;%一帧的点数
s=49;%帧的数量
power=abs(yfft4(1:N/2)).^2;%功率
R=[];
Index=[];
for i = 1:s
    pt=power((i-1)*l/2+1:(i+1)*l/2); %分帧
    Pmax=max(pt);
    Pav=mean(pt);
    R(i)=10*log10(Pmax)-10*log10(Pav); 
    if R(i)>20%18-25都差不多可用
        if ismember(find(power==Pmax),Index)==0
            Index=[Index,find(power==Pmax)];
        end
    end
end

% 自适应啸叫抑制方法，与之前类似
zsy(Index,yfft4)


function zsy(Index,yfft4)
fs=44100;
N=44100;
f=(0:floor(N/2)-1)*fs/N;

for i=1:length(Index)
    time=1;
    A=exp(1i*2*pi*Index(i)/fs);
    b=[1,-A];
    a=[0,1];
    [h1,f1]=freqz(b,a,N/2);
    figure(6+i)
    subplot(2,1,1)
    plot(f1(1:N/2)*fs/2/pi,20*log10(abs(h1)));
    title("第"+num2str(i(time))+'个FIR滤波器的频谱图')
    xlabel('频率/Hz');ylabel('幅值/dB')
    subplot(2,1,2)
    yfft4=yfft4(1:N/2).*h1(1:N/2);
    plot(f,abs(yfft4(1:N/2)));
    
    title("滤"+num2str(i(time))+"次波后的频谱")
    xlabel('频率/Hz');ylabel('幅值')
    time=1+time;
end
y5=ifft(yfft4,fs);
sound(real(y5),fs)
% audiowrite('signal_filter_several_Hz.wav',real(y5),fs)
end
%%
% M = 3;                       %定义FIR滤波器阶数
% lamda = 1;                %定义遗忘因子
% Signal_Len = N - M -1;   %定义信号数据的个数
% I = eye(M);                   %生成对应的单位矩阵
% c = 1;                   %小正数 保证矩阵P非奇异
% y_out = zeros(Signal_Len,1);
% Eta_out = zeros(Signal_Len,1);
% w_out = zeros(Signal_Len,M);
% for i=1:Signal_Len
%     %输入数据
%     if i == 1                 %如果是第一次进入
%         P_last = I/c;
%         w_last = zeros(M,1);  
%     end
%     d = y4(i+M-1);            %输入新的期望信号
%     x = xz2((M + i -1):-1:i,1);      %输入新的信号矢量
%     %算法正体
%     K = (P_last * x)/(lamda + x'* P_last * x);   %计算增益矢量
%     y = x'* w_last;                          %计算FIR滤波器输出
%     Eta = d - y;                             %计算估计的误差
%     w = w_last + K * Eta;                    %计算滤波器系数矢量
%     P = (I - K * x')* P_last/lamda;          %计算误差相关矩阵
%     %变量更替
%     P_last = P;
%     w_last = w;
%     %滤波结果存储
%     y_out(i) = y;
%     Eta_out(i) = Eta;
%     w_out(i,:) = w';
% end
% figure(9);
% subplot(2,1,1);
% plot(y_out);
% title('滤波器输出');
% subplot(2,1,2);
% plot(Eta_out);
% title('输出误差');
% 
% figure(10);
% plot(t(1:Signal_Len),w_out(:,1),'r',t(1:Signal_Len),w_out(:,fix(M/2)+1),'b',t(1:Signal_Len),w_out(:,M),'y');
% title('自适应滤波器系数');
