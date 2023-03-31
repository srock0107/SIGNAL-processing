n=11length(x);
w=2pinlength(n);
allpass=(-0.7+exp(-1iw)).(1-0.7exp(-1iw));%设极点为0.7
theta=-w-2atan(0.7sin(w).(1-0.7cos(w)));
syms w1
theta1=-w1-2atan(0.7sin(w1).(1-0.7cos(w1)));
group=diff(theta1,w1);%=(2((7cos(w1))(10((7cos(w1))10 - 1))
+ (49sin(w1)^2)(100((7cos(w1))10 -
1)^2)))((49sin(w1)^2)(100((7cos(w1))10 - 1)^2) + 1) - 1
%%
% 画一阶全通滤波器的幅度和相位
figure(1)
subplot(2,1,1)
plot(wpi,abs(allpass));
xlabel('wpi');
ylabel('magnitude');
axis([0 2 0 2]);
title('一阶全通滤波器的幅度');
set(gca,'FontSize',14);
subplot(2,1,2)
plot(wpi,unwrap(angle(allpass)));
xlabel('wpi');
ylabel('phase');
title('一阶全通滤波器的相位');
set(gca,'FontSize',14);
%%
%画N 阶全通滤波器的相位
figure(2)
for N=1020110
%subplot(3,1,1);
plot(wpi,unwrap(angle(allpass.^N)));
hold on
xlabel('wpi');
ylabel('phase');
legend({'N=10','N=30','N=50','N=70','N=90','N=110'});
title('N 阶全通滤波器的相位');
set(gca,'FontSize',14);
end
hold off
%%
%画N 阶全通滤波器的相位延迟
figure(3)
for N=1020110
tao_phase=-Ntheta.w;
plot(wpi,tao_phase);
hold on
xlabel('wpi');
ylabel('相位延迟');
legend({'N=10','N=30','N=50','N=70','N=90','N=110'});
title('N 阶全通滤波器的相位延迟');
set(gca,'FontSize',14);
end
hold off
%%
%画N 阶全通滤波器的群延迟
figure(4)
for N=1020110
tao_group=-N.((2.((7.cos(w)).(10.((7.cos(w)).10 - 1))
+ (49sin(w).^2).(100.((7.cos(w)).10 -
1).^2))).((49.sin(w).^2).(100.((7.cos(w)).10 - 1).^2) + 1)
- 1);
plot(wpi,tao_group);
hold on
xlabel('wpi');
ylabel('群延迟');
legend({'N=10','N=30','N=50','N=70','N=90','N=110'});
title('N 阶全通滤波器的群延迟');
set(gca,'FontSize',14);
end

%读取音频数据
y=audioread('sound_mix.wav');
N=length(y);
w=linspace(0,2*pi,N)';
t=linspace(0,3,N);
Yw=fft(y);
%原始音频波形图
subplot(2,2,1)
plot(t,y);
title('before all-pass');
xlabel('t/s');
%经过全通过滤波器后的音频波形图
subplot(2,2,2)
%指定阶数
N_order=30;
Hw=( (exp(-1j*w)-0.9 )./ ( 1-0.9*exp(-1j*w)) ).^N_order;
y=ifft(Yw.*Hw);
plot(t,y)
title('after all-pass(N=30)');
xlabel('t/s');
subplot(2,2,3)
%指定阶数
N_order=70;
Hw=( (exp(-1j*w)-0.9 )./ ( 1-0.9*exp(-1j*w)) ).^N_order;
y=ifft(Yw.*Hw);
plot(t,y)
title('after all-pass(N=70)');
xlabel('t/s');
subplot(2,2,4)
%指定阶数
N_order=110;
Hw=( (exp(-1j*w)-0.9 )./ ( 1-0.9*exp(-1j*w)) ).^N_order;
y=ifft(Yw.*Hw);
plot(t,y)
title('after all-pass(N=110)');
xlabel('t/s');