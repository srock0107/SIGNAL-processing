clc;clear;
%% matlab ���Sa�źŵĲ����ͻָ��Լ�������
%% ȡ����3sȡ����
clc;clear;
% ȡ��
figure(1);
wm = 1000; %�źŵ����Ƶ��
ws = 6 * wm; %�źŵĲ���Ƶ�ʣ������ο�˹��Ƶ�ʣ�%ԭ����2* wm
wc = 0.5 * ws;%�˲����Ľ�ֹƵ��
Ts = 2*pi/ws;%�������
N = 10000;%ʱ���������
n = -N:N;
N1=length(n)
Dt = 0.005;
t = -300:Dt:300;
nTs = n * Ts;%�������ݵĲ���ʱ��
fs = sin(nTs/pi);%��ɲ���
subplot(411);
pop=nTs/pi
stem(nTs/pi,fs,'LineWidth',1);
xlabel("nTs");
ylabel("f(nTs)");
title("sa(t)��3s�����ź�");
%Ƶ��
%subplot(412);
%y1=fft(fs)
%plot(fftshift(abs(y1)))
subplot(412);
y1=fftshift(abs(fft(fs,N1))); %��fft�ó���ɢ����Ҷ�任
ff=-ws/2:ws/N1:(ws/2-ws/N1);%Ƶ������꣬ע���ο�˹�ز����������ԭ�ź����Ƶ�ʲ���������Ƶ�ʵ�һ��
plot(ff,y1/max(max(abs(y1))))
xlabel("f/Hz")
ylabel("����")
% ��ԭ
Dt = 0.005;
t = -30:Dt:30;
fa = Ts*wc/pi * fs * sinc((wc/pi)*(ones(length(nTs),1)*t-nTs'*ones(1,length(t))));

subplot(413);
plot(t,fa,'LineWidth',1);
xlabel("t");
ylabel("f(t)");
title("��3sȡ���ź��ع�sa(t)");

% չʾ���
error = fa-sinc(t/pi);
subplot(414);
plot(t,error,'LineWidth',1);
xlabel("t");
ylabel("error(t)");
title("�ع��ź���ԭ�źŵ����error(t)");


%% ȡ������ȡ����
clc;clear;
% ȡ��
figure(2);
wm = 1; %�źŵ����Ƶ��
ws = 1/3 * wm; %�źŵĲ���Ƶ�ʣ������ο�˹��Ƶ�ʣ�%ԭ����4* wm
wc = 0.5 * ws;%�˲����Ľ�ֹƵ��
Ts = 2*pi/ws;%�������
N = 10;%ʱ���������
n = -N:N;
N1=length(n);
nTs = n * Ts;%�������ݵĲ���ʱ��
fs = sinc(nTs/pi);%��ɲ���
subplot(411);
stem(nTs/pi,fs,'LineWidth',1);
xlabel("nTs");
ylabel("f(nTs)");
title("sa(t)��6s���ź�");
%Ƶ��
subplot(412);
y1=fftshift(abs(fft(fs,N1))); %��fft�ó���ɢ����Ҷ�任
ff=-ws/2:ws/N1:(ws/2-ws/N1);%Ƶ������꣬ע���ο�˹�ز����������ԭ�ź����Ƶ�ʲ���������Ƶ�ʵ�һ��
plot(ff,y1/max(max(abs(y1))))
xlabel("f/Hz")
ylabel("����")

% ��ԭ
Dt = 0.005;
t = -30:Dt:30;
fa = fs*Ts*wc/pi * sinc((wc/pi)*(ones(length(nTs),1)*t-nTs'*ones(1,length(t))));
subplot(413);
plot(t,fa,'LineWidth',1);
xlabel("t");
ylabel("f(t)");
title("��6s���ź��ع�sa(t)");
% չʾ���
error = fa-sinc(t/pi);
subplot(414);
plot(t,error,'LineWidth',1);
xlabel("t");
ylabel("error(t)");
title("�ع��ź���ԭ�źŵ����error(t)");

%% ȡ����Ƿȡ����

% ȡ��
figure(3);
wm = 1; %�źŵ����Ƶ��
ws = 4 * wm; %�źŵĲ���Ƶ�ʣ������ο�˹��Ƶ�ʣ�1.5 * wm
wc = 0.5 * ws;%�˲����Ľ�ֹƵ��
Ts = 2*pi/ws;%�������
N = 10;%ʱ��������� 7
n = -N:N;
nTs = n * Ts;%�������ݵĲ���ʱ��
fs = sinc(nTs/pi);%��ɲ���
subplot(411);
stem(nTs/pi,fs,'LineStyle','-.','MarkerEdgeColor','red');
pip=nTs/pi
xlabel("nTs");
ylabel("f(nTs)");
title("sa(t)��Ƿȡ���ź�");
%Ƶ��
subplot(412);
y1=fftshift(abs(fft(fs,N1))); %��fft�ó���ɢ����Ҷ�任
ff=-ws/2:ws/N1:(ws/2-ws/N1);%Ƶ������꣬ע���ο�˹�ز����������ԭ�ź����Ƶ�ʲ���������Ƶ�ʵ�һ��
plot(ff,y1/max(max(abs(y1))))
xlabel("f/Hz")
ylabel("����")
% ��ԭ
Dt = 0.005;
t = -30:Dt:30;
fa = fs*Ts*wc/pi * sinc((wc/pi)*(ones(length(nTs),1)*t-nTs'*ones(1,length(t))));
subplot(413);
plot(t,fa,'LineWidth',1);
xlabel("t");
ylabel("f(t)");
title("��Ƿȡ���ź��ع�sa(t)");
% չʾ���
error = fa-sinc(t/pi);
subplot(414);
plot(t,error,'LineWidth',1);
xlabel("t");
ylabel("error(t)");
title("�ع��ź���ԭ�źŵ����error(t)");
%%
clc;clear;
%figure(4);
t=-20:0.001:20;y=sinc(t);plot(y);
%figure(5);y1=fft(y);plot(abs(y1));
