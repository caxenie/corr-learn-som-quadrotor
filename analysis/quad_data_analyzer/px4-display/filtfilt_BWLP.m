function [y] = filtfilt_BWLP(x, N, Fc, Fs)

[z,p,k] = butter(N,Fc/(Fs/2),'low');
[sos,g] = zp2sos(z,p,k);	    % Convert to SOS form
y = filtfilt(sos,g,x);

% h=fdesign.lowpass('N,F3dB',N,Fc/(Fs/2));
% d1 = design(h,'butter');
% y = filtfilt(d1.sosMatrix,d1.ScaleValues,x');


end