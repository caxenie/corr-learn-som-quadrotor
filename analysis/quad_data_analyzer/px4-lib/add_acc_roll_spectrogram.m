function [ld_out] = add_acc_roll_spectrogram(ld)

if(isfield(ld,'imu') == 0)
    ld_out = ld;
    return;
end

n = ld.imu.n;
Fs = ld.imu.hrt.freq_mean;
% x = ld.acc.raw.roll;
x = ld.acc.raw.uf.roll;

W = 50;
[S,F,T] = spectrogram(x,W,[],n,Fs,'yaxis');
H = 4*abs(S)./W;
H(1,:) = H(1,:);

ld.acc.SG.roll.W = W;
ld.acc.SG.roll.F = F;
ld.acc.SG.roll.T = T;
ld.acc.SG.roll.H = H;
ld.acc.SG.roll.S = S;


n = ld.att.n;
Fs = ld.att.hrt.freq_mean;
x = ld.att.roll-ld.att.roll_off;

W = 12;
[S,F,T] = spectrogram(x,W,[],n,Fs,'yaxis');
H = 4*abs(S)./W;
H(1,:) = H(1,:);


ld.att.SG.roll.W = W;
ld.att.SG.roll.F = F;
ld.att.SG.roll.T = T;
ld.att.SG.roll.H = H;
ld.att.SG.roll.S = S;



ld_out = ld;

end