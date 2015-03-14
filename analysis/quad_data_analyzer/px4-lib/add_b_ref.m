function [ld_out] = add_b_ref(ld)

if(isfield(ld,'imu') == 0)
    ld_out = ld;
    return;
end

%**************************************************************************
%%      earth magnetic field reference
%           attitude / tracker based reference
%**************************************************************************

% EKF
if(isfield(ld,'att') == 0)
    ld_out = ld;
    return;
end
t       = ld.att.hrt.t;
roll    = -ld.att.roll;
pitch   = -ld.att.pitch;
yaw     = -(ld.att.yaw - ld.yaw_off);



% Tracker
% if(isfield(ld,'rb') == 0)
%     ld_out = ld;
%     return;
% end
% t       = ld.rb.hrt.t;
% roll    = ld.rb.roll;
% pitch   = -ld.rb.pitch;
% yaw     = -ld.rb.yaw;


% interpolate data to imu hrt timeline
roll    = interp1(t,  roll,     ld.imu.hrt.t);
pitch   = interp1(t,  pitch,    ld.imu.hrt.t);
yaw     = interp1(t,  yaw,      ld.imu.hrt.t);

% yaw     = -(ld.mag.yaw_off - ld.mag.yaw_f);

n       = ld.imu.n;

b = ld.b * ones(1,n);


% calculate reference for gravitational accereleration reference
ld.b_ref = vec_inv_rot_euler_rpy_rad(roll, pitch, yaw, b);

ld_out = ld;







end

function [deg] = toDeg(rad)
deg = rad/pi*180;
end

function [v_hat] = vec_inv_rot_euler_rpy_rad(roll, pitch, yaw, v)
n = length(roll);
v_hat=zeros(3,n);

roll = toDeg(roll);
pitch = toDeg(pitch);
yaw = toDeg(yaw);

for k=1:n
  
    if(roll(k) > -180 || roll(k) < 180 )
        v_hat(:,k) = rotx(roll(k)) * v(:,k);
    end
    
    if(pitch(k) > -180 || pitch(k) < 180 )
        v_hat(:,k) = roty(pitch(k)) * v_hat(:,k);
    end
    
    if(yaw(k) > -180 || yaw(k) < 180 )
        v_hat(:,k) = rotz(yaw(k)) * v_hat(:,k);
    end
end

end