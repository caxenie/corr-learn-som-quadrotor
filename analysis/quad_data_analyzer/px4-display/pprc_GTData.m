function [GT] = pprc_GTData(ld,t,offsetInterval)

if(isfield(ld,'rb') == 0)
    GT = [];
    return;
end

% attention: we have different cosys
ld.rb.pos = [ld.rb.z';-ld.rb.x';-ld.rb.y'];


% make sure that the rotations are valid
n = ld.rb.n;

for k=1:n
if(toDeg(ld.rb.roll(k)) > 90 && toDeg(ld.rb.pitch(k)) < -90)

    ld.rb.roll(k) = -toRad(180) + ld.rb.roll(k);
    ld.rb.pitch(k) = toRad(180) + ld.rb.pitch(k);
    ld.rb.yaw(k) = -ld.rb.yaw(k) - toRad(180);
end
end

for k=1:n
if(toDeg(ld.rb.roll(k)) > 90 && toDeg(ld.rb.pitch(k)) > 90)

    ld.rb.roll(k) = -toRad(180) + ld.rb.roll(k);
    ld.rb.pitch(k) = -toRad(180) + ld.rb.pitch(k);
    ld.rb.yaw(k) = -ld.rb.yaw(k) - toRad(180);
end
end

% numerically differentiate positions
v_raw           = numDiff_vec(ld.rb.pos,ld.rb.hrt.dt_mean);

% low pass filter raw vel signal
ld.rb.vel       = filtfilt_BWLP_vec(v_raw,2,3,ld.rb.hrt.freq_mean);

% numerically differentiate velocities
a_raw           = numDiff_vec(ld.rb.vel,ld.rb.hrt.dt_mean);

% low pass filter raw acc signal
ld.rb.acc       = filtfilt_BWLP_vec(a_raw,2,3,ld.rb.hrt.freq_mean);


int = offsetInterval;
% ground truth data 
GT.rollOff      = mean(-ld.rb.roll(int));
GT.roll(1,:)    = interpolateData( -ld.rb.roll-GT.rollOff, ld.rb.hrt.t, t);  

GT.pitchOff     = mean(ld.rb.pitch(int));
GT.pitch(1,:)   = interpolateData(ld.rb.pitch-GT.pitchOff, ld.rb.hrt.t, t); 

GT.yawOff      = mean(-ld.rb.yaw(int));
GT.yaw(1,:)    = interpolateData(-ld.rb.yaw-GT.yawOff, ld.rb.hrt.t, t); 



GT.zOff         = mean(ld.rb.pos(3,int));

GT.pos(1,:)     = interpolateData(ld.rb.pos(1,:), ld.rb.hrt.t, t); 
GT.pos(2,:)     = interpolateData(ld.rb.pos(2,:), ld.rb.hrt.t, t); 
GT.pos(3,:)     = interpolateData(ld.rb.pos(3,:)-GT.zOff, ld.rb.hrt.t, t); 

GT.h            = -GT.pos(3,:);

GT.vel(1,:)     = interpolateData(ld.rb.vel(1,:), ld.rb.hrt.t, t); 
GT.vel(2,:)     = interpolateData(ld.rb.vel(2,:), ld.rb.hrt.t, t); 
GT.vel(3,:)     = interpolateData(ld.rb.vel(3,:), ld.rb.hrt.t, t); 

GT.acc(1,:)     = interpolateData(ld.rb.acc(1,:), ld.rb.hrt.t, t); 
GT.acc(2,:)     = interpolateData(ld.rb.acc(2,:), ld.rb.hrt.t, t); 
GT.acc(3,:)     = interpolateData(ld.rb.acc(3,:), ld.rb.hrt.t, t); 




end















