clc;clear all;
close all;
%% --------------����Ԥ����--------------
picnum = 3; % ͼƬ����
c = 3e+8; % ����
targetNum = 3; % Ŀ������
gain = 1e+5; % �ز��ź�����
noisePower = 10; % ����ƽ������

% �źŵĲ������� 
A = 1e+3;         % ʱ���ֵ
T = 10e-6;      % �ź�ʱ��/us
B = 100e+6;     % �źŴ���/Mhz
K=B/T;         % ��Ƶб��
Fs=2*B;        % ����Ƶ��
Ts=1/Fs;       % ��������
N=T/Ts;       % ��������
Kmis = 0;      %��Ƶ��ʧ��ֵ
F0 = 0;         %����ʧ��Ƶ��

t=linspace(-T/2,T/2,N);
freq=linspace(-Fs/2,Fs/2,N);
width = T/2;

targetDistance = [ 200 , 250 , 275 , 288 , 500 , 800 ]; % Ŀ�����
delayTime = 2.*targetDistance ./ c; % Ŀ��ʱ��
echoIntensity = gain .* A./(targetDistance.^4); % Ŀ���ź�ǿ��˥��


%% --------------�ź�����-------------------
% �źų�ʼ��
targetEcho = zeros( targetNum , int16(N) ); 
targetEchoFreq = zeros( targetNum , int16(N) ); 
targetEchoOutFreq = zeros( targetNum , int16(N) ); 
targetEchoOut =  zeros( targetNum , int16(N) );
% ���������ź�
noise = wgn( targetNum , int16(N) , noisePower ); 
% ���� chirp �ź�
st=A*(rectpuls(t,width)).*exp( 1j*(2*pi*F0*t+pi*(K+Kmis)*t.^2)); 
% �����ز��ź�
for i = 1 : targetNum
    targetEcho(i,:) =  echoIntensity(i) .* A .* rectpuls( t - delayTime(i) , width ).*exp(1j * (2*pi*F0*(t - delayTime(i)) ...
        + pi*(K+Kmis)*(t - delayTime(i)).^2)) ;
    targetEcho(i,:) =  targetEcho(i,:) ;
end
% ����ƥ���˲���
matchFilter = A*exp( 1j*(pi/K*freq.^2));
% ���ƻز�ͼ��
targetEchoSum = zeros( 1 , int16(N) );
for i = 1:targetNum
    targetEchoSum = targetEchoSum + targetEcho(i,:);
end

figure(1)
subplot(2,1,1)
plot(t , real(targetEcho));
title('echo in time domain');
grid on;
axis tight;
subplot(2,1,2)
plot(t,targetEchoSum);
grid on;
axis tight;

%% ---------------�źŴ���--------------------
for i = 1 : targetNum
    targetEchoFreq( i , : ) = fft( targetEcho(i,:) ); % �Իز����и���Ҷ�任
    targetEchoOutFreq( i , : ) = targetEchoFreq( i , : ) .* matchFilter; % Ƶ���Ͻ����˲�
    targetEchoOut( i , : ) = ifft(targetEchoOutFreq( i , : ));
end
% ��������ѹ����Ļز�ͼ��
 figure(2)
 plot(t,targetEchoOut);
 title('echo in time domain after impulse compression');
 grid on;
 axis tight;
 % ��������Ƶ����λ���˲�����λ�����Ƶ����λ
stFreq = fft( st ); % �Իز����и���Ҷ�任
stFreqOut= stFreq .* matchFilter; % Ƶ���Ͻ����˲�
stOut = ifft(stFreqOut);
figure(3)
plot(freq,unwrap(angle(stFreq)),freq,unwrap(angle(matchFilter)),freq,unwrap(angle(stFreqOut)));
grid on;
legend('stFreq','matchFilter','stFreqOut');
