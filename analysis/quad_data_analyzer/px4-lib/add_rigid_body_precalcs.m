function [ld_out] = add_rigid_body_precalcs(ld)

if(isfield(ld,'rb') == 0)
    ld_out = ld;
    return;
end

ld.rb.pos = [ld.rb.x';ld.rb.y';ld.rb.z'];

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
ld.rb.raw.v = num_diff_vec(ld.rb.pos,ld.rb.hrt.dt_mean);

% low pass filter raw vel signal
ld.rb.v = filter_vec_bw_LP(ld.rb.raw.v,2,3,ld.rb.hrt.freq_mean);

ld.rb.vx = ld.rb.v(1,:);
ld.rb.vy = ld.rb.v(2,:);
ld.rb.vz = ld.rb.v(3,:);

ld.rb.raw.vx = ld.rb.raw.v(1,:);
ld.rb.raw.vy = ld.rb.raw.v(2,:);
ld.rb.raw.vz = ld.rb.raw.v(3,:);


% numerically differentiate velocities
ld.rb.raw.a = num_diff_vec(ld.rb.v,ld.rb.hrt.dt_mean);

% low pass filter raw acc signal
ld.rb.a = filter_vec_bw_LP(ld.rb.raw.a,2,3,ld.rb.hrt.freq_mean);


ld.rb.ax = ld.rb.a(1,:);
ld.rb.ay = ld.rb.a(2,:);
ld.rb.az = ld.rb.a(3,:);

ld_out = ld;

end


function [deg] = toDeg(rad)
deg = rad/pi*180;
end

function [rad] = toRad(deg)
rad = deg/180*pi;
end


function [vec_f] = filter_vec_bw_LP(vec, N, Fc, Fs)

[z,p,k] = butter(N,Fc/(Fs/2),'low');
[sos,g] = zp2sos(z,p,k);	    % Convert to SOS form
Hf = dfilt.df2tsos(sos,g);      % Create a dfilt object

vec_f(1,:) = filter(Hf,vec(1,:));
vec_f(2,:) = filter(Hf,vec(2,:));
vec_f(3,:) = filter(Hf,vec(3,:));

end


function [vec_f] = filter_vec_FIR_LP(vec, N, Fc, Fs)

d = fdesign.lowpass('N,Fc',N,Fc,Fs);
Hf = design(d,'FIR');

vec_f(1,:) = filter(Hf,vec(1,:));
vec_f(2,:) = filter(Hf,vec(2,:));
vec_f(3,:) = filter(Hf,vec(3,:));

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












