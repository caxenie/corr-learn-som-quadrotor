function [ld_out] = add_acc_precalcs(ld)

if(isfield(ld,'imu') == 0)
    ld_out = ld;
    return;
end


ld.acc.ax = ld.imu.xacc;
ld.acc.ay = ld.imu.yacc;
ld.acc.az = ld.imu.zacc;

ld.acc.ax_off = mean(ld.acc.ax(1:100));
ld.acc.ay_off = mean(ld.acc.ay(1:100));

ld.acc.ax = ld.acc.ax - ld.acc.ax_off;
ld.acc.ay = ld.acc.ay - ld.acc.ay_off;


% get net linear acceleration (graviational + translational linear acceleration)
ld.acc.a = [ld.acc.ax';ld.acc.ay';ld.acc.az'];

% low-pass filter net linear acceleration
ld.acc.a_f = filter_vec_bw_LP(ld.acc.a, 2, 3, ld.imu.hrt.freq_mean);

% calculate norm of net linear acceleration
ld.acc.a_norm = tline_norm(ld.acc.a);


% filter components of net linear acceleration in a different manner
Fc = 2;
ld.acc.ax_f = filter_bw_LP(ld.acc.ax, 2, Fc, ld.imu.hrt.freq_mean);
ld.acc.ay_f = filter_bw_LP(ld.acc.ay, 2, Fc, ld.imu.hrt.freq_mean);
ld.acc.az_f = filter_bw_LP(ld.acc.az, 2, 0.8, ld.imu.hrt.freq_mean);


ax = ld.acc.ax;
ay = ld.acc.ay;
az = -ld.acc.az - ld.g;


Fc = 2;
ax_f = filter_bw_LP(ax, 2, Fc, ld.imu.hrt.freq_mean);
ay_f = filter_bw_LP(ay, 2, Fc, ld.imu.hrt.freq_mean);
az_f = filter_bw_LP(az, 2, Fc, ld.imu.hrt.freq_mean);



ld.acc.noise.ax = ax - ax_f;
ld.acc.noise.ay = ay - ay_f;
ld.acc.noise.az = az - az_f;

ld.acc.noise.ax_mean = mean(ld.acc.noise.ax);
ld.acc.noise.ax_std = std(ld.acc.noise.ax);

ld.acc.noise.ay_mean = mean(ld.acc.noise.ay);
ld.acc.noise.ay_std = std(ld.acc.noise.ay);

ld.acc.noise.az_mean = mean(ld.acc.noise.az);
ld.acc.noise.az_std = std(ld.acc.noise.az);


ax = ld.acc.ax_f;
ay = ld.acc.ay_f;
az = ld.acc.az_f;

g = ld.g;

% decides which points are on a sphere with radius g and threshold 0.1g
ld.acc.valid = sphericalFilter(ax,ay,az, g, 0.1*g);


% calculate roll and pitch angles
ax = ld.acc.ax_f;
ay = ld.acc.ay_f;
az = ld.acc.az_f;

ld.acc.raw.roll     = -atan2(ay, -az);
ld.acc.raw.pitch    = atan2(ax, -az);


% n = ld.imu.n;
% 
% for k=1:n
%     
%     roll = ld.acc.raw.roll(k);
%     z = ay(k)*sin(roll) + -az(k)*cos(roll);
% 
%     ld.acc.raw.pitch(k) = atan2(ax(k), z);
% 
% end


ax = ld.acc.ax;
ay = ld.acc.ay;
az = ld.acc.az;

ld.acc.raw.uf.roll     = -atan2(ay, -az);
ld.acc.raw.uf.pitch    = atan2(ax, -az);



ld_out = ld;

end










