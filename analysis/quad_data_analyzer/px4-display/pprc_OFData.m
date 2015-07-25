function [OF] = pprc_OFData(ld,t,offsetInterval)

if(isfield(ld,'of') == 0)
    OF = [];
    return;
end

quality = ld.of.quality / 255;

% threshold at 70 %
% thres = 0.7;
thres = 0.5;
ind = (quality >= thres);

if(~any(ind))
    OF = [];
    return; 
end

% remove non valid entries
vx_val          = ld.of.flow_comp_m_x(ind);
vy_val          = ld.of.flow_comp_m_y(ind);
h_val(1,:)      = ld.of.ground_distance(ind);
t_val(1,:)      = ld.of.hrt.t(ind);

% filter data
N   = 2;
Fc  = 1;
vel(1,:)        = filtfilt_BWLP(vx_val, N, Fc, ld.of.hrt.freq_mean);
vel(2,:)        = filtfilt_BWLP(vy_val, N, Fc, ld.of.hrt.freq_mean);

h(1,:)          = h_val;

OF.vel(1,:)     = interpolateData(vel(1,:), t_val, t); 
OF.vel(2,:)     = interpolateData(vel(2,:), t_val, t); 
OF.h            = interpolateData(h, t_val, t); 


end





