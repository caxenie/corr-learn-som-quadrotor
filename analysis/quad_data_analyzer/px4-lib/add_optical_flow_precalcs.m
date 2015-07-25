function [ld_out] = add_optical_flow_precalcs(ld)

if(isfield(ld,'of') == 0)
    ld_out = ld;
    return;
end

quality = ld.of.quality / 255;
th = ones(size(quality));

% threshold at 90 %
th_p = 0.7;
th(quality < th_p) = 0;

ld.of.qth = th_p;

ld.of.i_quality_ok = (quality >= th_p);

ld.of.vx_th   = ld.of.flow_comp_m_x.*th;
ld.of.vy_th   = ld.of.flow_comp_m_y.*th;
ld.of.h_th    = ld.of.ground_distance.*th;

% filter data
ld.of.vx_f = filter_bw_LP(ld.of.vx_th, 2, 2, ld.of.hrt.freq_mean);
ld.of.vy_f = filter_bw_LP(ld.of.vy_th, 2, 2, ld.of.hrt.freq_mean);

% ld.of.vx_f = filter_FIR_LP(ld.of.vx_th, 20, 0.1, ld.of.hrt.freq_mean);
% ld.of.vy_f = filter_FIR_LP(ld.of.vy_th, 20, 0.1, ld.of.hrt.freq_mean);


ld.of.vx_ra = filter_running_average(ld.of.vx_th, 20);
ld.of.vy_ra = filter_running_average(ld.of.vy_th, 20);

ld_out = ld;

end


function [y] = filter_bw_LP(x, N, Fc, Fs)

[z,p,k] = butter(N,Fc/(Fs/2),'low');
[sos,g] = zp2sos(z,p,k);	    % Convert to SOS form
Hf = dfilt.df2tsos(sos,g);      % Create a dfilt object

y = filter(Hf,x);

end

function [y] = filter_FIR_LP(x, N, Fc, Fs)

d = fdesign.lowpass('N,Fc',N,Fc,Fs);
Hf = design(d,'FIR');

y = filter(Hf,x);

end

function [y] = filter_running_average(x, N)

y = filter(ones(1,N)/N,1,x);

end


