function X=lvbo(x,Fs)
L=length(x);
L1=f*L/Fs;
x(1:L1)=0;
x(L-L1:L)=0;
X=x;
end

