function [ld_out] = add_gyro_precalcs(ld)

if(isfield(ld,'imu') == 0)
    ld_out = ld;
    return;
end

n = ld.imu.n;

roll   = zeros(n,1);
pitch  = zeros(n,1);
yaw    = zeros(n,1);


% numerically integrate angular velocities
for k=2:n
    roll(k)     = roll(k-1)   + ld.imu.xgyro(k-1) * ld.imu.hrt.dt(k);
    pitch(k)    = pitch(k-1)  + ld.imu.ygyro(k-1) * ld.imu.hrt.dt(k);
    yaw(k)      = yaw(k-1)    + ld.imu.zgyro(k-1) * ld.imu.hrt.dt(k);
end


ld.gyro.raw.or = [roll';pitch';yaw'];

ld.gyro.raw.roll = roll;
ld.gyro.raw.pitch = pitch;
ld.gyro.raw.yaw = yaw;



% filter raw inputs; estimate noise component

vr = ld.imu.xgyro;
vp = ld.imu.ygyro;
vy = ld.imu.zgyro;

Fc = 10;
vr_f = filter_bw_LP(vr, 2, Fc, ld.imu.hrt.freq_mean);
vp_f = filter_bw_LP(vp, 2, Fc, ld.imu.hrt.freq_mean);
vy_f = filter_bw_LP(vy, 2, Fc, ld.imu.hrt.freq_mean);

ld.gyro.vr_f = vr_f;
ld.gyro.vp_f = vp_f;
ld.gyro.vy_f = vy_f;

ld.gyro.noise.vr = vr - vr_f;
ld.gyro.noise.vp = vp - vp_f;
ld.gyro.noise.vy = vy - vy_f;

ld.gyro.noise.vr_mean = mean(ld.gyro.noise.vr);
ld.gyro.noise.vp_mean = mean(ld.gyro.noise.vp);
ld.gyro.noise.vy_mean = mean(ld.gyro.noise.vy);


ld.gyro.noise.vr_std = std(ld.gyro.noise.vr);
ld.gyro.noise.vp_std = std(ld.gyro.noise.vp);
ld.gyro.noise.vy_std = std(ld.gyro.noise.vy);


ld_out = ld;

end