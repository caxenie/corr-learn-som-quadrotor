clear all
close all

Fs = 0.5e2;

t= 0:(1/Fs):1;

f=10;

x = sin(2*pi*t*f);


Fc = 1;
N = 100;   % FIR filter order
d=fdesign.lowpass('N,Fc',N,Fc,Fs);
Hf = design(d,'FIR');
y = filter(Hf,x); 


fvtool(Hf,1)

figure
subplot(211)
plot(t,x);
grid on

subplot(212)
plot(t,y,'r');
grid on