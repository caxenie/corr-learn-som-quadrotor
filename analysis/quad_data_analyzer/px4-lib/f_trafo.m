function [f,H, phase] = f_trafo(x,Ts)

n = length(x);
Fs = 1/Ts;

% get complex transform result
Y = fft(x,n) / n;          

% get the positive side sample count (symmetric result)
M = floor(n/2) + 1;

% get freq line
f = Fs/2 * linspace(0,1,M);    

% get the absolute value, the norm of the complex number
H = 2*abs(Y(1:M));

phase = angle(Y(1:M));

% the absolute value at the center must not be multiplied as it only
%   exists once
H(1) = abs(Y(1));

end