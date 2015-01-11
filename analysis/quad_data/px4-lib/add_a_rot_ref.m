function [ld_out] = add_a_rot_ref(ld)

if(isfield(ld,'imu') == 0)
    ld_out = ld;
    return;
end


%**************************************************************************
%%      rotational-gravitational acceleration reference
%           attitude / tracker based reference
%**************************************************************************

% EKF
% if(isfield(ld,'att') == 0)
%     ld_out = ld;
%     return;
% end
% t       = ld.att.hrt.t;
% roll    = -ld.att.roll;
% pitch   = -ld.att.pitch;
% yaw     = ld.att.yaw - ld.yaw_off;

% Tracker
if(isfield(ld,'rb') == 0)
    ld_out = ld;
    return;
end
t       = ld.rb.hrt.t;
roll    = ld.rb.roll;
pitch   = -ld.rb.pitch;
yaw     = -ld.rb.yaw;


% interpolate data to imu hrt timeline
roll    = interp1(t,  roll,     ld.imu.hrt.t);
pitch   = interp1(t,  pitch,    ld.imu.hrt.t);
yaw     = interp1(t,  yaw,      ld.imu.hrt.t);

n       = ld.imu.n;
g       = [zeros(1,n);zeros(1,n);-ones(1,n)*ld.g];


% calculate reference for gravitational accereleration reference

% use this function to transform from drone to world coord.
%   if roll,pitch,yaw are correct, that the g Vector is parallel
%   to the z axis of the drone coord. sys
ld.a_rot_ref = vec_inv_rot_euler_rpy_rad(roll, pitch, yaw, g);

ld_out = ld;

end










