function [ld_out] = add_acc_a_rot(ld)


if(isfield(ld,'rb') == 0 || isfield(ld,'imu') == 0)
    ld_out = ld;
    return;
end

%**************************************************************************
%%      rotational-graviational acceleration: accelerometer based
%           with tracker linear acceleration as reference
%**************************************************************************


% transform tracker accelerations to drone coord.
ax = -ld.rb.az;
ay = ld.rb.ax;
az = -ld.rb.ay;

t = ld.rb.hrt.t;

% interpolate tracker data to imu hrt timeline
a_lin(1,:) = interp1(t,  ax,     ld.imu.hrt.t);
a_lin(2,:) = interp1(t,  ay,     ld.imu.hrt.t);
a_lin(3,:) = interp1(t,  az,     ld.imu.hrt.t);


% substract linear acceleration from net-linear acceleration
ld.acc.a_rot = ld.acc.a - a_lin;

% filter
ld.acc.a_rot_f = filter_vec_bw_LP(ld.acc.a_rot, 2, 3, ld.imu.hrt.freq_mean);


% get components of rotational acc
ax = ld.acc.a_rot_f(1,:);
ay = ld.acc.a_rot_f(2,:);
% az = ld.acc.a_rot_f(3,:);
az = -ld.g;


% calculate roll an pitch angles
ld.acc.rot.roll = -atan2(ay, -az);
ld.acc.rot.pitch = atan2(ax, -az);



ld_out = ld;

end



function [vec_f] = filter_vec_bw_LP(vec, N, Fc, Fs)

[z,p,k] = butter(N,Fc/(Fs/2),'low');
[sos,g] = zp2sos(z,p,k);	    % Convert to SOS form
Hf = dfilt.df2tsos(sos,g);      % Create a dfilt object

vec_f(1,:) = filter(Hf,vec(1,:));
vec_f(2,:) = filter(Hf,vec(2,:));
vec_f(3,:) = filter(Hf,vec(3,:));

end



