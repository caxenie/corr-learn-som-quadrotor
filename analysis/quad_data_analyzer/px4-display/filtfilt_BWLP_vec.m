function [fvec] = filtfilt_BWLP_vec(vec, N, Fc, Fs)

[z,p,k] = butter(N,Fc/(Fs/2),'low');
[sos,g] = zp2sos(z,p,k);	    % Convert to SOS form

fvec(1,:) = filtfilt(sos,g,vec(1,:));
fvec(2,:) = filtfilt(sos,g,vec(2,:));
fvec(3,:) = filtfilt(sos,g,vec(3,:));

% h=fdesign.lowpass('N,F3dB',N,Fc/(Fs/2));
% d1 = design(h,'butter');
% y = filtfilt(d1.sosMatrix,d1.ScaleValues,x');


end