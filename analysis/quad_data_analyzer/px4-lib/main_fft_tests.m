clear all
close all

f1 = 50;
f2 = 250;

Fs = 1e3;
Ts = 1/Fs;

n = 1000;

t = (0:n-1) * Ts;

x = 5 * sin(2*pi*f1*t)+10 -10*sin(2*pi*f2*t);


[f,H,phi] = f_trafo(x,Ts);

r=3;
c=1;

figure
subplot(r,c,1)
plot(t,x);
grid on

subplot(r,c,2)
plot(f,H) 
grid on


subplot(r,c,3)
plot(f,phi) 
grid on


Fc = 50;       % cut-off freq (-6dB)
N = 10;         % FIR filter order

d = fdesign.lowpass('N,Fc',N,Fc,Fs);
Hf = design(d,'FIR');

[z,p,k] = butter(N,Fc/(Fs/2),'low');
[sos,g] = zp2sos(z,p,k);	     % Convert to SOS form
Hd = dfilt.df2tsos(sos,g);   % Create a dfilt object


% show filter
% fvtool(Hf)
% fvtool(Hd,'Fs',Fs)

% apply filter
% x_FIR = filter(Hf,x);
x_FIR = filter(Hd,x);

[f,H] = f_trafo(x_FIR,Ts);

r=2;
c=1;

figure
subplot(r,c,1)
plot(t,x_FIR);
grid on

subplot(r,c,2)
plot(f,H) 
grid on


W = 100;

figure
[S,F,T] = spectrogram(x,W,[],n,Fs);

% contour(T,F,abs(S))

% F = F./2;
H = 4*abs(S)./W;

H(1,:) = H(1,:);

mesh(T,F,abs(H));

