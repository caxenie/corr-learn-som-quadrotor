function [ld_out] = add_mag_precalcs(ld)

if(isfield(ld,'imu') == 0)
    ld_out = ld;
    return;
end

ld.mag.bx = ld.imu.xmag;
ld.mag.by = ld.imu.ymag;
ld.mag.bz = ld.imu.zmag;

ld.mag.b = [ld.imu.xmag';ld.imu.ymag';ld.imu.zmag'];

% EKF
if(isfield(ld,'att') == 0)
    ld_out = ld;
    return;
end

t       = ld.att.hrt.t;
roll    = -ld.att.roll;
pitch   = -ld.att.pitch;


% % Tracker
% if(isfield(ld,'rb') == 0)
%     ld_out = ld;
%     return;
% end
% t       = ld.rb.hrt.t;
% roll    = ld.rb.roll;
% pitch   = -ld.rb.pitch;


% interpolate data to imu timeline
roll    = interp1(t,  roll,     ld.imu.hrt.t);
pitch   = interp1(t,  pitch,    ld.imu.hrt.t);


% undo roll and pitch transformations
b_hat = vec_inv_rot_euler_rp_rad(-roll,-pitch, ld.mag.b);

ld.mag.b_hat = b_hat;

bx = b_hat(1,:);
by = b_hat(2,:);

ld.mag.yaw      = atan2(by, bx);

% data for learning 
mf = 0.01;
ld.mag.yaw_lrn  = fix_singularities(atan(mf*sort(by./ bx)));

ld.mag.yaw_off  = mean(ld.mag.yaw(1:100));


ld.mag.yaw_f = filter_bw_LP(ld.mag.yaw,1,10,ld.imu.hrt.freq_mean);


% filter raw inputs; estimate noise component
bx = ld.imu.xmag;
by = ld.imu.ymag;
bz = ld.imu.zmag;

Fc = 10;
bx_f = filter_bw_LP(bx, 2, Fc, ld.imu.hrt.freq_mean);
by_f = filter_bw_LP(by, 2, Fc, ld.imu.hrt.freq_mean);
bz_f = filter_bw_LP(bz, 2, Fc, ld.imu.hrt.freq_mean);

ld.mag.bx_f = bx_f;
ld.mag.by_f = by_f;
ld.mag.bz_f = bz_f;

ld.mag.noise.bx = bx - bx_f;
ld.mag.noise.by = by - by_f;
ld.mag.noise.bz = bz - bz_f;

ld.mag.noise.bx_mean = mean(ld.mag.noise.bx);
ld.mag.noise.by_mean = mean(ld.mag.noise.by);
ld.mag.noise.bz_mean = mean(ld.mag.noise.bz);


ld.mag.noise.bx_std = std(ld.mag.noise.bx);
ld.mag.noise.by_std = std(ld.mag.noise.by);
ld.mag.noise.bz_std = std(ld.mag.noise.bz);



ld_out = ld;

end

