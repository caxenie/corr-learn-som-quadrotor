function [v_hat] = vec_inv_rot_euler_rp_rad(roll, pitch, v)
n = length(roll);
v_hat=zeros(3,n);

roll = toDeg(roll);
pitch = toDeg(pitch);

for k=1:n
  
    if(roll(k) > -180 || roll(k) < 180 )
        v_hat(:,k) = rotx(roll(k)) * v(:,k);
    end
    
    if(pitch(k) > -180 || pitch(k) < 180 )
        v_hat(:,k) = roty(pitch(k)) * v_hat(:,k);
    end
end

end