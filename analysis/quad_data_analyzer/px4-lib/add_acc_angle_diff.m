function [ld_out] = add_acc_angle_diff(ld)

if(isfield(ld,'imu') == 0)
    ld_out = ld;
    return;
end

roll = ld.acc.raw.roll;
pitch = ld.acc.raw.pitch;


Fs = ld.imu.hrt.freq_mean;
dt_mean = ld.imu.hrt.dt_mean;


% numerically differentiate
droll = num_diff(roll, dt_mean);

% low pass filter raw vel signal
% droll = filter_bw_LP(droll, 2, 6, Fs);


% numerically differentiate
dpitch = num_diff(pitch, dt_mean);

% low pass filter raw vel signal
% dpitch = filter_bw_LP(dpitch, 2, 6, Fs);


ld.acc.raw.droll = droll;
ld.acc.raw.dpitch = dpitch;

ld_out = ld;

end


function [y] = filter_bw_LP(x, N, Fc, Fs)

[z,p,k] = butter(N,Fc/(Fs/2),'low');
[sos,g] = zp2sos(z,p,k);	    % Convert to SOS form
Hf = dfilt.df2tsos(sos,g);      % Create a dfilt object

y(1,:) = filter(Hf,x);

end


function [vec_f] = filter_vec_FIR_LP(vec, N, Fc, Fs)

d = fdesign.lowpass('N,Fc',N,Fc,Fs);
Hf = design(d,'FIR');

vec_f(1,:) = filter(Hf,vec(1,:));
vec_f(2,:) = filter(Hf,vec(2,:));
vec_f(3,:) = filter(Hf,vec(3,:));

end


function [dx] = num_diff(x, dt)

n = length(x);

s = size(dt);

if(s(1) == 1 && s(2) == 1)
    dt = ones(1,n)*dt;
end


dx= zeros(1,n);

for k=2:n
    dx(k) = (x(k) - x(k-1)) ./ dt(k);
end


end


function [dvec] = num_diff_vec(vec, dt)

n = size(vec,2);

s = size(dt);

if(s(1) == 1 && s(2) == 1)
    dt = ones(1,n)*dt;
end


dvec = zeros(3,n);

for k=2:n
    dvec(:,k) = (vec(:,k) - vec(:,k-1)) ./ dt(k);
end


end












