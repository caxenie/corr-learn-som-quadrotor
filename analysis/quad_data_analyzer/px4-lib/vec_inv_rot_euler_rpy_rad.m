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